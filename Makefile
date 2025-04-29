install:
	@echo "Linking .bashrc to home directory ..."
	@ln -sf $(PWD)/bash/.bashrc ~/.bashrc

	@echo "Prepering Neovim config directory..."
	@mkdir -p ~/.config/nvim

	@echo "Linking init.lua..."
	@ln -sf $(PWD)/nvim/init.lua ~/.config/nvim/init.lua

	@echo "Linking optional folders if they exist (like lua/, lazy/, etc.)..."
	@if [ -d "$(PWD)/nvim/lua" ]; then \
		ln -sfn $(PWD)/nvim/lua ~/.config/nvim/lua; \
	fi
	@if [ -d "$(PWD)/nvim/lazy" ]; then \
		ln -sfn $(PWD)/nvim/lazy ~/.config/nvim/lazy; \
	fi

	@echo "Installation complete! Please restart your terminal or run 'source ~/.bashrc' to apply changes."


