-- set configuration for clangd
---@type vim.lsp.Config
return {
--	capabilities = capabilities,
	cmd = {
		"/usr/bin/clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	filetypes = { "c", "cc", "cxx", "cpp", "objc", "objcpp", "cuda", "proto" },
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
	root_markers = {
		"Makefile",
		"configure.ac",
		"configure.in",
		"config.h.in",
		"meson.build",
		"meson_options.txt",
		"build.ninja",
		".clangd",
		".clang-tidy",
		".clang-format",
		".git",
	},
	single_file_support = true,
}

