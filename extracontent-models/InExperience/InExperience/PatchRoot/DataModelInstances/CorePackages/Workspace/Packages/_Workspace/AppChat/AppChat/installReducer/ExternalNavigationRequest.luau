local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local CompleteExternalNavigationIntoChat = require(AppChat.Actions.CompleteExternalNavigationIntoChat)

return Rodux.createReducer({ screen = nil, params = nil, requestId = 0, completedRequestId = 0 }, {
	[NavigateIntoChat.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			screen = p2.screen,
			params = p2.params,
			requestId = p.requestId + 1
		})
	end,
	[CompleteExternalNavigationIntoChat.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { completedRequestId = p2.requestId })
	end
})
