local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Promise = require(SquadsCoreParent.Promise)

require(SquadsCore.Enums.SquadExperienceInviteSource)

local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)

require(script.Parent.SquadContractType)

local FFlagEnableSquadRegroupExperimentation = require(SquadsCoreParent.SharedFlags).FFlagEnableSquadRegroupExperimentation

return {
	closeSquadPrompt = function() -- line: 16
	end,
	createConversation = function(_, _, _, _: string?) -- line: 19
		-- upvalues: Promise (copy)
		return function(_) -- line: 25
			-- upvalues: Promise (copy)
			return Promise.reject("No createConversation function supplied.")
		end
	end,
	createFriendConversation = function(_: string, _) -- line: 29
	end,
	createExperienceInvite = if not FFlagEnableSquadRegroupExperimentation then nil else function(_: string, _, _) -- line: 33
		-- upvalues: Promise (copy)
		return function(_) -- line: 34
			-- upvalues: Promise (copy)
			return Promise.reject("No createExperienceInvite function supplied.")
		end
	end,
	fetchParentChannelDetails = function(_, _) -- line: 39
		return nil
	end,
	inviteToParentChannel = function(_, _, _) -- line: 42
		return function(_) -- line: 43
			return nil
		end
	end,
	navigateIntoSquadLobby = function(_, _) -- line: 47
	end,
	removeUserFromParentChannel = function(_, _, _) -- line: 50
		return function(_) -- line: 51
			return nil
		end
	end,
	setSquadPrompt = function(_, _) -- line: 55
	end,
	showSearchOverlay = function(_, _) -- line: 58
	end,
	useIsChatEnabled = function() -- line: 61
		return false
	end,
	useGetConversationFromId = function(_) -- line: 64
		return nil
	end,
	useParentChannelHasGroupUp = function(_) -- line: 67
		return false
	end,
	useParentChannelHasSquadAccess = function(_) -- line: 70
		return false
	end,
	useParentChannelTitleSelector = function(_) -- line: 73
		return ""
	end,
	useParentChannelIsPartyVoiceEligible = function(_) -- line: 76
		return nil
	end,
	useSquadRootView = function() -- line: 79
		-- upvalues: SquadRootViewType (copy)
		return SquadRootViewType.None
	end,
	useSquadTopBannerManager = function() -- line: 82
		return {
			disableSquadTopBanner = function(_, _) -- line: 84
			end,
			useSquadTopBannerDisabled = function() -- line: 85
				return false
			end
		}
	end,
	useIsChatUserMessagesEnabled = function() -- line: 90
		return false
	end
}
