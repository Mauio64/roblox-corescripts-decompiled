local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local NotificationModalsManager = require(TrustedContactsParent.NotificationModalsManager)
local default = require(TrustedContactsParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local AmpUpsell = require(TrustedContactsParent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local GetFFlagEnableAmpWizardVPCNavigationFix = AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix
local NavigateBack = require(TrustedContactsParent.NavigationRodux).Thunks.NavigateBack
local useDispatch = require(TrustedContactsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useOpenWebView = require(TrustedContactsParent.WebViewUtils).useOpenWebView
local FFlagSignalsNavP3Dispatch = require(TrustedContactsParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(TrustedContactsParent.RobloxAppNavigation).NavigationCommands
local SocialUpsell = require(TrustedContactsParent.SocialUpsell)
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local v20 = game:DefineFastFlag("TCOpenAmpInGame", false)
local FFlagTFWithActionsCheck = require(TrustedContactsParent.SharedFlags).FFlagTFWithActionsCheck

require(TrustedContacts.Common.Types)

local function useExternalNavigationSetUp(t1: {[any]: any}) -- line: 44
	-- upvalues: useDispatch (copy), FFlagTFWithActionsCheck (copy), useSocialUpsellOverlayController (copy), React (copy), NotificationModalsManager (copy), useOpenWebView (copy), v20 (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateBack (copy), InExpAmpWizardController (copy), OpenAmpWizardContainer (copy), default (copy), UpsellEntrySurfaceType (copy), SocialUpsellType (copy), UpsellComponent (copy)
	local v24 = useDispatch()
	local u25 = nil
	local u26 = nil

	if FFlagTFWithActionsCheck then
		u25 = game.GameId ~= 0
		u26 = useSocialUpsellOverlayController(u25)
	end

	local v27 = React.useCallback(function(s1: string) -- line: 53
		-- upvalues: NotificationModalsManager (copy)
		NotificationModalsManager.SetUIBloxToast({
			sequenceNumber = DateTime.now().UnixTimestamp,
			toastTitle = s1
		})
	end, {})
	local v28 = useOpenWebView()
	local v29 = React.useCallback(function(p1) -- line: 62
		-- upvalues: v20 (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v24 (copy), NavigateBack (copy), InExpAmpWizardController (copy), OpenAmpWizardContainer (copy)
		local function v35(p2, p3) -- line: 63
			-- upvalues: v20 (copy), GetFFlagEnableAmpWizardVPCNavigationFix (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v24 (copy), NavigateBack (copy), p1 (copy)
			if not v20 and not GetFFlagEnableAmpWizardVPCNavigationFix() then
				if FFlagSignalsNavP3Dispatch then
					v14.back(true)
				else
					v24(NavigateBack(true))
				end
			end

			p1.completionCallback(p2, p3)
		end

		if v20 then
			InExpAmpWizardController.OpenAmpWizardContainerInExp(p1.featureName, v35, p1.recourseData, p1.entryPointEventCtx, p1.extraParameters, p1.nameSpace)

			return
		end

		v24(OpenAmpWizardContainer(p1.featureName, v35, p1.recourseData, p1.entryPointEventCtx, p1.extraParameters, p1.nameSpace))
	end, { v24 })
	local v30 = React.useCallback(function() -- line: 98
		-- upvalues: t1 (copy)
		if t1.onClosed then
			t1.onClosed()

			return
		end

		if t1.navigation then
			t1.navigation.pop()
		end
	end, {
		t1,
		t1.navigation
	})
	local v31 = React.useCallback(function(p4) -- line: 106
		-- upvalues: default (copy)
		default:shareUrl(p4)
	end, {})
	local v32 = if not FFlagTFWithActionsCheck then nil else React.useCallback(function(p5) -- line: 111
		-- upvalues: u25 (ref), UpsellEntrySurfaceType (copy), u26 (ref), SocialUpsellType (copy), UpsellComponent (copy), v30 (copy)
		local v38 = if not u25 then UpsellEntrySurfaceType.TrustedFriends else UpsellEntrySurfaceType.TrustedFriendsInExperience

		u26.openSocialOverlay(SocialUpsellType.FacialAgeEstimation, {
			shouldIncludeVPC = true,
			upsellEntrySurface = v38,
			upsellEntryComponent = UpsellComponent.Modal,
			entryPointEventCtx = SocialUpsellType.FacialAgeEstimation .. v38,
			onSuccess = p5 and p5.onSuccess,
			onFailure = p5 and p5.onFailure,
			onAccept = p5 and p5.onAccept,
			onDismiss = v30
		})
	end, {
		v30,
		u25,
		u26.openSocialOverlay
	})

	return {
		closeModal = v30,
		openAmpWizard = v29,
		openFacialAgeEstimationUpsell = if not FFlagTFWithActionsCheck then nil else v32,
		showToast = v27,
		openWebView = v28,
		shareUrl = v31
	}
end

return useExternalNavigationSetUp
