local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local parent = script.Parent.Parent
local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local formatted = `{Url.APIS_URL}ads-reward-service/v1/validateRewardAndPlacement`
local formatted2 = `{Url.APIS_URL}ads-reward-service/v1/validateRewardAndPlacementStudio`
local formatted3 = `{Url.APIS_URL}ads-reward-service/v1/grantAdReward`

local _ = { CALLED = "called", SUCCESS = "success", FAILED = "failed" }

local v = {
	eventName = "AdsRewardServiceHttpValidateCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 10, 27 },
	description = "Counter for ValidateReward http calls"
}

local v2 = {
	eventName = "AdsRewardServiceHttpGrantAdCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 10, 27 },
	description = "Counter for GrantAd http calls"
}

local v3 = {
	eventName = "AdsRewardServiceHttpError",
	backends = { "Points" },
	throttlingPercentage = game:DefineFastInt("AdsRewardServiceHttpErrorThrottleHundredthsPercent", 0),
	lastUpdated = { 2026, 10, 27 },
	description = "This event is sent whenever a ads-reward-service error occurs"
}

local function reportHttpError(endpoint: string, unixTimestampMillis: number, errorMessage: string)
	TelemetryService:LogEvent(v3, {
		standardizedFields = { "addUniverseId", "addPlaceId" },
		customFields = {
			endpoint = endpoint,
			latency = DateTime.now().UnixTimestampMillis - unixTimestampMillis,
			errorMessage = errorMessage
		}
	})
end

local function reportHttpStatusCounter(p, status: string)
	TelemetryService:LogCounter(p, {
		customFields = { status = status }
	}, 1)
end

local AdsRewardServiceApi = {}

function AdsRewardServiceApi.validateRewardAndPlacement(productId: number, placementId: number?)
	local v4

	if RunService:IsStudio() then
		v4 = formatted2
	else
		v4 = formatted
	end

	local unixTimestampMillis = DateTime.now().UnixTimestampMillis

	reportHttpStatusCounter(v, "called")
	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(
			v4,
			HttpService:JSONEncode({
				universeId = game.GameId,
				productId = productId,
				placementId = placementId
			}),
			Enum.ThrottlingPriority.Extreme,
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		local success2, result2 = pcall(function()
			local jsonDecode = HttpService:JSONDecode(result)

			if type(jsonDecode) == "table" and type(jsonDecode.rewardDetails) == "table" then
				return jsonDecode
			end

			error("Failed to parse rewardDetails")
		end)

		if success2 and type(result2) == "table" then
			reportHttpStatusCounter(v, "success")
			local rewardDetails = result2.rewardDetails
			return {
				isValidReward = result2.isValidReward == true,
				isValidPlacement = result2.isValidPlacement == true,
				defaultPlacementId = result2.defaultPlacement,
				productName = type(rewardDetails.productName) ~= "string" and "" or rewardDetails.productName,
				imageAssetIdString = rewardDetails.imageAssetIdString
			}, nil
		end

		reportHttpStatusCounter(v, "failed")
		reportHttpError(v4, unixTimestampMillis, `Validate Ad Reward failed to parse response: {result}`)
		return nil, `Validate Ad Reward failed to parse response: {result}`
	end

	reportHttpStatusCounter(v, "failed")
	reportHttpError(v4, unixTimestampMillis, `Validate Ad Reward failed: {result}`)
	return nil, `Validate Ad Reward failed: {result}`
end

function AdsRewardServiceApi.grantAdReward(userId: number, productId: number, encryptedAdTrackingData: string, encryptionMetadata: string)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	reportHttpStatusCounter(v2, "called")
	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(
			formatted3,
			HttpService:JSONEncode({
				encryptionMetadata = encryptionMetadata,
				encryptedAdTrackingData = encryptedAdTrackingData,
				productId = productId,
				userId = userId
			}),
			Enum.ThrottlingPriority.Extreme,
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		reportHttpStatusCounter(v2, "success")
		return true, nil
	end

	reportHttpStatusCounter(v2, "failed")
	reportHttpError(formatted3, unixTimestampMillis, `Grant Ad Reward failed: {result}`)
	return false, `Grant Ad Reward failed: {result}`
end

return AdsRewardServiceApi
