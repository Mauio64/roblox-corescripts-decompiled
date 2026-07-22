local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local IXPService = game:GetService("IXPService")

require(GamePlayButton.PlayButtonTypes)

local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local useRoactService = require(GamePlayButtonParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(GamePlayButtonParent.RoactServiceTags).RoactNetworking
local RoactUtils = require(GamePlayButtonParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local VoiceChat = require(GamePlayButtonParent.VoiceChat)
local OpenCentralOverlayForVerifiedEnableVoice = VoiceChat.AgeVerificationOverlay.OpenCentralOverlayForVerifiedEnableVoice
local ApiPostRecordUserSeenModal = VoiceChat.AgeVerificationOverlay.ApiPostRecordUserSeenModal
local SetShowAgeVerificationOverlay = VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay
local useAppPolicy = require(GamePlayButtonParent.UniversalAppPolicy).useAppPolicy
local GetFStringVoiceUpsellLayer = require(GamePlayButtonParent.SharedFlags).GetFStringVoiceUpsellLayer
local FFlagLuaAppDemoModePlayButtonTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry

return function(p1, p2, p3) -- line: 23
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useAppPolicy (copy), useSelector (copy), React (copy), GetFStringVoiceUpsellLayer (copy), IXPService (copy), OpenCentralOverlayForVerifiedEnableVoice (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), ApiPostRecordUserSeenModal (copy), SetShowAgeVerificationOverlay (copy)
	local v20 = useRoactService(RoactNetworking)
	local v21 = useDispatch()
	local v22 = useAppPolicy(function(p4) -- line: 30
		return {
			RequireExplicitVoiceConsent = p4.RequireExplicitVoiceConsent(),
			showVoiceOptInOverlayEnabled = p4.getShowVoiceUpsellV2()
		}
	end)
	local v23 = useSelector(function(p5) -- line: 37
		-- upvalues: p1 (copy)
		if p5.ShowAgeVerificationOverlay[p1] ~= nil then
			return p5.ShowAgeVerificationOverlay[p1]
		end

		return {}
	end)
	local isPlaceEnabledForVoice = v23.isPlaceEnabledForVoice
	local isUniverseEnabledForVoice = v23.isUniverseEnabledForVoice
	local showVoiceOptInOverlay = v23.showVoiceOptInOverlay
	local elegibleToSeeVoiceUpsell = v23.elegibleToSeeVoiceUpsell
	local isVoiceEnabled = v23.isVoiceEnabled

	return (React.useCallback(function(p6, s1: string?) -- line: 50
		-- upvalues: isUniverseEnabledForVoice (copy), elegibleToSeeVoiceUpsell (copy), GetFStringVoiceUpsellLayer (copy), IXPService (copy), showVoiceOptInOverlay (copy), v22 (copy), v21 (copy), OpenCentralOverlayForVerifiedEnableVoice (copy), p2 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), ApiPostRecordUserSeenModal (copy), v20 (copy), SetShowAgeVerificationOverlay (copy), p1 (copy), isPlaceEnabledForVoice (copy), p3 (copy)
		if isUniverseEnabledForVoice and elegibleToSeeVoiceUpsell then
			local v33 = GetFStringVoiceUpsellLayer()

			if v33 ~= "" then
				IXPService:LogUserLayerExposure(v33)
			end
		end

		if showVoiceOptInOverlay and v22.showVoiceOptInOverlayEnabled then
			v21(OpenCentralOverlayForVerifiedEnableVoice({
				launchGame = function() -- line: 59
					-- upvalues: p2 (copy), p6 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s1 (copy)
					p2(p6, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1)
				end,
				RequireExplicitVoiceConsent = v22.RequireExplicitVoiceConsent,
				postUserSeenModal = function() -- line: 66
					-- upvalues: v21 (copy), ApiPostRecordUserSeenModal (copy), v20 (copy)
					return v21(ApiPostRecordUserSeenModal.Fetch(v20))
				end,
				setShowVoiceOptIn = function(t1: {[any]: any}) -- line: 69
					-- upvalues: v21 (copy), SetShowAgeVerificationOverlay (copy), p1 (copy), isPlaceEnabledForVoice (copy), isUniverseEnabledForVoice (copy)
					v21(SetShowAgeVerificationOverlay(p1, isPlaceEnabledForVoice, isUniverseEnabledForVoice, t1.voiceEnabled, t1.showVoiceOptInOverlay))
				end
			}))

			return
		end

		p3(p6, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1)
	end, {
		v20,
		p1,
		isPlaceEnabledForVoice,
		isUniverseEnabledForVoice,
		showVoiceOptInOverlay,
		v22.showVoiceOptInOverlayEnabled,
		v22.RequireExplicitVoiceConsent,
		isVoiceEnabled,
		p2,
		p3,
		elegibleToSeeVoiceUpsell
	}))
end
