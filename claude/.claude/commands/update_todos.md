# Generate Comprehensive TODO List Command

## Command Overview

Analyze the entire codebase to identify optimization opportunities, code improvements, technical debt, and maintenance tasks. Generate a prioritized TODO.md file without implementing any changes.

## Analysis Scope

### Code Quality Assessment
- Scan all source files for TODO, FIXME, HACK, and XXX comments
- Identify code duplication and potential refactoring opportunities
- Find overly complex functions or methods that exceed readability thresholds
- Locate inconsistent coding patterns and style violations
- Detect unused imports, variables, or functions across the codebase

### Performance Optimization Opportunities
- Identify inefficient database queries or N+1 query problems
- Find unoptimized loops, recursive functions, or algorithmic inefficiencies
- Locate missing indexes or suboptimal database schema designs
- Detect memory leaks, excessive object creation, or resource management issues
- Identify caching opportunities for frequently accessed data or computations

### Security & Best Practices Review
- Scan for hardcoded secrets, API keys, or sensitive configuration data
- Identify missing input validation or sanitization
- Find potential SQL injection, XSS, or other security vulnerabilities
- Locate deprecated library usage or outdated dependencies
- Check for missing error handling or improper exception management

### Architecture & Design Improvements
- Identify tight coupling between modules or components
- Find violations of SOLID principles or design patterns
- Locate missing abstractions or overly concrete implementations
- Identify potential single points of failure or scalability bottlenecks
- Find inconsistent API design or missing documentation

### Testing & Quality Assurance Gaps
- Identify functions or modules without adequate test coverage
- Find missing integration tests for critical user flows
- Locate untested edge cases or error conditions
- Identify missing automated tests for recently added features
- Find opportunities for better test organization or test data management

### Documentation & Maintenance
- Identify missing or outdated README files and setup instructions
- Find functions or classes without proper documentation comments
- Locate outdated architectural diagrams or technical specifications
- Identify missing API documentation or endpoint descriptions
- Find configuration files that need better documentation or examples

## TODO Generation Process

### File Structure Analysis
- Examine project structure for organizational improvements
- Identify misplaced files or inconsistent directory naming
- Find missing configuration files for different environments
- Locate opportunities for better separation of concerns
- Check for proper gitignore patterns and repository hygiene

### Dependency & Library Management
- Scan package.json, requirements.txt, or equivalent dependency files
- Identify outdated packages with security vulnerabilities
- Find unused dependencies that can be removed
- Locate missing dependencies that should be explicitly declared
- Check for version conflicts or compatibility issues

### Environment & Configuration Assessment
- Review environment-specific configuration management
- Identify hardcoded environment variables or configuration values
- Find missing configuration for different deployment environments
- Locate opportunities for better secret management
- Check for proper logging and monitoring configuration

### Code Metrics & Complexity Analysis
- Calculate cyclomatic complexity for functions and methods
- Identify files or modules that exceed size or complexity thresholds
- Find functions with too many parameters or excessive nesting
- Locate classes with too many responsibilities or methods
- Check for proper code organization and module boundaries

## Output Format for TODO.md

### Priority Classification System
- **Critical**: Security vulnerabilities, data integrity issues, production blockers
- **High**: Performance bottlenecks, major architectural flaws, missing essential tests
- **Medium**: Code quality improvements, minor optimizations, documentation gaps
- **Low**: Code style inconsistencies, minor refactoring opportunities, nice-to-have features

### Category Organization Structure
- **Security & Compliance**: All security-related improvements and vulnerability fixes
- **Performance & Optimization**: Database queries, algorithm improvements, caching opportunities
- **Code Quality & Refactoring**: Code duplication, complexity reduction, design pattern improvements
- **Testing & Coverage**: Missing tests, test improvements, quality assurance gaps
- **Documentation & Maintenance**: README updates, code comments, architectural documentation
- **Dependencies & Libraries**: Package updates, security patches, unused dependency removal
- **Architecture & Design**: Structural improvements, design pattern applications, scalability enhancements

### Individual TODO Item Format
- **Title**: Brief, descriptive summary of the improvement needed
- **Priority**: Critical, High, Medium, or Low classification
- **Category**: Which improvement area this addresses
- **Description**: Detailed explanation of the issue and why it needs attention
- **Location**: Specific files, functions, or modules affected
- **Estimated Effort**: Time estimate for implementation (Small, Medium, Large)
- **Dependencies**: Other TODOs or external factors that must be addressed first
- **Business Impact**: How this improvement affects users, performance, or maintainability

### Cross-Reference and Grouping
- Group related TODOs that should be addressed together
- Identify dependencies between different improvement tasks
- Highlight TODOs that affect multiple areas of the codebase
- Create logical implementation sequences for efficient completion
- Note TODOs that require coordination between different development domains

## Analysis Guidelines

### Static Code Analysis Integration
- Use appropriate linting tools and static analyzers for the technology stack
- Integrate with code quality tools like SonarQube, CodeClimate, or language-specific analyzers
- Leverage IDE warnings and compiler messages for improvement opportunities
- Use automated tools to detect common anti-patterns and code smells
- Integrate security scanning tools to identify potential vulnerabilities

### Manual Review Considerations
- Look for business logic that could be simplified or clarified
- Identify user experience improvements in interfaces and error messages
- Find opportunities for better error handling and user feedback
- Locate areas where performance monitoring or logging could be improved
- Check for accessibility improvements in user-facing components

### Historical Analysis
- Review recent commit history for patterns of frequent bug fixes in specific areas
- Identify files or modules that change frequently and might benefit from refactoring
- Look for recurring issues reported in bug tracking systems
- Find areas where technical debt has been accumulating over time
- Identify features or components that consistently require maintenance

## Exclusion Criteria

### Items to Skip
- Do not include TODOs for experimental or prototype code that is intended to be temporary
- Skip TODOs for third-party libraries or vendor code that cannot be modified
- Exclude improvements that require significant business requirement changes
- Do not include TODOs that would require breaking changes without clear business value
- Skip micro-optimizations that provide negligible performance benefits

### Scope Limitations
- Focus on actionable improvements that can be implemented by the development team
- Prioritize improvements that provide clear measurable benefits
- Exclude improvements that require significant infrastructure or platform changes
- Focus on code and architecture improvements rather than business feature additions
- Limit suggestions to improvements that align with current technology choices

## Command Execution Instructions

### Pre-Analysis Setup
- Ensure all development dependencies are installed and up to date
- Run any existing code quality tools to gather baseline metrics
- Review recent pull requests or code reviews for commonly identified issues
- Check project documentation for known technical debt or improvement areas
- Verify that all code is committed and the working directory is clean

### Analysis Execution
- Systematically examine each directory and file type in the project
- Run automated analysis tools and aggregate their findings
- Perform manual code review using established quality criteria
- Document findings with specific file locations and line numbers when applicable
- Cross-reference findings to identify patterns and related issues

### Output Generation
- Create a comprehensive TODO.md file with all identified improvements
- Organize TODOs by priority and category for easy navigation
- Include summary statistics about the number and types of improvements identified
- Add timestamps and analysis scope to the generated file
- Provide clear next steps for addressing the highest priority items

This command will generate a comprehensive, actionable TODO list that serves as a roadmap for improving code quality, performance, and maintainability without overwhelming the development team with unnecessary changes.
