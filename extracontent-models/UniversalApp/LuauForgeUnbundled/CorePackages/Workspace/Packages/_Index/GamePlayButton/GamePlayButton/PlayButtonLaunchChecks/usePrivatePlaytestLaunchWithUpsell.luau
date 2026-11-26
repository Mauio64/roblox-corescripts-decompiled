local FetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/FetchGamePlayButtonData")
local PlaytestUnlockUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlaytestUnlockUpsell")
local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

local delayedAmpWizardCompletionCallbackOverride = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/delayedAmpWizardCompletionCallbackOverride")

local useUpdatePlaytestSettingsUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/BuildExperiencePlaytestLaunch/useUpdatePlaytestSettingsUpsell")
local useTrustedFriendsPlaytestUpsell = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/BuildExperiencePlaytestLaunch/useTrustedFriendsPlaytestUpsell")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppEventIngestService
local apiFetchPlayabilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux").PlayabilityStatus.ApiFetchPlayabilityStatus
local openAmpWizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell").OpenAmpWizardContainer
local unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.unlockPlayIntent
local invalidPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.invalidPlayIntent

local fStringLuaAppPlayButtonAgeCheckAmpFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local fStringLuaAppPlayButtonAgeCheckAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local fFlagLuaAppPlayButtonWizardCloseDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonWizardCloseDelay
local fIntLuaAppPlayButtonWizardCloseDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FIntLuaAppPlayButtonWizardCloseDelayMs
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry

local fFlagLuaAppPlaytestTrustedFriendsRefetchPlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability

local kind = PlaytestUnlockUpsell.Type

return function(p2, p3, p4, p5, p6, p7)
	local v5 = useRoactService(roactNetworking)
	local v6 = useRoactService(appEventIngestService)
	local v7 = useDispatch()
	local v8 = useStore()
	local v9 = useUpdatePlaytestSettingsUpsell()

	local v10 = React.useCallback(function()
		v7(FetchGamePlayButtonData.Fetch(v5, p3, true))
	end, { v7, v5, p3 })
	local v12 = if fFlagLuaAppPlaytestTrustedFriendsRefetchPlayability then v10 else nil
	local v13 = useTrustedFriendsPlaytestUpsell(p7, v12)

	local v14 = React.useCallback(function(p8, p9)
		unlockPlayIntent(v6, {
			universeId = p3,
			upsellName = p8,
			playabilityStatus = p9,
			pageName = p6
		})
	end, { v6, p3, p6 })

	local v15 = React.useCallback(function(value)
		invalidPlayIntent(p5, {
			universeId = p3,
			playButtonState = PlayButtonStates.Playtest,
			playabilityStatus = value or "None"
		})
	end, { p5, p3 })

	local v16 = React.useCallback(function(p8)
		local v22 = not p6 and "gameJoinAgeCheckRequired" or `gameJoinAgeCheckRequired-{p6}`

		local v27 = if fFlagLuaAppPlayButtonWizardCloseDelay then delayedAmpWizardCompletionCallbackOverride(v10, fIntLuaAppPlayButtonWizardCloseDelayMs) else nil
		v7(openAmpWizardContainer(
			fStringLuaAppPlayButtonAgeCheckAmpFeatureName,
			v10,
			nil,
			v22,
			nil,
			fStringLuaAppPlayButtonAgeCheckAmpNameSpace,
			nil,
			nil,
			v27
		))

		v14("AgeCheckRequired", p8)
	end, { v7, v10, p6, v14 })

	return (React.useCallback(function(p8, p9)
		local function launchPrivatePlaytest()
			p4(p8, if fFlagLuaAppDemoModePlayButtonTelemetry then p9 else nil)
		end

		local function handlePrivatePlaytestInfo(privatePlaytestInfo)
			if privatePlaytestInfo == nil then
				v15(nil)
			elseif privatePlaytestInfo.isPlayable then
				p4(p8, if fFlagLuaAppDemoModePlayButtonTelemetry then p9 else nil)
			else
				local playabilityStatus = privatePlaytestInfo.playabilityStatus
				local kind2 = PlaytestUnlockUpsell.getType(playabilityStatus)

				if kind2 == kind.AgeVerification then
					v16(playabilityStatus)
				elseif kind2 == kind.UpdatePlaytestSettings then
					v9()
					v14("UpdatePlaytestSettings", playabilityStatus)
				else
					if kind2 ~= kind.TrustedFriends then
						v15(playabilityStatus)

						return
					end

					v13()
					v14("TrustedFriendRequired", playabilityStatus)
				end
			end
		end

		v7(apiFetchPlayabilityStatus.Fetch(v5, { p3 })):andThen(function()
			local v17 = v8:getState().PlayabilityStatus[p3]
			handlePrivatePlaytestInfo(v17 and v17.privatePlaytestInfo or nil)
		end):catch(function()
			handlePrivatePlaytestInfo(p2 and p2.privatePlaytestInfo or nil)
		end)
	end, {
		v7,
		v5,
		p3,
		v8,
		p4,
		p2,
		v16,
		v9,
		v13,
		v14,
		v15
	}))
end
