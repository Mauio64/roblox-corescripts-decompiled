local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Promise = require(parent.Promise)
require(SquadsCore.Enums.SquadExperienceInviteSource)

local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)

require(script.Parent.SquadContractType)

local SharedFlags = require(parent.SharedFlags)
local DefaultSquadContract = {}

function DefaultSquadContract.closeSquadPrompt() end

function DefaultSquadContract.createConversation(_, _, _, _: string?)
	return function(_)
		return Promise.reject("No createConversation function supplied.")
	end
end

function DefaultSquadContract.createFriendConversation(_: string, _) end

DefaultSquadContract.createExperienceInvite = SharedFlags.FFlagEnableSquadRegroupExperimentation
	and function(_: string, _, _)
		return function(_)
			return Promise.reject("No createExperienceInvite function supplied.")
		end
	end
	or nil

function DefaultSquadContract.fetchParentChannelDetails(_, _): nil
	return nil
end

function DefaultSquadContract.inviteToParentChannel(_, _, _)
	return function(_): nil
		return nil
	end
end

function DefaultSquadContract.navigateIntoSquadLobby(_, _) end

function DefaultSquadContract.removeUserFromParentChannel(_, _, _)
	return function(_): nil
		return nil
	end
end

function DefaultSquadContract.setSquadPrompt(_, _) end

function DefaultSquadContract.showSearchOverlay(_, _) end

function DefaultSquadContract.useIsChatEnabled(): boolean
	return false
end

function DefaultSquadContract.useGetConversationFromId(_): nil
	return nil
end

function DefaultSquadContract.useParentChannelHasGroupUp(_): boolean
	return false
end

function DefaultSquadContract.useParentChannelHasSquadAccess(_): boolean
	return false
end

function DefaultSquadContract.useParentChannelTitleSelector(_): string
	return ""
end

function DefaultSquadContract.useParentChannelIsPartyVoiceEligible(_): nil
	return nil
end

function DefaultSquadContract.useSquadRootView()
	return SquadRootViewType.None
end

function DefaultSquadContract.useSquadTopBannerManager()
	return {
		disableSquadTopBanner = function(_, _) end,
		useSquadTopBannerDisabled = function(): boolean
			return false
		end
	}
end

function DefaultSquadContract.useIsChatUserMessagesEnabled(): boolean
	return false
end

return DefaultSquadContract
