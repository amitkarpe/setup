# Task Template: 

**create new ec2 (ubuntu) instance using latest AMI**


## Task Details

*   **Repository:** `amitkarpe/setup` ([https://github.com/amitkarpe/setup](https://github.com/amitkarpe/setup))
*   **Local Workspace:** `/home/ec2-user/git/github/setup`
*   **Task Title:**  create new ec2 (ubuntu) instance using latest AMI
*   **Goal:** 
create new ec2 (ubuntu) instance using latest AMI in singapore region 
200 GB volume 
Instance type t3.xlarge
VPC ID: vpc-035eb12babd9ca798 (stata-vpc) 
Subnet ID: subnet-0d13ba2dcbb0f6d46 (stata-subnet-public2-ap-southeast-1b) 
IAM Role: TerraformProductionAccessRole 
Security groups
sg-0276a736dda5e4a3f (default)
sg-01d367382d6cfe56c (dev-dev-demo4)
sg-02828916c4212e616 (imagebuilder)
Key pair assigned at launch: "amit"
either use ami from command line or use latest by checking your self

*   **References:**
    *   [Link/Path to relevant code to reference, e.g., https://github.com/amitkarpe/gitlab/tree/main/docs]
    * Use code from https://github.com/amitkarpe/gitlab/blob/main/docs/run.sh and https://github.com/amitkarpe/gitlab/blob/main/docs/start.sh
*   **Preferences/Constraints:** 
Add installation steps to (documents) in docs/ec2-launch.md
Add installation scripts in scripts/aws folder (with Makefile)
Use a Makefile if appropriate for build/test steps, Follow existing script style.

---

**(Instructions for Cursor AI - Do not modify below this line for the task)**

## AI Workflow Instructions

Okay Cursor, let's tackle the task defined above. Please follow this workflow precisely:

1.  **Acknowledge & Plan:**
    *   Read the "Task Details" section above carefully.
    *   State that you are starting the task: "[Task Title]".
    *   Briefly outline your plan, including the main files you expect to modify or create and the general sequence of steps (e.g., "1. Analyze reference scripts. 2. Add installation commands to `scripts/devops.sh`. 3. Create a test function/script. 4. Update README.").
    * Create new github issue using issues.md specific part
    * Share same issue ID for next steps

2.  **Branch Creation:**
    * Using this issue ID create  
    *   Suggest a suitable branch name based on the task title (e.g., `feature/add-nextflow-support`) and using above issue ID.
    *   Ask me to create this branch locally using a `git checkout -b [suggested-branch-name]` command. Wait for confirmation or execution.

3.  **Implementation:**
    *   Based on your plan and the provided references, proceed with the necessary code changes.
    *   Request specific file edits (using `edit_file`) or provide code snippets incrementally.
    *   Consult the reference links/paths provided in "Task Details" as needed.
    *   If Makefiles are preferred and suitable, propose additions or modifications to a `Makefile`.
    *   Commit changes locally frequently after logical steps are completed. Propose clear commit messages (e.g., "feat: Add Nextflow installation command").

4.  **Documentation:**
    *   Identify or create relevant documentation (e.g., update `README.md`, add comments in scripts).
    *   Propose specific changes to documentation to explain the new functionality or installation steps.
    *   Commit documentation changes.

5.  **Testing:**
    *   Create a test script (e.g., `scripts/test_nextflow.sh`) or add a test function/target (e.g., in a Makefile) to verify the installation or functionality.
    *   The test should perform a basic check (e.g., run `nextflow --version`, `nf-core --version`).
    *   Propose the content for the test script/function.
    *   Commit testing additions.

6.  **Push Branch:**
    *   Once implementation, documentation, and testing additions are committed locally, propose the command to push the feature branch to the remote repository: `git push -u origin [feature-branch-name]`.

7.  **Create Pull Request:**
    *   Propose using the GitHub tool (`mcp_github_create_pull_request`) to create a **Draft Pull Request**.
    *   Specify the `head` branch (your feature branch), `base` branch (`main`), `owner` (`amitkarpe`), `repo` (`setup`).
    *   Suggest a clear PR Title (e.g., "feat: Add Nextflow and nf-core Installation").
    *   Suggest a brief PR body summarizing the changes and linking to this issue (if this `issues.md` is tracked as a GitHub issue, otherwise just summarize).
    *   Set `draft: true`.

8.  **Pause for User Review:**
    *   State clearly: "The feature branch `[feature-branch-name]` has been pushed and a draft Pull Request has been created. **I will now pause and wait for you (Amit Karpe) to review the code, test the changes thoroughly, and provide feedback or approval.**"
    *   Do not proceed further until explicitly told to.

9.  **Final Steps (After User Confirmation):**
    *   **Wait for explicit confirmation** from me (Amit Karpe) that the PR has been reviewed, tested, approved, and **merged into `main`**.
    *   Once confirmation of merge is received, if this task corresponds to a GitHub Issue, propose closing that specific issue using `mcp_github_update_issue` with `state: closed`.
    *   Conclude the task: "Task '[Task Title]' is complete and the corresponding issue (if applicable) has been closed."

**Remember to follow the general Cursor best practices:** Be specific in your requests, break down complex edits, and use the available tools appropriately.
