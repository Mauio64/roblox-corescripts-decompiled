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
local v24 = if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else "gameJoinAgeCheckRequired"

return function(p1, p2, p3, s1: string?) -- line: 37
	-- upvalues: useRoactService (copy), RoactNetworking (copy), AppEventIngestService (copy), useDispatch (copy), React (copy), unlockPlayIntent (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), FFlagLuaAppParentApprovedExperiences (copy), useContextualParentalControlsUpsell (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FetchGamePlayButtonData (copy), PlayabilityStatusEnum (copy), GetFFlagLuaAppFetchPlayabilityKillSwitch (copy), FetchGamePlayabilityAndProductInfo (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), v24 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy), OpenAgeVerificationModal (copy)
	local v29 = useRoactService(RoactNetworking)
	local v30 = useRoactService(AppEventIngestService)
	local v31 = useDispatch()
	local v32 = React.useCallback(function(p4) -- line: 48
		-- upvalues: unlockPlayIntent (copy), v30 (copy), p2 (copy), p1 (copy), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy)
		unlockPlayIntent(v30, {
			universeId = p2,
			upsellName = p4,
			playabilityStatus = p1 and p1.playabilityStatus or nil,
			pageName = if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
		})
	end, {
		v30,
		p2,
		p1,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
	})
	local u33 = nil
	local u36

	if FFlagLuaAppParentApprovedExperiences then
		local v34, v35 = useContextualParentalControlsUpsell(p2, p3, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1)

		u36 = v34
		u33 = v35
	else
		u36 = useContextualParentalControlsUpsell(p2, p3, if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1)
	end

	local u37 = nil

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		u37 = React.useCallback(function() -- line: 80
			-- upvalues: v31 (copy), FetchGamePlayButtonData (copy), v29 (copy), p2 (copy)
			v31(FetchGamePlayButtonData.Fetch(v29, p2, true))
		end, {
			v31,
			v29,
			p2
		})
	end

	return (React.useCallback(function(p5) -- line: 85
		-- upvalues: p1 (copy), PlayabilityStatusEnum (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), FFlagLuaAppParentApprovedExperiences (copy), GetFFlagLuaAppFetchPlayabilityKillSwitch (copy), v31 (copy), FetchGamePlayabilityAndProductInfo (copy), v29 (copy), p2 (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), u37 (ref), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy), v24 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy), OpenAgeVerificationModal (copy), v32 (copy), u36 (ref), u33 (ref), p3 (copy)
		if p1 then
			if (p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or (p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or (FFlagLuaAppPlayButtonAmpAgeCheckFlow and p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired or FFlagLuaAppParentApprovedExperiences and p1.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval))) and not GetFFlagLuaAppFetchPlayabilityKillSwitch() then
				v31(FetchGamePlayabilityAndProductInfo.Fetch(v29, p2)):andThen(function(p6) -- line: 99
					-- upvalues: PlayabilityStatusEnum (copy), FFlagLuaAppPlayButtonAmpAgeCheckFlow (copy), v31 (copy), OpenAmpWizardContainer (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), u37 (ref), FFlagLuaAppLogPageContextUnlockPlayIntent (copy), s1 (copy), v24 (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), delayedAmpWizardCompletionCallbackOverride (copy), FIntLuaAppPlayButtonWizardCloseDelayMs (copy), OpenAgeVerificationModal (copy), p2 (copy), v32 (copy), u36 (ref), FFlagLuaAppParentApprovedExperiences (copy), u33 (ref), p5 (copy), p3 (copy)
					if p6 == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or FFlagLuaAppPlayButtonAmpAgeCheckFlow and p6 == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired then
						if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
							v31(OpenAmpWizardContainer(FStringLuaAppPlayButtonAgeCheckAmpFeatureName, u37, nil, if not FFlagLuaAppLogPageContextUnlockPlayIntent or not s1 then v24 else `{ v24 }-{ s1 }`, nil, FStringLuaAppPlayButtonAgeCheckAmpNameSpace, nil, nil, if not FFlagLuaAppPlayButtonWizardCloseDelay then nil else delayedAmpWizardCompletionCallbackOverride(u37, FIntLuaAppPlayButtonWizardCloseDelayMs)))
						else
							v31(OpenAgeVerificationModal(p2))
						end

						v32(not FFlagLuaAppPlayButtonAmpAgeCheckFlow and "AgeVerificationUnverifiedSeventeenPlusUser" or "AgeCheckRequired")

						return
					end

					if p6 == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
						u36()

						return
					end

					if FFlagLuaAppParentApprovedExperiences and p6 == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval then
						u33(p5)

						return
					end

					p3(p5)
					v32("GameLaunch")
				end):catch(function() -- line: 158
					-- upvalues: p3 (copy), p5 (copy), v32 (copy)
					p3(p5)
					v32("GameLaunch")
				end)

				return
			end

			p3(p5)

			return
		end

		p3(p5)
	end, {
		v29,
		p2,
		p1,
		p3,
		v32,
		u36,
		if not FFlagLuaAppParentApprovedExperiences then nil else u33,
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else u37,
		if not FFlagLuaAppPlayButtonAmpAgeCheckFlow then nil else v31,
		if not FFlagLuaAppLogPageContextUnlockPlayIntent then nil else s1
	}))
end
