local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SquadExternalContractContext = require(script.Parent.SquadExternalContractContext)

require(script.Parent.SquadContractType)

local SquadViewFlags = require(script.Parent.SquadViewFlags)
local Analytics = require(SquadsCore.Analytics)

require(SquadsCore.Enums.SquadLocationEnum)
require(SquadsCore.Enums.SquadExperienceInviteSource)

local useCurrentSquadId = require(SquadsCore.Hooks).useCurrentSquadId
local Cryo = require(SquadsCoreParent.Cryo)
local React = require(SquadsCoreParent.React)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local FFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), SquadViewFlags (copy), FFlagEnableSquadTopBannerWideMode (copy), Analytics (copy), useCurrentSquadId (copy), Cryo (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadExternalContractContext (copy)
	local v14, v15 = React.useState(SquadViewFlags.None)
	local v16 = if not FFlagEnableSquadTopBannerWideMode then React.useMemo(function() -- line: 35
		return {
			disableSquadTopBanner = function(_, _) -- line: 37
			end,
			useSquadTopBannerDisabled = function() -- line: 38
				return false
			end
		}
	end, {}) else t1.contract.useSquadTopBannerManager()
	local v17 = React.useMemo(Analytics.Analytics, {})
	local v18 = useCurrentSquadId()
	local v19 = React.useCallback(function(p3, p4) -- line: 46
		-- upvalues: Cryo (copy), v18 (copy), t1 (copy), v17 (copy)
		local v23 = Cryo.Dictionary.join(p4, {
			squadId = v18,
			squadLocation = t1.squadLocation
		})

		v17.fireAnalyticsEvent(p3, v23)
	end, {
		v18,
		t1.squadLocation
	})
	local t2 = {
		closeSquadPrompt = t1.contract.closeSquadPrompt,
		createFriendConversation = t1.contract.createFriendConversation,
		createConversation = t1.contract.createConversation,
		disableSquadTopBanner = v16.disableSquadTopBanner,
		fetchParentChannelDetails = t1.contract.fetchParentChannelDetails,
		fireSquadAnalytics = v19,
		inviteToParentChannel = t1.contract.inviteToParentChannel,
		navigateIntoSquadLobby = t1.contract.navigateIntoSquadLobby,
		removeUserFromParentChannel = t1.contract.removeUserFromParentChannel,
		setSquadPrompt = t1.contract.setSquadPrompt,
		showSearchOverlay = t1.contract.showSearchOverlay,
		squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else t1.squadLocation,
		updateSquadViewFlags = React.useCallback(function(n1: number, b1: boolean) -- line: 69
			-- upvalues: v15 (copy)
			if b1 then
				v15(function(p5) -- line: 71
					-- upvalues: n1 (copy)
					return (bit32.bor(p5, n1))
				end)

				return
			end

			v15(function(p6) -- line: 75
				-- upvalues: n1 (copy)
				return (bit32.band(p6, (bit32.bnot(n1))))
			end)
		end, {}),
		useGetConversationFromId = t1.contract.useGetConversationFromId,
		useIsChatUserMessagesEnabled = t1.contract.useIsChatUserMessagesEnabled,
		useParentChannelHasGroupUp = t1.contract.useParentChannelHasGroupUp,
		useParentChannelHasSquadAccess = t1.contract.useParentChannelHasSquadAccess,
		useParentChannelIsPartyVoiceEligible = t1.contract.useParentChannelIsPartyVoiceEligible,
		useParentChannelTitleSelector = t1.contract.useParentChannelTitleSelector,
		useSquadRootView = t1.contract.useSquadRootView,
		useSquadTopBannerDisabled = v16.useSquadTopBannerDisabled,
		useIsChatEnabled = t1.contract.useIsChatEnabled,
		useIsLoadingChatSettings = t1.contract.useIsLoadingChatSettings,
		useSquadViewFlags = React.useCallback(function() -- line: 90
			-- upvalues: v14 (copy)
			return v14
		end, { v14 }),
		shouldShowOSAForConversation = t1.contract.shouldShowOSAForConversation,
		showGroupOSADialog = t1.contract.showGroupOSADialog
	}

	if FFlagEnableSquadRegroupExperimentation and t1.contract.createExperienceInvite then
		function t2.createExperienceInvite(s1: string, p7) -- line: 98
			-- upvalues: t1 (copy), t2 (copy)
			return t1.contract.createExperienceInvite(s1, t2, p7)
		end
	end

	return React.createElement(SquadExternalContractContext.Provider, {
		value = t2
	}, t1.children)
end
