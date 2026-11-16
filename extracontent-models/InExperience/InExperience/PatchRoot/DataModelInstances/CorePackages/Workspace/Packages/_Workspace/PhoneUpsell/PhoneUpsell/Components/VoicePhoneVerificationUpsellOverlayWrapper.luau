local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)

local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking

require(parent.LuauPolyfill)

local VoiceChat = require(parent.VoiceChat)
local PostUserOptIn = VoiceChat.PostUserOptIn

require(PhoneUpsell.Components.PhoneVerificationUpsellOverlay)
local UpsellContainer = require(PhoneUpsell.Components.UpsellContainer)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)

local Cryo = require(parent.Cryo)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local FFlagFixUpsellVerificationToNavigateToOverlays = require(PhoneUpsell.Flags.FFlagFixUpsellVerificationToNavigateToOverlays)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagDisablePVUpsellDataConsent = SharedFlags.GetFFlagDisablePVUpsellDataConsent
local SharedFlags2 = require(parent.SharedFlags)
local FFlagHomePhoneVerificationUpsellNewCopy = SharedFlags2.FFlagHomePhoneVerificationUpsellNewCopy

local v = {
	onSuccess = function() end,
	closeUpsell = function() end,
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhoneVoice",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.AddPhoneBodyVoice"
}

local function VoicePhoneVerificationUpsellOverlayWrapper(p)
	local v2 = mergeProps(v, p)
	local v3 = useRoactService(RoactNetworking)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local requireAddPhoneLegalTextCheckbox = useAppPolicy(function(p2)
		return p2.RequireExplicitVoiceConsent()
	end)

	local element = React.createElement(ImageSetLabel, {
		Size = UDim2.fromOffset(40, 40),
		Image = Images["icons/status/success_large"],
		BackgroundTransparency = 1
	})

	local function onSuccess()
		PostUserOptIn(v3, true, false):andThen(function(p2)
			if p2 then
				setState(true)
				task.delay(3, function()
					if FFlagFixUpsellVerificationToNavigateToOverlays then
						v2.closeUpsell()
						v2.onSuccess()
					else
						v2.onSuccess()
						v2.closeUpsell()
					end
				end)
			else
				setState2(true)
				task.delay(5, function()
					if FFlagFixUpsellVerificationToNavigateToOverlays then
						v2.closeUpsell()
						v2.onSuccess()
					else
						v2.onSuccess()
						v2.closeUpsell()
					end
				end)
				Logging.warn("Error getting UserOptIn. " .. tostring(p2))
			end
		end):catch(function()
			setState2(true)
			task.delay(5, function()
				if FFlagFixUpsellVerificationToNavigateToOverlays then
					v2.closeUpsell()
					v2.onSuccess()
				else
					v2.onSuccess()
					v2.closeUpsell()
				end
			end)
			Logging.warn("Exception posting PostUserOptIn")
		end)
	end

	local v4 = useLocalization({
		verifySuccessKey = "Feature.VerificationUpsell.Heading.VoiceChatEnabledMobile",
		voiceErrorKey = "Feature.VerificationUpsell.Heading.VoiceChatError"
	})

	return React.createElement(React.Fragment, nil, {
		PhoneVerificationUpsellOverlay = React.createElement(UpsellContainer, Cryo.Dictionary.join(v2, {
			onSuccess = onSuccess,
			addPhoneTitleKey = v2.addPhoneTitleKey,
			addPhoneDescriptionKey = v2.addPhoneDescriptionKey,
			addPhoneButtonKey = FFlagHomePhoneVerificationUpsellNewCopy and "Feature.AccountSettings.Action.Verify" or "Feature.VerificationUpsell.Action.EnableVoice",
			addPhoneLegalTextKey = requireAddPhoneLegalTextCheckbox and "Feature.VerificationUpsell.Description.VoiceLegalConsent" or FFlagHomePhoneVerificationUpsellNewCopy and "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer3" or "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer",
			alwaysShowAddPhoneLegalText = true,
			requireAddPhoneLegalTextCheckbox = requireAddPhoneLegalTextCheckbox,
			disableLegalText = GetFFlagDisablePVUpsellDataConsent(),
			shouldShowVerificationText = FFlagHomePhoneVerificationUpsellNewCopy and true or nil
		})),
		SuccessOverlay = state and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v4.verifySuccessKey
		}),
		ErrorOverlay = state2 and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v4.voiceErrorKey
		})
	})
end

return VoicePhoneVerificationUpsellOverlayWrapper
