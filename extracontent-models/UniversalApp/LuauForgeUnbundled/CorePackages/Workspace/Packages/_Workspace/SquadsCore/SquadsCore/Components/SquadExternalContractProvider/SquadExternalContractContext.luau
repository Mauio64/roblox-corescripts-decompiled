local SquadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadRootViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadRootViewType")

require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadExperienceInviteSource")
local fFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return React.createContext({
	closeSquadPrompt = function() end,
	createConversation = function(p2, p3, p4, p5)
		return function(p6)
			return Promise.reject("No createConversation function supplied.")
		end
	end,
	createFriendConversation = function(p2, p3) end,
	createExperienceInvite = fFlagEnableSquadRegroupExperimentation and function(p2, p3)
		return function(p4)
			return Promise.reject("No createExperienceInvite function supplied.")
		end
	end or nil,
	disableSquadTopBanner = function(p2, p3) end,
	fetchParentChannelDetails = function(p2, p3): nil
		return nil
	end,
	fireSquadAnalytics = function(p2, p3)
		return p2, p3
	end,
	inviteToParentChannel = function(p2, p3, p4): nil
		return nil
	end,
	navigateIntoSquadLobby = function(p2, p3) end,
	removeUserFromParentChannel = function(p2, p3, p4): nil
		return nil
	end,
	setSquadPrompt = function(p2, p3) end,
	showSearchOverlay = function(p2, p3) end,
	squadLocation = SquadLocationEnum.Unknown,
	updateSquadViewFlags = function(p2, p3) end,
	useGetConversationFromId = function(p2): nil
		return nil
	end,
	useIsChatEnabled = function(): boolean
		return false
	end,
	useIsLoadingChatSettings = function(): boolean
		return false
	end,
	useParentChannelHasGroupUp = function(p2): boolean
		return false
	end,
	useParentChannelHasSquadAccess = function(p2): boolean
		return false
	end,
	useParentChannelIsPartyVoiceEligible = function(p2): nil
		return nil
	end,
	useParentChannelTitleSelector = function(p2): string
		return ""
	end,
	useSquadRootView = function()
		return SquadRootViewType.None
	end,
	useSquadTopBannerDisabled = function(): boolean
		return false
	end,
	useSquadViewFlags = function(): number
		return 0
	end,
	shouldShowOSAForConversation = function(): boolean
		return false
	end,
	showGroupOSADialog = nil
})
