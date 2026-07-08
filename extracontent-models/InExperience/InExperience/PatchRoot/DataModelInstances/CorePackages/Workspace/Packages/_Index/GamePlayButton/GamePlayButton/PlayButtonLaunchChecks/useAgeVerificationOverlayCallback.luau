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

return function(p1, p2, p3) -- line: 22
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useAppPolicy (copy), useSelector (copy), React (copy), GetFStringVoiceUpsellLayer (copy), IXPService (copy), OpenCentralOverlayForVerifiedEnableVoice (copy), ApiPostRecordUserSeenModal (copy), SetShowAgeVerificationOverlay (copy)
	local v19 = useRoactService(RoactNetworking)
	local v20 = useDispatch()
	local v21 = useAppPolicy(function(p4) -- line: 29
		return {
			RequireExplicitVoiceConsent = p4.RequireExplicitVoiceConsent(),
			showVoiceOptInOverlayEnabled = p4.getShowVoiceUpsellV2()
		}
	end)
	local v22 = useSelector(function(p5) -- line: 36
		-- upvalues: p1 (copy)
		if p5.ShowAgeVerificationOverlay[p1] ~= nil then
			return p5.ShowAgeVerificationOverlay[p1]
		end

		return {}
	end)
	local isPlaceEnabledForVoice = v22.isPlaceEnabledForVoice
	local isUniverseEnabledForVoice = v22.isUniverseEnabledForVoice
	local showVoiceOptInOverlay = v22.showVoiceOptInOverlay
	local elegibleToSeeVoiceUpsell = v22.elegibleToSeeVoiceUpsell
	local isVoiceEnabled = v22.isVoiceEnabled

	return (React.useCallback(function(p6) -- line: 49
		-- upvalues: isUniverseEnabledForVoice (copy), elegibleToSeeVoiceUpsell (copy), GetFStringVoiceUpsellLayer (copy), IXPService (copy), showVoiceOptInOverlay (copy), v21 (copy), v20 (copy), OpenCentralOverlayForVerifiedEnableVoice (copy), p2 (copy), ApiPostRecordUserSeenModal (copy), v19 (copy), SetShowAgeVerificationOverlay (copy), p1 (copy), isPlaceEnabledForVoice (copy), p3 (copy)
		if isUniverseEnabledForVoice and elegibleToSeeVoiceUpsell then
			local v31 = GetFStringVoiceUpsellLayer()

			if v31 ~= "" then
				IXPService:LogUserLayerExposure(v31)
			end
		end

		if showVoiceOptInOverlay and v21.showVoiceOptInOverlayEnabled then
			v20(OpenCentralOverlayForVerifiedEnableVoice({
				launchGame = function() -- line: 58
					-- upvalues: p2 (copy), p6 (copy)
					p2(p6)
				end,
				RequireExplicitVoiceConsent = v21.RequireExplicitVoiceConsent,
				postUserSeenModal = function() -- line: 62
					-- upvalues: v20 (copy), ApiPostRecordUserSeenModal (copy), v19 (copy)
					return v20(ApiPostRecordUserSeenModal.Fetch(v19))
				end,
				setShowVoiceOptIn = function(t1: {[any]: any}) -- line: 65
					-- upvalues: v20 (copy), SetShowAgeVerificationOverlay (copy), p1 (copy), isPlaceEnabledForVoice (copy), isUniverseEnabledForVoice (copy)
					v20(SetShowAgeVerificationOverlay(p1, isPlaceEnabledForVoice, isUniverseEnabledForVoice, t1.voiceEnabled, t1.showVoiceOptInOverlay))
				end
			}))

			return
		end

		p3(p6)
	end, {
		v19,
		p1,
		isPlaceEnabledForVoice,
		isUniverseEnabledForVoice,
		showVoiceOptInOverlay,
		v21.showVoiceOptInOverlayEnabled,
		v21.RequireExplicitVoiceConsent,
		isVoiceEnabled,
		p2,
		p3,
		elegibleToSeeVoiceUpsell
	}))
end
