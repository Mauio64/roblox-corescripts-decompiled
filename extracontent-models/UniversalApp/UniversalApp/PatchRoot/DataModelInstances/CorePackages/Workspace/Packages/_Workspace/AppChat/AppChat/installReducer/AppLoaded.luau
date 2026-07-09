local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Rodux = require(AppChatParent.Rodux)
local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)

return Rodux.createReducer(false, {
	[SetAppLoaded.name] = function(_, p2) -- line: 9
		return p2.value
	end
})
