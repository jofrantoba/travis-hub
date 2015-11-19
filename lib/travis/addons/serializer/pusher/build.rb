require 'travis/addons/serializer/formats'

module Travis
  module Addons
    module Serializer
      module Pusher
        class Build
          include Formats

          attr_reader :build, :options

          def initialize(build, options = {})
            @build = build
            @options = options
          end

          def data
            {
              build: build_data(build),
              commit: commit_data(build.commit),
              repository: repository_data(build.repository)
            }
          end

          private

            def build_data(build)
              commit = build.commit
              {
                id: build.id,
                repository_id: build.repository_id,
                commit_id: build.commit_id,
                number: build.number,
                pull_request: build.pull_request?,
                pull_request_title: build.pull_request_title,
                pull_request_number: build.pull_request_number,
                state: build.state.to_s,
                started_at: format_date(build.started_at),
                finished_at: format_date(build.finished_at),
                duration: build.duration,
                job_ids: build.job_ids,
                event_type: build.event_type,

                is_on_default_branch: on_default_branch?(build),

                # this is a legacy thing, we should think about removing it
                commit: commit.commit,
                branch: commit.branch,
                message: commit.message,
                compare_url: commit.compare_url,
                committed_at: format_date(commit.committed_at),
                author_name: commit.author_name,
                author_email: commit.author_email,
                committer_name: commit.committer_name,
                committer_email: commit.committer_email
              }
            end

            def commit_data(commit)
              {
                id: commit.id,
                sha: commit.commit,
                branch: commit.branch,
                message: commit.message,
                committed_at: format_date(commit.committed_at),
                author_name: commit.author_name,
                author_email: commit.author_email,
                committer_name: commit.committer_name,
                committer_email: commit.committer_email,
                compare_url: commit.compare_url,
              }
            end

            def repository_data(repository)
              {
                id: repository.id,
                slug: repository.slug,
                description: repository.description,
                private: repository.private,
                last_build_id: repository.last_build_id,
                last_build_number: repository.last_build_number,
                last_build_state: repository.last_build_state.to_s,
                last_build_duration: repository.last_build_duration,
                last_build_language: nil,
                last_build_started_at: format_date(repository.last_build_started_at),
                last_build_finished_at: format_date(repository.last_build_finished_at),
                github_language: repository.github_language
              }
            end

            def on_default_branch?(build)
              build.repository.default_branch == build.commit.branch
            end
        end
      end
    end
  end
end
