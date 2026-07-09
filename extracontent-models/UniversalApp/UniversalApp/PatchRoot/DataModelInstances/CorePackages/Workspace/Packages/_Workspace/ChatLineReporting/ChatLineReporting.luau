local ChatBoxContextMenu = require(script.Components.ChatBoxContextMenu)
local ChatLineReportRoot = require(script.Components.ChatLineReportRoot)
local ChatLineReportSelectionModal = require(script.Components.ChatLineReportSelectionModal)
local ChatLineSelectionMode = require(script.Enums.ChatLineSelectionMode)
local Constants = require(script.Common.Constants)

return {
	["jest.config"] = script["jest.config"],
	ChatBoxContextMenu = ChatBoxContextMenu,
	ChatLineReportRoot = ChatLineReportRoot,
	ChatLineReportSelectionModal = ChatLineReportSelectionModal,
	Constants = Constants,
	Enums = {
		ChatLineSelectionMode = ChatLineSelectionMode
	},
	Helpers = {
		getMessageText = require(script.Common.getMessageText),
		isSystemMessage = require(script.Common.isSystemMessage)
	}
}
