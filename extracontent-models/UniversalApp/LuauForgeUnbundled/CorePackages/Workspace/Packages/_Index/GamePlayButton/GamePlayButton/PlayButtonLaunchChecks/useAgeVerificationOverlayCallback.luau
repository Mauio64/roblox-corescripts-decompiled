local IXPService = game:GetService("IXPService")
require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").RoactNetworking
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local VoiceChat = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/VoiceChat")

local openCentralOverlayForVerifiedEnableVoice = VoiceChat.AgeVerificationOverlay.OpenCentralOverlayForVerifiedEnableVoice
local apiPostRecordUserSeenModal = VoiceChat.AgeVerificationOverlay.ApiPostRecordUserSeenModal
local setShowAgeVerificationOverlay = VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").useAppPolicy

local getFStringVoiceUpsellLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFStringVoiceUpsellLayer
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppCloudClientPlayButtonOffer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppCloudClientPlayButtonOffer

return function(p2, p3, p4)
	local v5 = useRoactService(roactNetworking)
	local v6 = useDispatch()
	local v7 = useAppPolicy(function(p5)
		return {
			RequireExplicitVoiceConsent = p5.RequireExplicitVoiceConsent(),
			showVoiceOptInOverlayEnabled = p5.getShowVoiceUpsellV2()
		}
	end)

	local v8 = useSelector(function(p5)
		if p5.ShowAgeVerificationOverlay[p2] == nil then
			return {}
		end

		return p5.ShowAgeVerificationOverlay[p2]
	end)

	local isPlaceEnabledForVoice = v8.isPlaceEnabledForVoice
	local isUniverseEnabledForVoice = v8.isUniverseEnabledForVoice
	local showVoiceOptInOverlay = v8.showVoiceOptInOverlay
	local elegibleToSeeVoiceUpsell = v8.elegibleToSeeVoiceUpsell
	local isVoiceEnabled = v8.isVoiceEnabled

	return (React.useCallback(function(p5, p6)
		if isUniverseEnabledForVoice and elegibleToSeeVoiceUpsell then
			local fStringVoiceUpsellLayer = getFStringVoiceUpsellLayer()

			if fStringVoiceUpsellLayer ~= "" then
				IXPService:LogUserLayerExposure(fStringVoiceUpsellLayer)
			end
		end

		if showVoiceOptInOverlay and v7.showVoiceOptInOverlayEnabled then
			local v9 = p6
			v6(openCentralOverlayForVerifiedEnableVoice({
				launchGame = function()
					if fFlagLuaAppCloudClientPlayButtonOffer then
						p3(p5, if fFlagLuaAppDemoModePlayButtonTelemetry then v9 else nil, {
							hasShownUpsell = true
						})
					else
						p3(p5, if fFlagLuaAppDemoModePlayButtonTelemetry then v9 else nil)
					end
				end,
				RequireExplicitVoiceConsent = v7.RequireExplicitVoiceConsent,
				postUserSeenModal = function()
					return v6(apiPostRecordUserSeenModal.Fetch(v5))
				end,
				setShowVoiceOptIn = function(p7)
					v6(setShowAgeVerificationOverlay(
						p2,
						isPlaceEnabledForVoice,
						isUniverseEnabledForVoice,
						p7.voiceEnabled,
						p7.showVoiceOptInOverlay
					))
				end
			}))
			return
		end

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			p6 = nil
		end

		p4(p5, p6)
	end, {
		v5,
		p2,
		isPlaceEnabledForVoice,
		isUniverseEnabledForVoice,
		showVoiceOptInOverlay,
		v7.showVoiceOptInOverlayEnabled,
		v7.RequireExplicitVoiceConsent,
		isVoiceEnabled,
		p3,
		p4,
		elegibleToSeeVoiceUpsell
	}))
end
