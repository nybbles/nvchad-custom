local options = {
  -- cmd = { "jdtls" },
  cmd = {
    "/home/nimalan/.local/share/nvim/mason/bin/jdtls",
    "-configuration",
    "/home/nimalan/.cache/jdtls/config",
    "-data",
    "/home/nimalan/.cache/jdtls/workspace",
  },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]
  ),
  -- root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', "build.gradle", "pom.xml"}),
}

return options
