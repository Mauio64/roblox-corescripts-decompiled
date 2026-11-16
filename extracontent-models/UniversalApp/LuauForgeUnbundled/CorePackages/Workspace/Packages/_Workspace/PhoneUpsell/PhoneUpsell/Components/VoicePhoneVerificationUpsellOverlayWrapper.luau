local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")

local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactServiceTags").RoactNetworking

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/LuauPolyfill")

local postUserOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/VoiceChat").PostUserOptIn

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationUpsellOverlay")
local UpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/UpsellContainer")
local PhoneVerificationStatusOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationStatusOverlay")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Cryo")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UniversalAppPolicy").useAppPolicy
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AppCommonLib").Logging

local FFlagFixUpsellVerificationToNavigateToOverlays = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/FFlagFixUpsellVerificationToNavigateToOverlays")
local getFFlagDisablePVUpsellDataConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFFlagDisablePVUpsellDataConsent
local fFlagHomePhoneVerificationUpsellNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").FFlagHomePhoneVerificationUpsellNewCopy

local v5 = {
	onSuccess = function() end,
	closeUpsell = function() end,
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhoneVoice",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.AddPhoneBodyVoice"
}

local function VoicePhoneVerificationUpsellOverlayWrapper(p2)
	local v6 = mergeProps(v5, p2)
	local v7 = useRoactService(roactNetworking)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v8 = useAppPolicy(function(p3)
		return p3.RequireExplicitVoiceConsent()
	end)

	local element = React.createElement(imageSetLabel, {
		Size = UDim2.fromOffset(40, 40),
		Image = images["icons/status/success_large"],
		BackgroundTransparency = 1
	})

	local function onSuccess()
		postUserOptIn(v7, true, false):andThen(function(p3)
			if p3 then
				setState(true)
				task.delay(3, function()
					if FFlagFixUpsellVerificationToNavigateToOverlays then
						v6.closeUpsell()
						v6.onSuccess()
					else
						v6.onSuccess()
						v6.closeUpsell()
					end
				end)
			else
				setState2(true)
				task.delay(5, function()
					if FFlagFixUpsellVerificationToNavigateToOverlays then
						v6.closeUpsell()
						v6.onSuccess()
					else
						v6.onSuccess()
						v6.closeUpsell()
					end
				end)
				logging.warn("Error getting UserOptIn. " .. tostring(p3))
			end
		end):catch(function()
			setState2(true)
			task.delay(5, function()
				if FFlagFixUpsellVerificationToNavigateToOverlays then
					v6.closeUpsell()
					v6.onSuccess()
				else
					v6.onSuccess()
					v6.closeUpsell()
				end
			end)
			logging.warn("Exception posting PostUserOptIn")
		end)
	end

	local v9 = useLocalization({
		verifySuccessKey = "Feature.VerificationUpsell.Heading.VoiceChatEnabledMobile",
		voiceErrorKey = "Feature.VerificationUpsell.Heading.VoiceChatError"
	})

	return React.createElement(React.Fragment, nil, {
		PhoneVerificationUpsellOverlay = React.createElement(UpsellContainer, Cryo.Dictionary.join(v6, {
			onSuccess = onSuccess,
			addPhoneTitleKey = v6.addPhoneTitleKey,
			addPhoneDescriptionKey = v6.addPhoneDescriptionKey,
			addPhoneButtonKey = fFlagHomePhoneVerificationUpsellNewCopy and "Feature.AccountSettings.Action.Verify" or "Feature.VerificationUpsell.Action.EnableVoice",
			addPhoneLegalTextKey = v8 and "Feature.VerificationUpsell.Description.VoiceLegalConsent" or fFlagHomePhoneVerificationUpsellNewCopy and "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer3" or "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer",
			alwaysShowAddPhoneLegalText = true,
			requireAddPhoneLegalTextCheckbox = v8,
			disableLegalText = getFFlagDisablePVUpsellDataConsent(),
			shouldShowVerificationText = fFlagHomePhoneVerificationUpsellNewCopy and true or nil
		})),
		SuccessOverlay = state and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v9.verifySuccessKey
		}),
		ErrorOverlay = state2 and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v9.voiceErrorKey
		})
	})
end

return VoicePhoneVerificationUpsellOverlayWrapper
