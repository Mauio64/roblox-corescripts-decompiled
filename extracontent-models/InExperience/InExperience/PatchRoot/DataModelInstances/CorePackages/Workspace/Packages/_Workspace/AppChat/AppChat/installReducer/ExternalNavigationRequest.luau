local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Rodux = require(AppChatParent.Rodux)
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local CompleteExternalNavigationIntoChat = require(AppChat.Actions.CompleteExternalNavigationIntoChat)
local t1 = {
	screen = nil,
	params = nil,
	requestId = 0,
	completedRequestId = 0
}

return Rodux.createReducer(t1, {
	[NavigateIntoChat.name] = function(p1, p2) -- line: 18
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			screen = p2.screen,
			params = p2.params,
			requestId = p1.requestId + 1
		})
	end,
	[CompleteExternalNavigationIntoChat.name] = function(p3, p4) -- line: 26
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			completedRequestId = p4.requestId
		})
	end
})
