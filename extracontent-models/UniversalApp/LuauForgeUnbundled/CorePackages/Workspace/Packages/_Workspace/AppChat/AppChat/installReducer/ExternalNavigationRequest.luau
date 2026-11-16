local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")
local CompleteExternalNavigationIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/CompleteExternalNavigationIntoChat")

return Rodux.createReducer({
	screen = nil,
	params = nil,
	requestId = 0,
	completedRequestId = 0
}, {
	[NavigateIntoChat.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			screen = p3.screen,
			params = p3.params,
			requestId = p2.requestId + 1
		})
	end,
	[CompleteExternalNavigationIntoChat.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { completedRequestId = p3.requestId })
	end
})
