local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local IXPService = game:GetService("IXPService")
require(GamePlayButton.PlayButtonTypes)
local parent = GamePlayButton.Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local VoiceChat = require(parent.VoiceChat)

local OpenCentralOverlayForVerifiedEnableVoice = VoiceChat.AgeVerificationOverlay.OpenCentralOverlayForVerifiedEnableVoice
local ApiPostRecordUserSeenModal = VoiceChat.AgeVerificationOverlay.ApiPostRecordUserSeenModal
local SetShowAgeVerificationOverlay = VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local SharedFlags = require(parent.SharedFlags)
local GetFStringVoiceUpsellLayer = SharedFlags.GetFStringVoiceUpsellLayer
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags2.FFlagLuaAppDemoModePlayButtonTelemetry
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppCloudClientPlayButtonOffer = SharedFlags3.FFlagLuaAppCloudClientPlayButtonOffer

return function(p, p2, p3)
	local v = useRoactService(RoactNetworking)
	local v2 = useDispatch()
	local v3 = useAppPolicy(function(p4)
		return {
			RequireExplicitVoiceConsent = p4.RequireExplicitVoiceConsent(),
			showVoiceOptInOverlayEnabled = p4.getShowVoiceUpsellV2()
		}
	end)

	local v4 = useSelector(function(p4)
		if p4.ShowAgeVerificationOverlay[p] == nil then
			return {}
		end

		return p4.ShowAgeVerificationOverlay[p]
	end)

	local isPlaceEnabledForVoice = v4.isPlaceEnabledForVoice
	local isUniverseEnabledForVoice = v4.isUniverseEnabledForVoice
	local showVoiceOptInOverlay = v4.showVoiceOptInOverlay
	local elegibleToSeeVoiceUpsell = v4.elegibleToSeeVoiceUpsell
	local isVoiceEnabled = v4.isVoiceEnabled

	return (React.useCallback(function(p4, p5: string?)
		if isUniverseEnabledForVoice and elegibleToSeeVoiceUpsell then
			local fStringVoiceUpsellLayer = GetFStringVoiceUpsellLayer()

			if fStringVoiceUpsellLayer ~= "" then
				IXPService:LogUserLayerExposure(fStringVoiceUpsellLayer)
			end
		end

		if showVoiceOptInOverlay and v3.showVoiceOptInOverlayEnabled then
			local v5 = p5
			v2(OpenCentralOverlayForVerifiedEnableVoice({
				launchGame = function()
					if FFlagLuaAppCloudClientPlayButtonOffer then
						local v6

						if FFlagLuaAppDemoModePlayButtonTelemetry then
							v6 = v5
						end

						p2(p4, v6, { hasShownUpsell = true })
					else
						local v6

						if FFlagLuaAppDemoModePlayButtonTelemetry then
							v6 = v5
						end

						p2(p4, v6)
					end
				end,
				RequireExplicitVoiceConsent = v3.RequireExplicitVoiceConsent,
				postUserSeenModal = function()
					return v2(ApiPostRecordUserSeenModal.Fetch(v))
				end,
				setShowVoiceOptIn = function(p6)
					v2(SetShowAgeVerificationOverlay(
						p,
						isPlaceEnabledForVoice,
						isUniverseEnabledForVoice,
						p6.voiceEnabled,
						p6.showVoiceOptInOverlay
					))
				end
			}))
			return
		end

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			p5 = nil
		end

		p3(p4, p5)
	end, {
		v,
		p,
		isPlaceEnabledForVoice,
		isUniverseEnabledForVoice,
		showVoiceOptInOverlay,
		v3.showVoiceOptInOverlayEnabled,
		v3.RequireExplicitVoiceConsent,
		isVoiceEnabled,
		p2,
		p3,
		elegibleToSeeVoiceUpsell
	}))
end
