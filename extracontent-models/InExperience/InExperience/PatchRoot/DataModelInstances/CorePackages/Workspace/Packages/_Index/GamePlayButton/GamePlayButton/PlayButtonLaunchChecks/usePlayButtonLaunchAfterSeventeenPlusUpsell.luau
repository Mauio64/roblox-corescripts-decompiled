local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
require(GamePlayButton.PlayButtonTypes)
local GetFFlagLuaAppFetchPlayabilityKillSwitch = require(GamePlayButton.Flags.GetFFlagLuaAppFetchPlayabilityKillSwitch)
local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags2.AppEventIngestService
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
require(parent.PlayabilityRodux)
local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local VoiceChat = require(parent.VoiceChat)
local OpenAgeVerificationModal = VoiceChat.AgeVerificationOverlay.OpenAgeVerificationModal

local useContextualParentalControlsUpsell = require(GamePlayButton.PlayButtonLaunchChecks.useContextualParentalControlsUpsell)

local delayedAmpWizardCompletionCallbackOverride = require(GamePlayButton.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local unlockPlayIntent = DiscoveryAnalytics.Events.unlockPlayIntent
local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = SharedFlags.FFlagLuaAppPlayButtonAmpAgeCheckFlow

local SharedFlags2 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags2.FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local SharedFlags3 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags3.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppParentApprovedExperiences = SharedFlags4.FFlagLuaAppParentApprovedExperiences
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags5.FFlagLuaAppPlayButtonWizardCloseDelay
local SharedFlags6 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonWizardCloseDelayMs = SharedFlags6.FIntLuaAppPlayButtonWizardCloseDelayMs
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags7.FFlagLuaAppDemoModePlayButtonTelemetry
local v = FFlagLuaAppPlayButtonAmpAgeCheckFlow and "gameJoinAgeCheckRequired" or nil
return function(p, universeId, p2, pageName: string?)
	local v2 = useRoactService(RoactNetworking)
	local v3 = useRoactService(AppEventIngestService)

	local v4 = useDispatch()

	local v5 = React.useCallback(function(upsellName)
		unlockPlayIntent(v3, {
			universeId = universeId,
			upsellName = upsellName,
			playabilityStatus = p and p.playabilityStatus or nil,
			pageName = pageName
		})
	end, { v3, universeId, p, pageName })

	local v6 = nil
	local v7

	if FFlagLuaAppParentApprovedExperiences then
		v7, v6 = useContextualParentalControlsUpsell(universeId, p2, pageName)
	else
		v7 = useContextualParentalControlsUpsell(universeId, p2, pageName)
	end

	local v8

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		v8 = React.useCallback(function()
			v4(FetchGamePlayButtonData.Fetch(v2, universeId, true))
		end, { v4, v2, universeId })
	else
		v8 = nil
	end

	local useCallback = React.useCallback
	local function fn(p3, p4: string?)
		if
			p
			and (p.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser or p.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls or FFlagLuaAppPlayButtonAmpAgeCheckFlow and p.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired or FFlagLuaAppParentApprovedExperiences and p.playabilityStatus == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval)
			and not GetFFlagLuaAppFetchPlayabilityKillSwitch()
		then
			local v9 = p4
			local v10 = p4
			v4(FetchGamePlayabilityAndProductInfo.Fetch(v2, universeId)):andThen(function(p5)
				if
					p5 == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
					or FFlagLuaAppPlayButtonAmpAgeCheckFlow
					and p5 == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired
				then
					if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
						local v11

						if pageName then
							v11 = `{v}-{pageName}`
						else
							v11 = v
						end

						local v12

						if FFlagLuaAppPlayButtonWizardCloseDelay then
							v12 = delayedAmpWizardCompletionCallbackOverride(v8, FIntLuaAppPlayButtonWizardCloseDelayMs)
						end

						v4(OpenAmpWizardContainer(
							FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
							v8,
							nil,
							v11,
							nil,
							FStringLuaAppPlayButtonAgeCheckAmpNameSpace,
							nil,
							nil,
							v12
						))
					else
						v4(OpenAgeVerificationModal(universeId))
					end

					v5(FFlagLuaAppPlayButtonAmpAgeCheckFlow and "AgeCheckRequired" or "AgeVerificationUnverifiedSeventeenPlusUser")
				elseif p5 == PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls then
					v7()
				elseif
					FFlagLuaAppParentApprovedExperiences
					and p5 == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval
				then
					local v11

					if FFlagLuaAppDemoModePlayButtonTelemetry then
						v11 = v9
					end

					v6(p3, v11)
				else
					local v11

					if FFlagLuaAppDemoModePlayButtonTelemetry then
						v11 = v9
					end

					p2(p3, v11)

					v5("GameLaunch")
				end
			end):catch(function()
				local v11

				if FFlagLuaAppDemoModePlayButtonTelemetry then
					v11 = v10
				end

				p2(p3, v11)

				v5("GameLaunch")
			end)
			return
		end

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			p4 = nil
		end

		p2(p3, p4)
	end

	local v9

	if FFlagLuaAppParentApprovedExperiences then
		v9 = v6
	end

	local v10

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		v10 = v8
	end

	local v11

	if FFlagLuaAppPlayButtonAmpAgeCheckFlow then
		v11 = v4
	end

	return (useCallback(fn, {
		v2,
		universeId,
		p,
		p2,
		v5,
		v7,
		v9,
		v10,
		v11,
		pageName
	}))
end
