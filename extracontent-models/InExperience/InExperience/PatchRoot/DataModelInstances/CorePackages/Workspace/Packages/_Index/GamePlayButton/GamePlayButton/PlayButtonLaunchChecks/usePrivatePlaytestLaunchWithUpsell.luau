local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local FetchGamePlayButtonData = require(GamePlayButton.FetchGamePlayButtonData)
local PlaytestUnlockUpsell = require(GamePlayButton.PlaytestUnlockUpsell)
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)
require(GamePlayButton.PlayButtonTypes)

local delayedAmpWizardCompletionCallbackOverride = require(GamePlayButton.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride)

local parent = GamePlayButton.Parent
local useUpdatePlaytestSettingsUpsell = require(parent.BuildExperiencePlaytestLaunch.useUpdatePlaytestSettingsUpsell)
local useTrustedFriendsPlaytestUpsell = require(parent.BuildExperiencePlaytestLaunch.useTrustedFriendsPlaytestUpsell)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags2.AppEventIngestService
local PlayabilityRodux = require(parent.PlayabilityRodux)
local ApiFetchPlayabilityStatus = PlayabilityRodux.PlayabilityStatus.ApiFetchPlayabilityStatus
local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local unlockPlayIntent = DiscoveryAnalytics.Events.unlockPlayIntent
local DiscoveryAnalytics2 = require(parent.DiscoveryAnalytics)
local invalidPlayIntent = DiscoveryAnalytics2.Events.invalidPlayIntent

local SharedFlags = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpFeatureName

local SharedFlags2 = require(parent.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags2.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags3.FFlagLuaAppPlayButtonWizardCloseDelay
local SharedFlags4 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonWizardCloseDelayMs = SharedFlags4.FIntLuaAppPlayButtonWizardCloseDelayMs
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags5.FFlagLuaAppDemoModePlayButtonTelemetry

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability = SharedFlags6.FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability

local Type = PlaytestUnlockUpsell.Type

return function(p, universeId: string, callback, p2: string, pageName: string?, p3: string?)
	local v = useRoactService(RoactNetworking)
	local v2 = useRoactService(AppEventIngestService)
	local v3 = useDispatch()
	local v4 = useStore()
	local v5 = useUpdatePlaytestSettingsUpsell()

	local v6 = React.useCallback(function()
		v3(FetchGamePlayButtonData.Fetch(v, universeId, true))
	end, { v3, v, universeId })
	local v7

	if FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability then
		v7 = v6
	end

	local v8 = useTrustedFriendsPlaytestUpsell(p3, v7)

	local v9 = React.useCallback(function(upsellName: string, playabilityStatus: string?)
		unlockPlayIntent(v2, {
			universeId = universeId,
			upsellName = upsellName,
			playabilityStatus = playabilityStatus,
			pageName = pageName
		})
	end, { v2, universeId, pageName })

	local v10 = React.useCallback(function(value: string?)
		invalidPlayIntent(p2, {
			universeId = universeId,
			playButtonState = PlayButtonStates.Playtest,
			playabilityStatus = value or "None"
		})
	end, { p2, universeId })

	local v11 = React.useCallback(function(p4: string?)
		local v11 = not pageName and "gameJoinAgeCheckRequired" or `gameJoinAgeCheckRequired-{pageName}`
		local v12

		if FFlagLuaAppPlayButtonWizardCloseDelay then
			v12 = delayedAmpWizardCompletionCallbackOverride(v6, FIntLuaAppPlayButtonWizardCloseDelayMs)
		end

		v3(OpenAmpWizardContainer(
			FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
			v6,
			nil,
			v11,
			nil,
			FStringLuaAppPlayButtonAgeCheckAmpNameSpace,
			nil,
			nil,
			v12
		))

		v9("AgeCheckRequired", p4)
	end, { v3, v6, pageName, v9 })

	return (React.useCallback(function(p4, p5: string?)
		local function launchPrivatePlaytest() -- 1 equivalent call inferred from this helper
			local v12

			if FFlagLuaAppDemoModePlayButtonTelemetry then
				v12 = p5
			end

			callback(p4, v12)
		end

		local function handlePrivatePlaytestInfo(privatePlaytestInfo)
			if privatePlaytestInfo == nil then
				v10(nil)
			elseif privatePlaytestInfo.isPlayable then
				launchPrivatePlaytest() -- inferred equivalent call
			else
				local playabilityStatus = privatePlaytestInfo.playabilityStatus
				local kind = PlaytestUnlockUpsell.getType(playabilityStatus)

				if kind == Type.AgeVerification then
					v11(playabilityStatus)
				elseif kind == Type.UpdatePlaytestSettings then
					v5()
					v9("UpdatePlaytestSettings", playabilityStatus)
				else
					if kind ~= Type.TrustedFriends then
						v10(playabilityStatus)

						return
					end

					v8()
					v9("TrustedFriendRequired", playabilityStatus)
				end
			end
		end

		v3(ApiFetchPlayabilityStatus.Fetch(v, { universeId })):andThen(function()
			local v12 = v4:getState().PlayabilityStatus[universeId]
			handlePrivatePlaytestInfo(v12 and v12.privatePlaytestInfo or nil)
		end):catch(function()
			handlePrivatePlaytestInfo(p and p.privatePlaytestInfo or nil)
		end)
	end, {
		v3,
		v,
		universeId,
		v4,
		callback,
		p,
		v11,
		v5,
		v8,
		v9,
		v10
	}))
end
