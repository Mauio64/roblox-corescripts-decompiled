local HttpService = game:GetService("HttpService")

local PlayWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local PlayWithRewardTelemetry = require(PlayWithRewardComponent.PlayWithRewardTelemetry)

local parent = PlayWithRewardComponent.Parent
local Promise = require(parent.Promise)
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local Loggers2 = require(parent.Loggers)
local mutedError = Loggers2.mutedError
local t = require(parent.t)

local PlayWithRewardState = require(parent.PlayWithRewardState)
local PlayWithRewardAdData = PlayWithRewardState.PlayWithRewardAdData
local SetPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState

local interface = t.interface({
	AdAvailabilityResult = t.userdata,
	ProductId = t.optional(t.string),
	ProductName = t.optional(t.string),
	ProductImageAssetId = t.optional(t.string),
	ExperimentVariantData = t.optional(t.string)
})

local interface2 = t.interface({ IsEligible = t.boolean })

local function getDurationSinceStartFetchMs(now: number) -- 3 equivalent calls inferred from this helper
	return (os.clock() - now) * 1000
end

local function fetchAd(object, p, _)
	return object:GetAdAvailabilityNowForUniverseAsync(Enum.AdFormat.RewardedVideo, tonumber(p), true) or nil
end

local function fetchPlayWithRewardStateAsync(object, p: string, _: number, guid: string)
	if not object then
		Logger:warning(`AdService is not available. Cannot fetch Play with Reward data for universe ID {p}.`)
		return nil
	end

	local now = os.clock()
	PlayWithRewardTelemetry.logPlayWithRewardAdRequested(guid, p)
	local adAvailabilityNowForUniverseAsync = object:GetAdAvailabilityNowForUniverseAsync(
			Enum.AdFormat.RewardedVideo,
			tonumber(p),
			true
		)
		or nil

	if adAvailabilityNowForUniverseAsync == nil then
		Logger:warning(`Could not fetch Play with Reward ad for universe ID {p}.`)
		PlayWithRewardTelemetry.logPlayWithRewardAdReceived(guid, p, false, nil, getDurationSinceStartFetchMs(now), nil) -- inferred equivalent call

		return nil
	else
		local v, v2 = interface(adAvailabilityNowForUniverseAsync)

		if v then
			local adAvailabilityResult = adAvailabilityNowForUniverseAsync.AdAvailabilityResult
			local productId = adAvailabilityNowForUniverseAsync.ProductId
			local productName = adAvailabilityNowForUniverseAsync.ProductName
			local productImageAssetId = adAvailabilityNowForUniverseAsync.ProductImageAssetId
			local experimentVariantData = adAvailabilityNowForUniverseAsync.ExperimentVariantData

			PlayWithRewardTelemetry.logPlayWithRewardAdReceived(
				guid,
				p,
				true,
				tostring(adAvailabilityResult),
				getDurationSinceStartFetchMs(now), -- inferred equivalent call
				productId
			)

			return PlayWithRewardAdData.new(
				adAvailabilityResult,
				productId,
				productName,
				productImageAssetId,
				experimentVariantData
			)
		end

		mutedError(`PlayWithRewardAdData invalid: {tostring(v2)}`)
		PlayWithRewardTelemetry.logPlayWithRewardAdReceived(guid, p, false, nil, getDurationSinceStartFetchMs(now), nil) -- inferred equivalent call

		return nil
	end
end

local function shouldShowShimmer(object, p: string): boolean
	if not object then
		Logger:warning(`AdService is not available. Cannot determine whether to show shimmer for universe ID {p}.`)

		return false
	end

	local success, result = pcall(function()
		return object:GetUniversalAppAdsEligibility()
	end)

	if not (success and result) then
		return false
	end

	local v, _ = interface2(result)
	return if v and result.IsEligible then true else false
end

local function FetchPlayWithRewardState(p, p2: string, p3: number)
	return function(object)
		local guid = HttpService:GenerateGUID(false)

		if shouldShowShimmer(p, p2) then
			PlayWithRewardTelemetry.logPlayWithRewardShimmerShown(guid, p2)
			object:dispatch(SetPlayWithRewardState(guid, p2, true, nil))
		end

		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetchPlayWithRewardStateAsync(p, p2, p3, guid)
			end)

			if success and result then
				object:dispatch(SetPlayWithRewardState(guid, p2, false, result))
				callback()
			else
				object:dispatch(SetPlayWithRewardState(guid, p2, false, nil))
				callback2(result)
			end
		end):catch(function(p4)
			Logger:warning(`Promise for fetching Play With Reward data rejected for universe ID {p2}: {tostring(p4)}`)
		end)
	end
end

return FetchPlayWithRewardState
