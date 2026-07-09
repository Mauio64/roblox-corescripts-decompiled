local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)

game:DefineFastFlag("AppChatTopBarConfigDrivenV6", false)

return function() -- line: 6
	-- upvalues: FFlagAppChatTopBarSignalsStore (copy)
	return game:GetFastFlag("AppChatTopBarConfigDrivenV6") and FFlagAppChatTopBarSignalsStore
end
