.PHONY: *

## Shows all available commands with their description
help:
	@echo "Available Commands:"
	@awk ' \
		/^##/ { help = substr($$0, 4); next } \
		/^[a-zA-Z0-9_-]+:/ { \
			if (help) { \
				printf "\033[36m%-20s\033[0m %s\n", $$1, help; \
				help = ""; \
			} \
		}' $(MAKEFILE_LIST)

SUBMODULES := ll001-demo ll002-blog ll003-breeze-demo ll004-pixel-positions

## Updates all submodules to the latest commit on the main branch
update:
	@echo "Starting SSH agent..."
	@eval $$(ssh-agent -s) && ssh-add $$SSH_KEY_PATH && { \
		echo "Updating submodules..."; \
		for submodule in $(SUBMODULES); do \
			echo "Updating $$submodule..."; \
			cd $$submodule && git fetch && git checkout main && git pull origin main && cd ..; \
			git add $$submodule; \
		done; \
		git diff-index --quiet HEAD -- || git commit -m "chore(submodules): update all submodules to latest commit on the main branch"; \
		echo "All submodules updated."; \
		kill $$SSH_AGENT_PID; \
	}
