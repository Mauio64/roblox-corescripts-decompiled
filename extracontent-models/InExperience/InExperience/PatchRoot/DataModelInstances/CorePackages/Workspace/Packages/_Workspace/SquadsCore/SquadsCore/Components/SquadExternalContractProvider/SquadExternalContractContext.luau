local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)

require(parent.LuauPolyfill)
local Promise = require(parent.Promise)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
require(SquadsCore.Enums.SquadExperienceInviteSource)
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return (React.createContext({
	closeSquadPrompt = function() end,
	createConversation = function(_, _, _, _: string?)
		return function(_)
			return Promise.reject("No createConversation function supplied.")
		end
	end,
	createFriendConversation = function(_: string, _) end,
	createExperienceInvite = FFlagEnableSquadRegroupExperimentation and function(_: string, _)
		return function(_)
			return Promise.reject("No createExperienceInvite function supplied.")
		end
	end or nil,
	disableSquadTopBanner = function(_: string, _: boolean) end,
	fetchParentChannelDetails = function(_, _): nil
		return nil
	end,
	fireSquadAnalytics = function(p, p2)
		return p, p2
	end,
	inviteToParentChannel = function(_, _, _): nil
		return nil
	end,
	navigateIntoSquadLobby = function(_, _) end,
	removeUserFromParentChannel = function(_, _, _): nil
		return nil
	end,
	setSquadPrompt = function(_, _) end,
	showSearchOverlay = function(_, _) end,
	squadLocation = SquadLocationEnum.Unknown,
	updateSquadViewFlags = function(_, _) end,
	useGetConversationFromId = function(_: string): nil
		return nil
	end,
	useIsChatEnabled = function(): boolean
		return false
	end,
	useIsLoadingChatSettings = function(): boolean
		return false
	end,
	useParentChannelHasGroupUp = function(_: string): boolean
		return false
	end,
	useParentChannelHasSquadAccess = function(_: string): boolean
		return false
	end,
	useParentChannelIsPartyVoiceEligible = function(_: string): nil
		return nil
	end,
	useParentChannelTitleSelector = function(_: string): string
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
}))
