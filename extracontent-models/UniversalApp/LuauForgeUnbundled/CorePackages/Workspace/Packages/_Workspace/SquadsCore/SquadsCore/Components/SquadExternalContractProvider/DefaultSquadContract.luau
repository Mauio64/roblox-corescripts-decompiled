local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadExperienceInviteSource")

local SquadRootViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadRootViewType")

require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadContractType")

return {
	closeSquadPrompt = function() end,
	createConversation = function(p2, p3, p4, p5)
		return function(p6)
			return Promise.reject("No createConversation function supplied.")
		end
	end,
	createFriendConversation = function(p2, p3) end,
	createExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagEnableSquadRegroupExperimentation and function(p2, p3, p4)
		return function(p5)
			return Promise.reject("No createExperienceInvite function supplied.")
		end
	end or nil,
	fetchParentChannelDetails = function(p2, p3): nil
		return nil
	end,
	inviteToParentChannel = function(p2, p3, p4)
		return function(p5): nil
			return nil
		end
	end,
	navigateIntoSquadLobby = function(p2, p3) end,
	removeUserFromParentChannel = function(p2, p3, p4)
		return function(p5): nil
			return nil
		end
	end,
	setSquadPrompt = function(p2, p3) end,
	showSearchOverlay = function(p2, p3) end,
	useIsChatEnabled = function(): boolean
		return false
	end,
	useGetConversationFromId = function(p2): nil
		return nil
	end,
	useParentChannelHasGroupUp = function(p2): boolean
		return false
	end,
	useParentChannelHasSquadAccess = function(p2): boolean
		return false
	end,
	useParentChannelTitleSelector = function(p2): string
		return ""
	end,
	useParentChannelIsPartyVoiceEligible = function(p2): nil
		return nil
	end,
	useSquadRootView = function()
		return SquadRootViewType.None
	end,
	useSquadTopBannerManager = function()
		return {
			disableSquadTopBanner = function(p2, p3) end,
			useSquadTopBannerDisabled = function(): boolean
				return false
			end
		}
	end,
	useIsChatUserMessagesEnabled = function(): boolean
		return false
	end
}
