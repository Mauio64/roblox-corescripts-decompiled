local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local RoactNetworking = require(PhoneUpsellParent.RoactServiceTags).RoactNetworking

require(PhoneUpsellParent.LuauPolyfill)

local PostUserOptIn = require(PhoneUpsellParent.VoiceChat).PostUserOptIn

require(PhoneUpsell.Components.PhoneVerificationUpsellOverlay)

local UpsellContainer = require(PhoneUpsell.Components.UpsellContainer)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)
local Cryo = require(PhoneUpsellParent.Cryo)
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local useRoactService = require(PhoneUpsellParent.RobloxAppHooks).useRoactService
local useAppPolicy = require(PhoneUpsellParent.UniversalAppPolicy).useAppPolicy
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Logging = require(PhoneUpsellParent.AppCommonLib).Logging
local FFlagFixUpsellVerificationToNavigateToOverlays = require(PhoneUpsell.Flags.FFlagFixUpsellVerificationToNavigateToOverlays)
local GetFFlagDisablePVUpsellDataConsent = require(PhoneUpsellParent.SharedFlags).GetFFlagDisablePVUpsellDataConsent
local FFlagHomePhoneVerificationUpsellNewCopy = require(PhoneUpsellParent.SharedFlags).FFlagHomePhoneVerificationUpsellNewCopy
local t1 = {
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhoneVoice",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.AddPhoneBodyVoice",
	onSuccess = function() -- line: 41
	end,
	closeUpsell = function() -- line: 42
	end
}

local function VoicePhoneVerificationUpsellOverlayWrapper(p1) -- line: 49
	-- upvalues: mergeProps (copy), t1 (copy), useRoactService (copy), RoactNetworking (copy), React (copy), useAppPolicy (copy), ImageSetLabel (copy), Images (copy), PostUserOptIn (copy), FFlagFixUpsellVerificationToNavigateToOverlays (copy), Logging (copy), useLocalization (copy), UpsellContainer (copy), Cryo (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), GetFFlagDisablePVUpsellDataConsent (copy), PhoneVerificationStatusOverlay (copy)
	local v23 = mergeProps(t1, p1)
	local v24 = useRoactService(RoactNetworking)
	local v25, v26 = React.useState(false)
	local v27, v28 = React.useState(false)
	local v29 = useAppPolicy(function(p2) -- line: 56
		return p2.RequireExplicitVoiceConsent()
	end)
	local v30 = React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(40, 40),
		Image = Images["icons/status/success_large"]
	})
	local v31 = useLocalization({
		verifySuccessKey = "Feature.VerificationUpsell.Heading.VoiceChatEnabledMobile",
		voiceErrorKey = "Feature.VerificationUpsell.Heading.VoiceChatError"
	})

	return React.createElement(React.Fragment, nil, {
		PhoneVerificationUpsellOverlay = React.createElement(UpsellContainer, Cryo.Dictionary.join(v23, {
			alwaysShowAddPhoneLegalText = true,
			onSuccess = function() -- line: 66
				-- upvalues: PostUserOptIn (copy), v24 (copy), v26 (copy), FFlagFixUpsellVerificationToNavigateToOverlays (copy), v23 (copy), v28 (copy), Logging (copy)
				PostUserOptIn(v24, true, false):andThen(function(p3) -- line: 68
					-- upvalues: v26 (copy), FFlagFixUpsellVerificationToNavigateToOverlays (copy), v23 (copy), v28 (copy), Logging (copy)
					if p3 then
						v26(true)
						task.delay(3, function() -- line: 71
							-- upvalues: FFlagFixUpsellVerificationToNavigateToOverlays (copy), v23 (copy)
							if FFlagFixUpsellVerificationToNavigateToOverlays then
								v23.closeUpsell()
								v23.onSuccess()

								return
							end

							v23.onSuccess()
							v23.closeUpsell()
						end)

						return
					end

					v28(true)
					task.delay(5, function() -- line: 82
						-- upvalues: FFlagFixUpsellVerificationToNavigateToOverlays (copy), v23 (copy)
						if FFlagFixUpsellVerificationToNavigateToOverlays then
							v23.closeUpsell()
							v23.onSuccess()

							return
						end

						v23.onSuccess()
						v23.closeUpsell()
					end)
					Logging.warn("Error getting UserOptIn. " .. tostring(p3))
				end):catch(function() -- line: 94
					-- upvalues: v28 (copy), FFlagFixUpsellVerificationToNavigateToOverlays (copy), v23 (copy), Logging (copy)
					v28(true)
					task.delay(5, function() -- line: 96
						-- upvalues: FFlagFixUpsellVerificationToNavigateToOverlays (copy), v23 (copy)
						if FFlagFixUpsellVerificationToNavigateToOverlays then
							v23.closeUpsell()
							v23.onSuccess()

							return
						end

						v23.onSuccess()
						v23.closeUpsell()
					end)
					Logging.warn("Exception posting PostUserOptIn")
				end)
			end,
			addPhoneTitleKey = v23.addPhoneTitleKey,
			addPhoneDescriptionKey = v23.addPhoneDescriptionKey,
			addPhoneButtonKey = not FFlagHomePhoneVerificationUpsellNewCopy and "Feature.VerificationUpsell.Action.EnableVoice" or "Feature.AccountSettings.Action.Verify",
			addPhoneLegalTextKey = if not v29 then not FFlagHomePhoneVerificationUpsellNewCopy and "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer" or "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer3" else "Feature.VerificationUpsell.Description.VoiceLegalConsent",
			requireAddPhoneLegalTextCheckbox = v29,
			disableLegalText = GetFFlagDisablePVUpsellDataConsent(),
			shouldShowVerificationText = not not FFlagHomePhoneVerificationUpsellNewCopy or nil
		})),
		SuccessOverlay = v25 and React.createElement(PhoneVerificationStatusOverlay, {
			image = v30,
			text = v31.verifySuccessKey
		}),
		ErrorOverlay = v27 and React.createElement(PhoneVerificationStatusOverlay, {
			image = v30,
			text = v31.voiceErrorKey
		})
	})
end

return VoicePhoneVerificationUpsellOverlayWrapper
