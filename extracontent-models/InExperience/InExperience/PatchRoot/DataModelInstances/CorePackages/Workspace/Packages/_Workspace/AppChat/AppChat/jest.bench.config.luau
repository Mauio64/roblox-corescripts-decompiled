local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return JestConfigs.createBenchmarkConfig("AppChatBenchmarks", {
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		AppChat.setupJest,
		AppChat.setupLogger
	}
})
