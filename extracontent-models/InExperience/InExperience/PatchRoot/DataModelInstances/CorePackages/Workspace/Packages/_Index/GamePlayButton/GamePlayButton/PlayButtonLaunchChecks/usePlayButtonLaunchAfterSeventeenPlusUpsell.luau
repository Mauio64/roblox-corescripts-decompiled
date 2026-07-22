local GamePlayButton = script:FindFirstAncestor("GamePlayButton")

require(GamePlayButton.PlayButtonTypes)

local GetFFlagLuaAppFetchPlayabilityKillSwitch = require(GamePlayButton.Flags.GetFFlagLuaAppFetchPlayabilityKillSwitch)
local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)
local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local useDispatch = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(GamePlayButtonParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(GamePlayButtonParent.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(GamePlayButtonParent.RoactServiceTags).AppEventIngestService
local PlayabilityStatusEnum = require(GamePlayButtonParent.DiscoveryTypes).PlayabilityStatusEnum

require(GamePlayButtonParent.PlayabilityRodux)

local FetchGamePlayabilityAndProductInfo = require(GamePlayButtonParent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local OpenAgeVerificationModal = require(GamePlayButtonParent.VoiceChat).AgeVerificationOverlay.OpenAgeVerificationModal
local useContextualParentalControlsUpsell = require(GamePlayButton.PlayButtonLaunchChecks.useContextualParentalControlsUpsell)
local delayedAmpWizardCompletionCallbackOverride = require(GamePlayButton.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride)
local unlockPlayIntent = require(GamePlayButtonParent.DiscoveryAnalytics).Events.unlockPlayIntent
local OpenAmpWizardContainer = require(GamePlayButtonParent.AmpUpsell).OpenAmpWizardContainer
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonAmpAgeCheckFlow
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = require(GamePlayButtonParent.SharedFlags).FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = require(GamePlayButtonParent.SharedFlags).FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local FFlagLuaAppParentApprovedExperiences = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppParentApprovedExperiences
local FFlagLuaAppPlayButtonWizardCloseDelay = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayButtonWizardCloseDelay
local FIntLuaAppPlayButtonWizardCloseDelayMs = require(GamePlayButtonParent.SharedFlags).FIntLuaAppPlayButtonWizardCloseDelayMs
local FFlagLuaAppLogPageContextUnlockPlayIntent = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppLogPageContextUnlockPlayIntent
local FFlagLuaAppDemoModePlayButtonTelemetry = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry
local v25 = if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else "gameJoinAgeCheckRequired"

return function(p1, p2, p3, s1: string?) -- line: 38
	-- upvalues: useRoactService (copy), RoactNetworking (copy), AppEventIngestService (copy), useDispatch (copy), React (copy), unlockPlayIntent (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), FFlagLuaAppParentApprovedExperiences (copy), useContextualParentalControlsUpsell (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FetchGamePlayButtonData (copy), PlayabilityStatusEnum (copy), GetFFlagLuaAppFetchPlayabilityKillSwitch (copy), FetchGamePlayabilityAndProductInfo (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), v25 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy), OpenAgeVerificationModal (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
	local v30 = useRoactService(RoactNetworking)
	local v31 = useRoactService(AppEventIngestService)
	local v32 = useDispatch()
	local v33 = React.useCallback(function(p4) -- line: 49
		-- upvalues: unlockPlayIntent (copy), v31 (copy), p2 (copy), p1 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy)
		unlockPlayIntent(v31, {
			universeId = p2,
			upsellName = p4,
			playabilityStatus = p1 and p1.playabilityStatus or nil,
			pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
		})
	end, {
		v31,
		p2,
		p1,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
	})
	local u34 = nil
	local u37

	if FFlagLuaAppParentApprovedExperiences then
		local v35, v36 = useContextualParentalControlsUpsell(p2, p3, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1)

		u37 = v35
		u34 = v36
	else
		u37 = useContextualParentalControlsUpsell(p2, p3, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1)
	end

	local u38 = nil

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		u38 = React.useCallback(function() -- line: 81
			-- upvalues: v32 (copy), FetchGamePlayButtonData (copy), v30 (copy), p2 (copy)
			v32(FetchGamePlayButtonData.Fetch(v30, p2, true))
		end, {
			v32,
			v30,
			p2
		})
	end

	return (React.useCallback(function(p5, s2: string?) -- line: 86
		-- upvalues: p1 (copy), PlayabilityStatusEnum (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FFlagLuaAppParentApprovedExperiences (copy), GetFFlagLuaAppFetchPlayabilityKillSwitch (copy), v32 (copy), FetchGamePlayabilityAndProductInfo (copy), v30 (copy), p2 (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), u38 (ref), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy), v25 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy), OpenAgeVerificationModal (copy), v33 (copy), u37 (ref), u34 (ref), FFlagLuaAppDemoModePlayButtonTelemetry (copy), p3 (copy)
		if p1 then
			if (p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or (p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or (FFlagLuaAppPlayButtonAmpAgeCheckFlow and p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired or FFlagLuaAppParentApprovedExperiences and p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval))) and not GetFFlagLuaAppFetchPlayabilityKillSwitch() then
				v32(FetchGamePlayabilityAndProductInfo.Fetch(v30, p2)):andThen(function(p6) -- line: 100
					-- upvalues: PlayabilityStatusEnum (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), v32 (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), u38 (ref), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy), v25 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy), OpenAgeVerificationModal (copy), p2 (copy), v33 (copy), u37 (ref), FFlagLuaAppParentApprovedExperiences (copy), u34 (ref), p5 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s2 (copy), p3 (copy)
					if p6 == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or FFlagLuaAppPlayButtonAmpAgeCheckFlow and p6 == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired then
						if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
							v32(OpenAmpWizardContainer(FStringLuaAppPlayButtonAgeCheckAmpFeatureName, u38, nil, if not FFlagLuaAppLogPageContextUnlockPlayIntent or not s1 then v25 else `{ v25 }-{ s1 }`, nil, FStringLuaAppPlayButtonAgeCheckAmpNameSpace, nil, nil, if not FFlagLuaAppPlayButtonWizardCloseDelay then nil else delayedAmpWizardCompletionCallbackOverride(u38, FIntLuaAppPlayButtonWizardCloseDelayMs)))
						else
							v32(OpenAgeVerificationModal(p2))
						end

						v33(not FFlagLuaAppPlayButtonAmpAgeCheckFlow and "AgeVerificationUnverifiedSeventeenPlusUser" or "AgeCheckRequired")

						return
					end

					if p6 == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
						u37()

						return
					end

					if FFlagLuaAppParentApprovedExperiences and p6 == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval then
						u34(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)

						return
					end

					p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
					v33("GameLaunch")
				end):catch(function() -- line: 163
					-- upvalues: p3 (copy), p5 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), s2 (copy), v33 (copy)
					p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
					v33("GameLaunch")
				end)

				return
			end

			p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)

			return
		end

		p3(p5, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
	end, {
		v30,
		p2,
		p1,
		p3,
		v33,
		u37,
		if not FFlagLuaAppParentApprovedExperiences then nil else u34,
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else u38,
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else v32,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
	}))
end
