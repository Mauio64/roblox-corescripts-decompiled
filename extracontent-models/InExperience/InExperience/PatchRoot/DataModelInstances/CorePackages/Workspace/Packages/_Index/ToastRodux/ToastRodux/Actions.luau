local MarkCurrentToastMessageAsRead = require(script.MarkCurrentToastMessageAsRead)
local RemoveAllToastMessages = require(script.RemoveAllToastMessages)
local RemoveCurrentToastMessage = require(script.RemoveCurrentToastMessage)
local SetCurrentToastMessage = require(script.SetCurrentToastMessage)

return {
	MarkCurrentToastMessageAsRead = MarkCurrentToastMessageAsRead,
	RemoveAllToastMessages = RemoveAllToastMessages,
	RemoveCurrentToastMessage = RemoveCurrentToastMessage,
	SetCurrentToastMessage = SetCurrentToastMessage
}
