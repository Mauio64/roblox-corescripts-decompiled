local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SquadExternalContractContext = require(script.Parent.SquadExternalContractContext)
require(script.Parent.SquadContractType)
local SquadViewFlags = require(script.Parent.SquadViewFlags)

local Analytics = require(SquadsCore.Analytics)
require(SquadsCore.Enums.SquadLocationEnum)
require(SquadsCore.Enums.SquadExperienceInviteSource)
local Hooks = require(SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local FFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return function(props)
	local state, setState = React.useState(SquadViewFlags.None)
	local v

	if FFlagEnableSquadTopBannerWideMode then
		v = props.contract.useSquadTopBannerManager()
	else
		v = React.useMemo(function()
			return {
				disableSquadTopBanner = function(_, _) end,
				useSquadTopBannerDisabled = function(): boolean
					return false
				end
			}
		end, {})
	end

	local v2 = React.useMemo(Analytics.Analytics, {})
	local squadId = useCurrentSquadId()
	local fireSquadAnalytics = React.useCallback(function(p, p2)
		local joined = Cryo.Dictionary.join(p2, {
			squadId = squadId,
			squadLocation = props.squadLocation
		})

		v2.fireAnalyticsEvent(p, joined)
	end, { squadId, props.squadLocation })

	local v3 = {
		closeSquadPrompt = props.contract.closeSquadPrompt,
		createFriendConversation = props.contract.createFriendConversation,
		createConversation = props.contract.createConversation,
		disableSquadTopBanner = v.disableSquadTopBanner,
		fetchParentChannelDetails = props.contract.fetchParentChannelDetails,
		fireSquadAnalytics = fireSquadAnalytics,
		inviteToParentChannel = props.contract.inviteToParentChannel,
		navigateIntoSquadLobby = props.contract.navigateIntoSquadLobby,
		removeUserFromParentChannel = props.contract.removeUserFromParentChannel,
		setSquadPrompt = props.contract.setSquadPrompt,
		showSearchOverlay = props.contract.showSearchOverlay,
		squadLocation = props.squadLocation,
		updateSquadViewFlags = React.useCallback(function(p: number, flag: boolean)
			if flag then
				setState(function(p2)
					return (bit32.bor(p2, p))
				end)
			else
				setState(function(p2)
					return (bit32.band(p2, (bit32.bnot(p))))
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
		useSquadTopBannerDisabled = v.useSquadTopBannerDisabled,
		useIsChatEnabled = props.contract.useIsChatEnabled,
		useIsLoadingChatSettings = props.contract.useIsLoadingChatSettings,
		useSquadViewFlags = React.useCallback(function()
			return state
		end, { state }),
		shouldShowOSAForConversation = props.contract.shouldShowOSAForConversation,
		showGroupOSADialog = props.contract.showGroupOSADialog
	}

	if FFlagEnableSquadRegroupExperimentation and props.contract.createExperienceInvite then
		function v3.createExperienceInvite(p: string, p2)
			return props.contract.createExperienceInvite(p, v3, p2)
		end
	end

	return React.createElement(SquadExternalContractContext.Provider, { value = v3 }, props.children)
end
