local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('ecd.fastbelt', 'eclipse-fastbelt') {
  settings+: {
    description: "",
    members_can_change_project_visibility: false,
    name: "Eclipse Fastbelt",
    packages_containers_internal: false,
    packages_containers_public: false,
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
      default_workflow_permissions: "write",
    },
  },
  _repositories+:: [
    orgs.newRepo('fastbelt') {
      allow_update_branch: false,
      delete_branch_on_merge: false,
      description: "High-performance language engineering toolkit for Go",
      has_discussions: true,
      has_wiki: false,
      homepage: "",
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      squash_merge_commit_message: "BLANK",
      squash_merge_commit_title: "PR_TITLE",
      topics+: [
        "dsls",
        "go",
        "golang",
        "languages",
        "lsp",
        "parser"
      ],
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      rulesets: [
        orgs.newRepoRuleset('main') {
          allows_creations: true,
          include_refs+: [
            "~DEFAULT_BRANCH"
          ],
          required_status_checks: null,
          required_pull_request+: {
            required_approving_review_count: 1,
          },
        },
        orgs.newRepoRuleset('release-tags') {
          allows_creations: true,
          allows_force_pushes: true,
          allows_updates: false,
          include_refs+: [
            "refs/tags/v*"
          ],
          required_pull_request: null,
          required_status_checks: null,
          target: "tag",
        },
      ],
    },
    orgs.newRepo('fastbelt-website') {
      allow_update_branch: false,
      delete_branch_on_merge: false,
      dependabot_alerts_enabled: false,
      description: "Source of the Eclipse Fastbelt website",
      gh_pages_build_type: "workflow",
      has_projects: false,
      has_wiki: false,
      homepage: "https://fastbelt.eclipse.dev/",
      topics+: [
        "documentation",
        "language-engineering",
        "language-server-protocol",
        "website"
      ],
      web_commit_signoff_required: false,
      secrets: [
        orgs.newRepoSecret('DEPLOY_PREVIEW_TOKEN') {
          value: "pass:bots/ecd.fastbelt/github.com/preview-token",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "main"
          ],
          deployment_branch_policy: "selected",
        },
        orgs.newEnvironment('pull-request-preview'),
      ],
    },
  ],
} + {
  # snippet added due to 'https://github.com/eclipsefdn/otterdog-configs/blob/main/blueprints/add-dot-github-repo.yml'
  _repositories+:: [
    orgs.newRepo('.github')
  ],
}
