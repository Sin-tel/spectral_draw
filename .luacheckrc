-- exclude_files = { "**/lib/*.lua" }

std = "max+project+love"
stds.love = {
   globals = { "love" },
}
stds.project = {
   globals = {
      "width",
      "height",
   },
   read_globals = {},
}

ignore = {
   "212", -- unused function arg
   "213", -- unused loop variable
   "561", -- cyclomatic complexity
}

-- allow_defined_top = true
