local HttpService = game:GetService("HttpService")

local PlayWithRewardTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/PlayWithRewardTelemetry")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/Promise")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/Loggers").Logger
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/Loggers").mutedError
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/t")

local PlayWithRewardState = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/PlayWithRewardState")
local playWithRewardAdData = PlayWithRewardState.PlayWithRewardAdData
local setPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState

local interface = t.interface({
	AdAvailabilityResult = t.userdata,
	ProductId = t.optional(t.string),
	ProductName = t.optional(t.string),
	ProductImageAssetId = t.optional(t.string),
	ExperimentVariantData = t.optional(t.string)
})

local interface2 = t.interface({ IsEligible = t.boolean })

local function getDurationSinceStartFetchMs(p2)
	return (os.clock() - p2) * 1000
end

local function fetchAd(object, p2, p3)
	local adAvailabilityNowForUniverseAsync = object:GetAdAvailabilityNowForUniverseAsync(
		Enum.AdFormat.RewardedVideo,
		tonumber(p2),
		true
	)

	if adAvailabilityNowForUniverseAsync then
		return adAvailabilityNowForUniverseAsync
	end

	return nil
end

local function fetchPlayWithRewardStateAsync(object, p2, p3, guid)
	if not object then
		logger:warning(`AdService is not available. Cannot fetch Play with Reward data for universe ID {p2}.`)
		return nil
	end

	local lastTime = os.clock()
	PlayWithRewardTelemetry.logPlayWithRewardAdRequested(guid, p2)
	local adAvailabilityNowForUniverseAsync = object:GetAdAvailabilityNowForUniverseAsync(
			Enum.AdFormat.RewardedVideo,
			tonumber(p2),
			true
		)
		or nil

	if adAvailabilityNowForUniverseAsync == nil then
		logger:warning(`Could not fetch Play with Reward ad for universe ID {p2}.`)
		PlayWithRewardTelemetry.logPlayWithRewardAdReceived(guid, p2, false, nil, (os.clock() - lastTime) * 1000, nil)

		return nil
	else
		local v5, v6 = interface(adAvailabilityNowForUniverseAsync)

		if v5 then
			local adAvailabilityResult = adAvailabilityNowForUniverseAsync.AdAvailabilityResult
			local productId = adAvailabilityNowForUniverseAsync.ProductId
			local productName = adAvailabilityNowForUniverseAsync.ProductName
			local productImageAssetId = adAvailabilityNowForUniverseAsync.ProductImageAssetId
			local experimentVariantData = adAvailabilityNowForUniverseAsync.ExperimentVariantData
			PlayWithRewardTelemetry.logPlayWithRewardAdReceived(
				guid,
				p2,
				true,
				tostring(adAvailabilityResult),
				(os.clock() - lastTime) * 1000,
				productId
			)

			return playWithRewardAdData.new(
				adAvailabilityResult,
				productId,
				productName,
				productImageAssetId,
				experimentVariantData
			)
		end

		mutedError(`PlayWithRewardAdData invalid: {tostring(v6)}`)
		PlayWithRewardTelemetry.logPlayWithRewardAdReceived(guid, p2, false, nil, (os.clock() - lastTime) * 1000, nil)

		return nil
	end
end

local function shouldShowShimmer(object, p2): boolean
	if not object then
		logger:warning(`AdService is not available. Cannot determine whether to show shimmer for universe ID {p2}.`)

		return false
	end

	local success, result = pcall(function()
		return object:GetUniversalAppAdsEligibility()
	end)

	if not (success and result) then
		return false
	end

	local v5, v6 = interface2(result)

	if v5 and result.IsEligible then
		return true
	end

	return false
end

local function FetchPlayWithRewardState(p2, p3, p4)
	return function(object)
		local guid = HttpService:GenerateGUID(false)

		if shouldShowShimmer(p2, p3) then
			PlayWithRewardTelemetry.logPlayWithRewardShimmerShown(guid, p3)
			object:dispatch(setPlayWithRewardState(guid, p3, true, nil))
		end

		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetchPlayWithRewardStateAsync(p2, p3, p4, guid)
			end)

			if success and result then
				object:dispatch(setPlayWithRewardState(guid, p3, false, result))
				callback()
			else
				object:dispatch(setPlayWithRewardState(guid, p3, false, nil))
				callback2(result)
			end
		end):catch(function(p5)
			logger:warning(`Promise for fetching Play With Reward data rejected for universe ID {p3}: {tostring(p5)}`)
		end)
	end
end

return FetchPlayWithRewardState
