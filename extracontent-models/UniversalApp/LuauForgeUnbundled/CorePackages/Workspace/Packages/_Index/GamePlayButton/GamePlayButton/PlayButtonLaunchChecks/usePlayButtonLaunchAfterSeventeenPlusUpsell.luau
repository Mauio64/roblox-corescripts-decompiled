require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")
local GetFFlagLuaAppFetchPlayabilityKillSwitch = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags/GetFFlagLuaAppFetchPlayabilityKillSwitch")
local FetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/FetchGamePlayButtonData")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppEventIngestService
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")
local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local openAgeVerificationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/VoiceChat").AgeVerificationOverlay.OpenAgeVerificationModal

local useContextualParentalControlsUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/useContextualParentalControlsUpsell")

local delayedAmpWizardCompletionCallbackOverride = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/delayedAmpWizardCompletionCallbackOverride")
local unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.unlockPlayIntent
local openAmpWizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell").OpenAmpWizardContainer

local fFlagLuaAppPlayButtonAmpAgeCheckFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonAmpAgeCheckFlow

local fStringLuaAppPlayButtonAgeCheckAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local fStringLuaAppPlayButtonAgeCheckAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local fFlagLuaAppParentApprovedExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppParentApprovedExperiences
local fFlagLuaAppPlayButtonWizardCloseDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonWizardCloseDelay
local fIntLuaAppPlayButtonWizardCloseDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FIntLuaAppPlayButtonWizardCloseDelayMs
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local v5 = fFlagLuaAppPlayButtonAmpAgeCheckFlow and "gameJoinAgeCheckRequired" or nil
return function(p2, p3, p4, p5)
	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(appEventIngestService)

	local v8 = useDispatch()

	local v9 = React.useCallback(function(p6)
		unlockPlayIntent(v7, {
			universeId = p3,
			upsellName = p6,
			playabilityStatus = p2 and p2.playabilityStatus or nil,
			pageName = p5
		})
	end, { v7, p3, p2, p5 })

	local v10 = nil
	local v11

	if fFlagLuaAppParentApprovedExperiences then
		v11, v10 = useContextualParentalControlsUpsell(p3, p4, p5)
	else
		v11 = useContextualParentalControlsUpsell(p3, p4, p5)
	end

	local v12

	if fFlagLuaAppPlayButtonAmpAgeCheckFlow then
		v12 = React.useCallback(function()
			v8(FetchGamePlayButtonData.Fetch(v6, p3, true))
		end, { v8, v6, p3 })
	else
		v12 = nil
	end

	local useCallback = React.useCallback
	local function fn(p6, p7)
		if
			p2
			and (p2.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or p2.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or fFlagLuaAppPlayButtonAmpAgeCheckFlow and p2.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityAgeCheckRequired or fFlagLuaAppParentApprovedExperiences and p2.playabilityStatus == playabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			and not GetFFlagLuaAppFetchPlayabilityKillSwitch()
		then
			local v13 = p7
			local v14 = p7
			v8(fetchGamePlayabilityAndProductInfo.Fetch(v6, p3)):andThen(function(p8)
				if
					p8 == playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
					or fFlagLuaAppPlayButtonAmpAgeCheckFlow
					and p8 == playabilityStatusEnum.ContextualPlayabilityAgeCheckRequired
				then
					if fFlagLuaAppPlayButtonAmpAgeCheckFlow then
						local v20 = if p5 then `{v5}-{p5}` else v5

						local v25 = if fFlagLuaAppPlayButtonWizardCloseDelay then delayedAmpWizardCompletionCallbackOverride(v12, fIntLuaAppPlayButtonWizardCloseDelayMs) else nil
						v8(openAmpWizardContainer(
							fStringLuaAppPlayButtonAgeCheckAmpFeatureName,
							v12,
							nil,
							v20,
							nil,
							fStringLuaAppPlayButtonAgeCheckAmpNameSpace,
							nil,
							nil,
							v25
						))
					else
						v8(openAgeVerificationModal(p3))
					end

					v9(fFlagLuaAppPlayButtonAmpAgeCheckFlow and "AgeCheckRequired" or "AgeVerificationUnverifiedSeventeenPlusUser")
				elseif p8 == playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
					v11()
				elseif
					fFlagLuaAppParentApprovedExperiences
					and p8 == playabilityStatusEnum.ContextualPlayabilityRequireParentApproval
				then
					v10(p6, if fFlagLuaAppDemoModePlayButtonTelemetry then v13 else nil)
				else
					p4(p6, if fFlagLuaAppDemoModePlayButtonTelemetry then v13 else nil)

					v9("GameLaunch")
				end
			end):catch(function()
				p4(p6, if fFlagLuaAppDemoModePlayButtonTelemetry then v14 else nil)

				v9("GameLaunch")
			end)
			return
		end

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			p7 = nil
		end

		p4(p6, p7)
	end

	local v15 = if fFlagLuaAppParentApprovedExperiences then v10 else nil
	local v16 = if fFlagLuaAppPlayButtonAmpAgeCheckFlow then v12 else nil
	return (useCallback(fn, {
		v6,
		p3,
		p2,
		p4,
		v9,
		v11,
		v15,
		v16,
		if fFlagLuaAppPlayButtonAmpAgeCheckFlow then v8 else nil,
		p5
	}))
end
