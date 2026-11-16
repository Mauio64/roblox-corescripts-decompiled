local ChatBoxContextMenu = require(script.Components.ChatBoxContextMenu)
local ChatLineReportRoot = require(script.Components.ChatLineReportRoot)
local Constants = require(script.Common.Constants)

return {
	["jest.config"] = script["jest.config"],
	ChatBoxContextMenu = ChatBoxContextMenu,
	ChatLineReportRoot = ChatLineReportRoot,
	Constants = Constants,
	Helpers = {
		getMessageText = require(script.Common.getMessageText),
		isSystemMessage = require(script.Common.isSystemMessage)
	}
}
