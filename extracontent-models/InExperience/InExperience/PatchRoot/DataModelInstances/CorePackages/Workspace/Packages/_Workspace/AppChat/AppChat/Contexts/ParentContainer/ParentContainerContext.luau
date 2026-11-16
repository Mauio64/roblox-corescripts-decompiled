local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Promise = require(parent.Promise)
local React = require(parent.React)
local SocialCommon = require(parent.SocialCommon)
require(AppChat.App.InExperienceAppChatModal)

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
	openFriendsChatConversation = function(_: string)
		return Promise.resolve(false)
	end
})
