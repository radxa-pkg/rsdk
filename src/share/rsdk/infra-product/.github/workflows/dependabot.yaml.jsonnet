function() std.manifestYamlDoc(
    {
        name: "Dependabot auto-merge",
        on: {
            pull_request: {},
        },
        permissions: {
            contents: "write",
            "pull-requests": "write",
        },
        jobs: {
            dependabot: {
                "runs-on": "ubuntu-latest",
                "if": "github.actor == 'dependabot[bot]'",
                steps: [
                    {
                        name: "Dependabot metadata",
                        id: "metadata",
                        uses: "dependabot/fetch-metadata@v2",
                        with: {
                            "github-token": "${{ secrets.GITHUB_TOKEN }}",
                        },
                    },
                    {
                        name: "Approve a PR & Enable auto-merge for Dependabot PRs",
                        run: |||
                            gh pr review --approve "$PR_URL"
                            gh pr merge --auto --merge "$PR_URL"
                        |||,
                        env: {
                            PR_URL: "${{github.event.pull_request.html_url}}",
                            GH_TOKEN: "${{secrets.GITHUB_TOKEN}}",
                        },
                    },
                ],
            },
        },
    },
    quote_keys=false,
)
