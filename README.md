# Peer-to-Peer Lending Platform

A decentralized lending platform built on Stacks blockchain using Clarity smart contracts, enabling direct lending between borrowers and investors with automated risk assessment and loan servicing.

## System Architecture

The platform consists of five core smart contracts:

### 1. User Management Contract (`user-management.clar`)
- User registration and profile management
- KYC status tracking
- User role assignment (borrower/investor)
- Credit history maintenance

### 2. Credit Assessment Contract (`credit-assessment.clar`)
- Credit score calculation and risk scoring
- Income verification and debt-to-income ratio analysis
- Credit history evaluation
- Risk tier assignment (A, B, C, D, E)

### 3. Loan Management Contract (`loan-management.clar`)
- Loan application creation and management
- Loan terms definition (amount, interest rate, duration)
- Loan status tracking (pending, active, completed, defaulted)
- Collateral management

### 4. Investor Matching Contract (`investor-matching.clar`)
- Investor profile and risk tolerance management
- Automated matching algorithm based on risk preferences
- Investment allocation and portfolio management
- Return calculation and distribution

### 5. Payment Processing Contract (`payment-processing.clar`)
- Automated payment collection and distribution
- Late payment tracking and penalty calculation
- Default detection and recovery initiation
- Regulatory compliance reporting

## Key Features

### For Borrowers
- **Credit Assessment**: Automated credit scoring based on financial data
- **Competitive Rates**: Market-driven interest rates based on risk profile
- **Flexible Terms**: Various loan amounts and repayment periods
- **Transparent Process**: Clear loan terms and payment schedules

### For Investors
- **Risk-Based Matching**: Investment opportunities matched to risk tolerance
- **Diversified Portfolio**: Automatic allocation across multiple loans
- **Automated Returns**: Passive income through automated payment collection
- **Risk Management**: Built-in default protection and recovery mechanisms

### Platform Features
- **Regulatory Compliance**: Built-in compliance with consumer lending regulations
- **Automated Servicing**: Hands-off loan management and payment processing
- **Default Recovery**: Systematic approach to handling loan defaults
- **Transparent Reporting**: Real-time loan performance and portfolio analytics

## Risk Management

### Credit Tiers
- **Tier A**: Excellent credit (< 2% default risk)
- **Tier B**: Good credit (2-5% default risk)
- **Tier C**: Fair credit (5-10% default risk)
- **Tier D**: Poor credit (10-20% default risk)
- **Tier E**: High risk (> 20% default risk)

### Default Protection
- Automated early warning system for payment delays
- Graduated collection process with increasing intervention
- Legal recovery coordination for defaulted loans
- Investor protection through diversification requirements

## Technical Implementation

### Smart Contract Architecture
- **Modular Design**: Separate contracts for distinct functionality
- **Data Integrity**: Comprehensive validation and error handling
- **Security**: Built-in protection against common vulnerabilities
- **Scalability**: Efficient data structures and gas optimization

### Compliance Features
- **Regulatory Reporting**: Automated generation of required reports
- **Interest Rate Caps**: Enforcement of legal interest rate limits
- **Consumer Protection**: Built-in cooling-off periods and disclosure requirements
- **Data Privacy**: Secure handling of sensitive financial information

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Basic understanding of Clarity smart contracts

### Installation
\`\`\`bash
npm install
clarinet check
clarinet test
\`\`\`

### Testing
\`\`\`bash
npm test
\`\`\`

### Deployment
\`\`\`bash
clarinet deploy
\`\`\`

## Contract Interactions

### User Registration
```clarity
(contract-call? .user-management register-user 
  "user-address" 
  "John Doe" 
  "john@example.com" 
  u750)  ;; credit score
