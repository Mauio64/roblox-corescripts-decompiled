local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local JestConfigs = require(AppChatParent.Dev.JestConfigs)

return JestConfigs.createBenchmarkConfig("AppChatBenchmarks", {
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		AppChat.setupJest,
		AppChat.setupLogger
	}
})
