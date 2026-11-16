local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)

local NotificationModalsManager = require(parent.NotificationModalsManager)

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local GetFFlagEnableAmpWizardVPCNavigationFix = AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SocialUpsell = require(parent.SocialUpsell)
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent

local defineFastFlag = game:DefineFastFlag("TCOpenAmpInGame", false)

local FFlagEnableTrustedFriendsWizardVPCPrologue = require(TrustedContacts.Flags.FFlagEnableTrustedFriendsWizardVPCPrologue)

require(TrustedContacts.Common.Types)

local function useExternalNavigationSetUp(p)
	local v = useDispatch()

	local v2 = game.GameId ~= 0
	local v3 = useSocialUpsellOverlayController(v2)

	local showToast = React.useCallback(function(toastTitle: string)
		NotificationModalsManager.SetUIBloxToast({
			sequenceNumber = DateTime.now().UnixTimestamp,
			toastTitle = toastTitle
		})
	end, {})

	local openWebView = useOpenWebView()

	local openAmpWizard = React.useCallback(function(data)
		local function fn(p2, p3)
			if not (defineFastFlag or GetFFlagEnableAmpWizardVPCNavigationFix()) then
				if FFlagSignalsNavP3Dispatch then
					navigationCommands.back(true)
				else
					v(NavigateBack(true))
				end
			end

			data.completionCallback(p2, p3)
		end

		if FFlagEnableTrustedFriendsWizardVPCPrologue then
			if defineFastFlag then
				InExpAmpWizardController.OpenAmpWizardContainerInExp(
					data.featureName,
					fn,
					data.recourseData,
					data.entryPointEventCtx,
					data.extraParameters,
					data.nameSpace,
					nil,
					nil,
					nil,
					data.usePrologue,
					data.prologueOptions
				)
			else
				v(OpenAmpWizardContainer(
					data.featureName,
					fn,
					data.recourseData,
					data.entryPointEventCtx,
					data.extraParameters,
					data.nameSpace,
					nil,
					nil,
					nil,
					data.usePrologue,
					data.prologueOptions
				))
			end
		elseif defineFastFlag then
			InExpAmpWizardController.OpenAmpWizardContainerInExp(
				data.featureName,
				fn,
				data.recourseData,
				data.entryPointEventCtx,
				data.extraParameters,
				data.nameSpace
			)
		else
			v(OpenAmpWizardContainer(
				data.featureName,
				fn,
				data.recourseData,
				data.entryPointEventCtx,
				data.extraParameters,
				data.nameSpace
			))
		end
	end, { v })

	local v4 = React.useCallback(function()
		if p.onClosed then
			p.onClosed()
		elseif p.navigation then
			p.navigation.pop()
		end
	end, { p, p.navigation })

	local shareUrl = React.useCallback(function(p2)
		default:shareUrl(p2)
	end, {})

	return {
		closeModal = v4,
		openAmpWizard = openAmpWizard,
		openFacialAgeEstimationUpsell = React.useCallback(function(data)
			local upsellEntrySurface

			if v2 then
				upsellEntrySurface = UpsellEntrySurfaceType.TrustedFriendsInExperience
			else
				upsellEntrySurface = UpsellEntrySurfaceType.TrustedFriends
			end

			v3.openSocialOverlay(SocialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = upsellEntrySurface,
				upsellEntryComponent = UpsellComponent.Modal,
				entryPointEventCtx = SocialUpsellType.FacialAgeEstimation .. upsellEntrySurface,
				shouldIncludeVPC = true,
				onSuccess = data and data.onSuccess,
				onFailure = data and data.onFailure,
				onAccept = data and data.onAccept,
				onDismiss = v4
			})
		end, { v4, v2, v3.openSocialOverlay }),
		showToast = showToast,
		openWebView = openWebView,
		shareUrl = shareUrl
	}
end

return useExternalNavigationSetUp
