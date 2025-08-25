;; User Management Contract
;; Handles user registration, profiles, and KYC status

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-USER-EXISTS (err u101))
(define-constant ERR-USER-NOT-FOUND (err u102))
(define-constant ERR-INVALID-INPUT (err u103))
(define-constant ERR-KYC-REQUIRED (err u104))

;; Contract owner
(define-constant CONTRACT-OWNER tx-sender)

;; User data structure
(define-map users
  { user-address: principal }
  {
    name: (string-ascii 100),
    email: (string-ascii 100),
    credit-score: uint,
    kyc-status: bool,
    user-type: (string-ascii 20),
    registration-date: uint,
    is-active: bool
  }
)

;; User statistics
(define-map user-stats
  { user-address: principal }
  {
    total-borrowed: uint,
    total-invested: uint,
    loans-completed: uint,
    default-count: uint,
    last-activity: uint
  }
)

;; Total registered users counter
(define-data-var total-users uint u0)

;; Register a new user
(define-public (register-user (user-address principal) (name (string-ascii 100)) (email (string-ascii 100)) (credit-score uint))
  (begin
    (asserts! (is-none (map-get? users { user-address: user-address })) ERR-USER-EXISTS)
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len email) u0) ERR-INVALID-INPUT)
    (asserts! (and (>= credit-score u300) (<= credit-score u850)) ERR-INVALID-INPUT)

    (map-set users
      { user-address: user-address }
      {
        name: name,
        email: email,
        credit-score: credit-score,
        kyc-status: false,
        user-type: "pending",
        registration-date: block-height,
        is-active: true
      }
    )

    (map-set user-stats
      { user-address: user-address }
      {
        total-borrowed: u0,
        total-invested: u0,
        loans-completed: u0,
        default-count: u0,
        last-activity: block-height
      }
    )

    (var-set total-users (+ (var-get total-users) u1))
    (ok true)
  )
)

;; Update KYC status (admin only)
(define-public (update-kyc-status (user-address principal) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? users { user-address: user-address })) ERR-USER-NOT-FOUND)

    (map-set users
      { user-address: user-address }
      (merge (unwrap-panic (map-get? users { user-address: user-address }))
        { kyc-status: status }
      )
    )
    (ok true)
  )
)

;; Set user type (borrower/investor)
(define-public (set-user-type (user-address principal) (user-type (string-ascii 20)))
  (begin
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER) (is-eq tx-sender user-address)) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? users { user-address: user-address })) ERR-USER-NOT-FOUND)
    (asserts! (or (is-eq user-type "borrower") (is-eq user-type "investor") (is-eq user-type "both")) ERR-INVALID-INPUT)

    (map-set users
      { user-address: user-address }
      (merge (unwrap-panic (map-get? users { user-address: user-address }))
        { user-type: user-type }
      )
    )
    (ok true)
  )
)

;; Update credit score
(define-public (update-credit-score (user-address principal) (new-score uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? users { user-address: user-address })) ERR-USER-NOT-FOUND)
    (asserts! (and (>= new-score u300) (<= new-score u850)) ERR-INVALID-INPUT)

    (map-set users
      { user-address: user-address }
      (merge (unwrap-panic (map-get? users { user-address: user-address }))
        { credit-score: new-score }
      )
    )
    (ok true)
  )
)

;; Update user statistics
(define-public (update-user-stats (user-address principal) (borrowed uint) (invested uint) (completed uint) (defaults uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? users { user-address: user-address })) ERR-USER-NOT-FOUND)

    (map-set user-stats
      { user-address: user-address }
      {
        total-borrowed: borrowed,
        total-invested: invested,
        loans-completed: completed,
        default-count: defaults,
        last-activity: block-height
      }
    )
    (ok true)
  )
)

;; Get user profile
(define-read-only (get-user (user-address principal))
  (map-get? users { user-address: user-address })
)

;; Get user statistics
(define-read-only (get-user-stats (user-address principal))
  (map-get? user-stats { user-address: user-address })
)

;; Check if user is KYC verified
(define-read-only (is-kyc-verified (user-address principal))
  (match (map-get? users { user-address: user-address })
    user-data (get kyc-status user-data)
    false
  )
)

;; Get total registered users
(define-read-only (get-total-users)
  (var-get total-users)
)

;; Check if user can borrow (KYC + active + borrower type)
(define-read-only (can-borrow (user-address principal))
  (match (map-get? users { user-address: user-address })
    user-data (and
      (get kyc-status user-data)
      (get is-active user-data)
      (or (is-eq (get user-type user-data) "borrower") (is-eq (get user-type user-data) "both"))
    )
    false
  )
)

;; Check if user can invest (KYC + active + investor type)
(define-read-only (can-invest (user-address principal))
  (match (map-get? users { user-address: user-address })
    user-data (and
      (get kyc-status user-data)
      (get is-active user-data)
      (or (is-eq (get user-type user-data) "investor") (is-eq (get user-type user-data) "both"))
    )
    false
  )
)
