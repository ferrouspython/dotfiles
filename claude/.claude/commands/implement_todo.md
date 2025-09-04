# Implement TODO Task Command

## Command Overview

Select and implement a specific task from the TODO.md file using the incremental development framework. The assistant will ask clarifying questions, break down the work into testable chunks, and implement the solution following test-driven development principles.

## Command Execution Process

### Phase 1: Task Selection and Analysis

#### TODO Item Identification
- Ask the user to specify which TODO item they want to implement
- Accept either the TODO title, item number, or general description
- Locate the specific TODO in the TODO.md file and display its full details
- Confirm this is the correct task before proceeding with analysis

#### Requirement Clarification Questions
- **Scope Confirmation**: "What is the exact scope you want to implement? Should I address the entire TODO or focus on a specific aspect?"
- **Priority Assessment**: "What is the urgency for this implementation? Do you need a quick fix or a comprehensive solution?"
- **Integration Constraints**: "Are there any existing systems, APIs, or components I need to be careful not to break?"
- **Business Context**: "Are there any business rules, user requirements, or edge cases I should be aware of for this implementation?"
- **Technical Preferences**: "Do you have any preferences for implementation approach, design patterns, or technology choices?"

#### Impact Analysis Questions
- **Dependencies**: "Are there other TODO items or features that this implementation depends on or might conflict with?"
- **Testing Requirements**: "What level of testing do you expect? Unit tests only, or should I include integration and end-to-end testing?"
- **Performance Considerations**: "Are there specific performance requirements or constraints I should optimize for?"
- **Backward Compatibility**: "Do I need to maintain backward compatibility with existing implementations?"
- **Security Implications**: "Are there security considerations or compliance requirements for this change?"

### Phase 2: Technical Planning and Design

#### Architecture and Design Questions
- **Design Pattern Preferences**: "Should I follow any specific design patterns or architectural principles for this implementation?"
- **Error Handling Strategy**: "How should I handle errors and edge cases? Do you have preferred error handling patterns?"
- **Logging and Monitoring**: "What level of logging or monitoring should I include with this implementation?"
- **Configuration Management**: "Should any aspects of this implementation be configurable? If so, what configuration approach should I use?"
- **Code Organization**: "Where should I place the new code? Should I create new files or modify existing ones?"

#### Implementation Approach Questions
- **Incremental Strategy**: "Would you like me to implement this in multiple phases, or tackle it all at once? What would be logical milestone checkpoints?"
- **Testing Strategy**: "Should I write tests first (TDD approach) or implement the feature first and then add tests?"
- **Documentation Requirements**: "What level of documentation do you expect? Code comments, README updates, API documentation?"
- **Review Process**: "Do you want to review the implementation plan before I start coding, or should I proceed directly to implementation?"
- **Rollback Strategy**: "Should I implement this change in a way that allows easy rollback if issues are discovered?"

### Phase 3: Work Breakdown and Planning

#### Task Decomposition Process
- Break the TODO item into the smallest possible testable increments
- Identify dependencies between different parts of the implementation
- Determine the order of implementation for each increment
- Estimate effort and complexity for each piece
- Plan integration points and testing strategies

#### Increment Planning Questions
- **Increment Size**: "Do you prefer smaller, more frequent increments that you can review often, or larger increments that show more substantial progress?"
- **Testing Checkpoints**: "At what points during implementation would you like me to pause for testing and validation?"
- **Feedback Loops**: "How often would you like progress updates? After each increment or at specific milestones?"
- **Risk Mitigation**: "Are there any high-risk aspects of this implementation where you'd like extra caution or additional validation?"
- **Integration Timing**: "Should I integrate changes continuously or wait until the entire TODO is complete?"

### Phase 4: Implementation Execution

#### Pre-Implementation Verification
- Confirm understanding of all requirements and constraints
- Verify that the development environment is properly set up
- Ensure all necessary dependencies and tools are available
- Create a backup or branch point for safe experimentation
- Validate that existing tests pass before making any changes

#### Incremental Implementation Process
- Follow the Red-Green-Refactor cycle for each increment
- Implement the smallest possible working piece of functionality
- Write comprehensive tests for each increment
- Validate integration with existing code after each increment
- Document progress and any discoveries or issues encountered

#### Progress Communication
- Report completion of each increment with before/after comparisons
- Communicate any discovered issues, design changes, or requirement clarifications
- Ask for feedback on completed increments before proceeding to the next
- Update the TODO.md file to reflect progress or mark items as complete
- Share insights that might benefit other TODO items or development work

### Phase 5: Validation and Integration

#### Testing and Quality Assurance
- Run comprehensive test suite to ensure no regressions
- Perform manual testing of the implemented functionality
- Validate performance characteristics meet requirements
- Check security implications and access control behavior
- Verify documentation and code comments are accurate and helpful

#### Final Validation Questions
- **Acceptance Criteria**: "Does this implementation meet all the requirements from the original TODO item?"
- **Edge Case Coverage**: "Are there any edge cases or error conditions you'd like me to test specifically?"
- **Performance Validation**: "Should I run performance tests or benchmarks to validate the implementation?"
- **User Experience**: "For user-facing changes, would you like to review the user experience before considering this complete?"
- **Deployment Readiness**: "Is this implementation ready for deployment, or are there additional steps needed?"

## Dynamic Question Framework

### Contextual Question Selection
- Ask questions appropriate to the specific type of TODO being implemented
- Adapt question depth based on the complexity and risk level of the task
- Skip obvious questions when the TODO item already provides clear guidance
- Focus on areas where clarification would prevent rework or misunderstanding

### Progressive Clarification
- Start with high-level scope and approach questions
- Drill down into technical details as the conversation progresses
- Ask follow-up questions based on previous answers
- Clarify any ambiguities or conflicts between requirements

### Risk-Based Inquiry
- Ask more detailed questions for high-risk or complex implementations
- Focus on areas where assumptions could lead to significant rework
- Verify understanding of critical business logic or user workflows
- Ensure clarity on integration points and external dependencies

## Implementation Guidelines

### Code Quality Standards
- Follow the incremental development framework for all implementations
- Maintain or improve existing code quality metrics
- Use consistent coding patterns and style throughout the implementation
- Include appropriate error handling and logging
- Write clear, maintainable code with proper documentation

### Testing Requirements
- Implement comprehensive automated tests for all new functionality
- Ensure existing tests continue to pass after implementation
- Add integration tests for new integration points
- Include performance tests for performance-critical changes
- Validate security and access control for security-related implementations

### Documentation Standards
- Update relevant documentation files and README instructions
- Add clear code comments explaining complex logic or business rules
- Update API documentation for interface changes
- Document any configuration changes or new environment requirements
- Update architectural diagrams if structural changes are made

## Success Criteria

### Implementation Completion Indicators
- All acceptance criteria from the TODO item are satisfied
- Comprehensive tests pass and provide adequate coverage
- Integration with existing systems works correctly
- Performance meets or exceeds specified requirements
- Documentation is complete and accurate

### Quality Validation
- Code review standards are met
- No security vulnerabilities are introduced
- Backward compatibility is maintained where required
- Error handling covers expected edge cases
- Logging and monitoring provide appropriate visibility

This command ensures that TODO implementations are thoughtful, well-planned, and executed with the highest quality standards while gathering all necessary context through strategic questioning.
