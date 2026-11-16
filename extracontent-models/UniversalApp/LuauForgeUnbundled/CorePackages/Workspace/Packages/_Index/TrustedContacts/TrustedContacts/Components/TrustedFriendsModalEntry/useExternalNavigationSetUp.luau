local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/NotificationModalsManager")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/AmpUpsell")
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local inExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local getFFlagEnableAmpWizardVPCNavigationFix = AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/NavigationRodux").Thunks.NavigateBack
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactUtils").Hooks.RoactRodux.useDispatch
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/WebViewUtils").useOpenWebView
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppNavigation").NavigationCommands else nil

local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialUpsell")
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController
local socialUpsellType = SocialUpsell.Enums.SocialUpsellType
local upsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local upsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent

local defineFastFlag = game:DefineFastFlag("TCOpenAmpInGame", false)

local FFlagEnableTrustedFriendsWizardVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagEnableTrustedFriendsWizardVPCPrologue")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

local function useExternalNavigationSetUp(p2)
	local v5 = useDispatch()

	local v6 = game.GameId ~= 0
	local v7 = useSocialUpsellOverlayController(v6)

	local v8 = React.useCallback(function(p3)
		NotificationModalsManager.SetUIBloxToast({
			sequenceNumber = DateTime.now().UnixTimestamp,
			toastTitle = p3
		})
	end, {})

	local v9 = useOpenWebView()

	local v10 = React.useCallback(function(data)
		local function fn(p3, p4)
			if not (defineFastFlag or getFFlagEnableAmpWizardVPCNavigationFix()) then
				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back(true)
				else
					v5(navigateBack(true))
				end
			end

			data.completionCallback(p3, p4)
		end

		if FFlagEnableTrustedFriendsWizardVPCPrologue then
			if defineFastFlag then
				inExpAmpWizardController.OpenAmpWizardContainerInExp(
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
				v5(openAmpWizardContainer(
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
			inExpAmpWizardController.OpenAmpWizardContainerInExp(
				data.featureName,
				fn,
				data.recourseData,
				data.entryPointEventCtx,
				data.extraParameters,
				data.nameSpace
			)
		else
			v5(openAmpWizardContainer(
				data.featureName,
				fn,
				data.recourseData,
				data.entryPointEventCtx,
				data.extraParameters,
				data.nameSpace
			))
		end
	end, { v5 })

	local v11 = React.useCallback(function()
		if p2.onClosed then
			p2.onClosed()
		elseif p2.navigation then
			p2.navigation.pop()
		end
	end, { p2, p2.navigation })

	local v12 = React.useCallback(function(p3)
		default:shareUrl(p3)
	end, {})

	return {
		closeModal = v11,
		openAmpWizard = v10,
		openFacialAgeEstimationUpsell = React.useCallback(function(data)
			local v13

			if v6 then
				v13 = upsellEntrySurfaceType.TrustedFriendsInExperience
			else
				v13 = upsellEntrySurfaceType.TrustedFriends
			end

			v7.openSocialOverlay(socialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = v13,
				upsellEntryComponent = upsellComponent.Modal,
				entryPointEventCtx = socialUpsellType.FacialAgeEstimation .. v13,
				shouldIncludeVPC = true,
				onSuccess = data and data.onSuccess,
				onFailure = data and data.onFailure,
				onAccept = data and data.onAccept,
				onDismiss = v11
			})
		end, { v11, v6, v7.openSocialOverlay }),
		showToast = v8,
		openWebView = v9,
		shareUrl = v12
	}
end

return useExternalNavigationSetUp
