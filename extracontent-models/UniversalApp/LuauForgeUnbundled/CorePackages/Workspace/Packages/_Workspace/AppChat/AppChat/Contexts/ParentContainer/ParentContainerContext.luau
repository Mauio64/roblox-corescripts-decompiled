local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChatModal")

return React.createContext({
	getParentContainer = function(): nil
		return nil
	end,
	visibilitySignal = Instance.new("BindableEvent"),
	getRequestedRoute = function(): nil
		return nil
	end,
	requestedRouteSignal = Instance.new("BindableEvent"),
	clearRequestedRoute = function() end,
	getShouldSetAppChatVisible = function(): boolean
		return false
	end,
	entryPoint = SocialCommon.Enums.ChatEntryPointNames.Unknown,
	showParentContainer = function() end,
	hideParentContainer = function() end,
	updateCurrentSquadId = function() end,
	openFriendsChatConversation = function(p2)
		return Promise.resolve(false)
	end
})
