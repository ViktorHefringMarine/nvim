require('code_runner').setup({
  -- put here the commands by filetype
  filetype = {
		java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
		python = "python3 -u",
		typescript = "npm run dev",
		rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt"
	},
})
