local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)

require(SquadsCoreParent.LuauPolyfill)

local Promise = require(SquadsCoreParent.Promise)
local React = require(SquadsCoreParent.React)
local SharedFlags = require(SquadsCoreParent.SharedFlags)

require(SquadsCore.Enums.SquadExperienceInviteSource)

local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return (React.createContext({
	showGroupOSADialog = nil,
	closeSquadPrompt = function() -- line: 58
	end,
	createConversation = function(_, _, _, _: string?) -- line: 59
		-- upvalues: Promise (copy)
		return function(_) -- line: 65
			-- upvalues: Promise (copy)
			return Promise.reject("No createConversation function supplied.")
		end
	end,
	createFriendConversation = function(_: string, _) -- line: 69
	end,
	createExperienceInvite = if not FFlagEnableSquadRegroupExperimentation then nil else function(_: string, _) -- line: 71
		-- upvalues: Promise (copy)
		return function(_) -- line: 72
			-- upvalues: Promise (copy)
			return Promise.reject("No createExperienceInvite function supplied.")
		end
	end,
	disableSquadTopBanner = function(_: string, _: boolean) -- line: 77
	end,
	fetchParentChannelDetails = function(_, _) -- line: 78
		return nil
	end,
	fireSquadAnalytics = function(p10, p11) -- line: 81
		return p10, p11
	end,
	inviteToParentChannel = function(_, _, _) -- line: 84
		return nil
	end,
	navigateIntoSquadLobby = function(_, _) -- line: 87
	end,
	removeUserFromParentChannel = function(_, _, _) -- line: 88
		return nil
	end,
	setSquadPrompt = function(_, _) -- line: 91
	end,
	showSearchOverlay = function(_, _) -- line: 92
	end,
	squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else SquadLocationEnum.Unknown,
	updateSquadViewFlags = function(_, _) -- line: 94
	end,
	useGetConversationFromId = function(_: string) -- line: 95
		return nil
	end,
	useIsChatEnabled = function() -- line: 98
		return false
	end,
	useIsLoadingChatSettings = function() -- line: 101
		return false
	end,
	useParentChannelHasGroupUp = function(_: string) -- line: 104
		return false
	end,
	useParentChannelHasSquadAccess = function(_: string) -- line: 107
		return false
	end,
	useParentChannelIsPartyVoiceEligible = function(_: string) -- line: 110
		return nil
	end,
	useParentChannelTitleSelector = function(_: string) -- line: 113
		return ""
	end,
	useSquadRootView = function() -- line: 116
		-- upvalues: SquadRootViewType (copy)
		return SquadRootViewType.None
	end,
	useSquadTopBannerDisabled = function() -- line: 119
		return false
	end,
	useSquadViewFlags = function() -- line: 122
		return 0
	end,
	shouldShowOSAForConversation = function() -- line: 125
		return false
	end
}))
