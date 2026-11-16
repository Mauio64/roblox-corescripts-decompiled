local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadContractType")
local SquadViewFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadViewFlags")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadExperienceInviteSource")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks").useCurrentSquadId

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")

local fFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local fFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return function(props)
	local state, setState = React.useState(SquadViewFlags.None)
	local v5

	if fFlagEnableSquadTopBannerWideMode then
		v5 = props.contract.useSquadTopBannerManager()
	else
		v5 = React.useMemo(function()
			return {
				disableSquadTopBanner = function(p2, p3) end,
				useSquadTopBannerDisabled = function(): boolean
					return false
				end
			}
		end, {})
	end

	local v6 = React.useMemo(Analytics.Analytics, {})
	local v7 = useCurrentSquadId()
	local v8 = React.useCallback(function(p2, p3)
		local joined = Cryo.Dictionary.join(p3, {
			squadId = v7,
			squadLocation = props.squadLocation
		})

		v6.fireAnalyticsEvent(p2, joined)
	end, { v7, props.squadLocation })

	local v9 = {
		closeSquadPrompt = props.contract.closeSquadPrompt,
		createFriendConversation = props.contract.createFriendConversation,
		createConversation = props.contract.createConversation,
		disableSquadTopBanner = v5.disableSquadTopBanner,
		fetchParentChannelDetails = props.contract.fetchParentChannelDetails,
		fireSquadAnalytics = v8,
		inviteToParentChannel = props.contract.inviteToParentChannel,
		navigateIntoSquadLobby = props.contract.navigateIntoSquadLobby,
		removeUserFromParentChannel = props.contract.removeUserFromParentChannel,
		setSquadPrompt = props.contract.setSquadPrompt,
		showSearchOverlay = props.contract.showSearchOverlay,
		squadLocation = props.squadLocation,
		updateSquadViewFlags = React.useCallback(function(p2, p3)
			if p3 then
				setState(function(p4)
					return (bit32.bor(p4, p2))
				end)
			else
				setState(function(p4)
					return (bit32.band(p4, (bit32.bnot(p2))))
				end)
			end
		end, {}),
		useGetConversationFromId = props.contract.useGetConversationFromId,
		useIsChatUserMessagesEnabled = props.contract.useIsChatUserMessagesEnabled,
		useParentChannelHasGroupUp = props.contract.useParentChannelHasGroupUp,
		useParentChannelHasSquadAccess = props.contract.useParentChannelHasSquadAccess,
		useParentChannelIsPartyVoiceEligible = props.contract.useParentChannelIsPartyVoiceEligible,
		useParentChannelTitleSelector = props.contract.useParentChannelTitleSelector,
		useSquadRootView = props.contract.useSquadRootView,
		useSquadTopBannerDisabled = v5.useSquadTopBannerDisabled,
		useIsChatEnabled = props.contract.useIsChatEnabled,
		useIsLoadingChatSettings = props.contract.useIsLoadingChatSettings,
		useSquadViewFlags = React.useCallback(function()
			return state
		end, { state }),
		shouldShowOSAForConversation = props.contract.shouldShowOSAForConversation,
		showGroupOSADialog = props.contract.showGroupOSADialog
	}

	if fFlagEnableSquadRegroupExperimentation and props.contract.createExperienceInvite then
		function v9.createExperienceInvite(p2, p3)
			return props.contract.createExperienceInvite(p2, v9, p3)
		end
	end

	return React.createElement(SquadExternalContractContext.Provider, { value = v9 }, props.children)
end
