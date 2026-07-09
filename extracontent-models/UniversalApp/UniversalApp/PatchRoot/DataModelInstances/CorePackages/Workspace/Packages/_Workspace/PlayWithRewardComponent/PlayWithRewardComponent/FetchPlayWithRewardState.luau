local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local PlayWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local PlayWithRewardTelemetry = require(PlayWithRewardComponent.PlayWithRewardTelemetry)
local PlayWithRewardComponentParent = PlayWithRewardComponent.Parent
local Promise = require(PlayWithRewardComponentParent.Promise)
local Logger = require(PlayWithRewardComponentParent.Loggers).Logger
local mutedError = require(PlayWithRewardComponentParent.Loggers).mutedError
local t = require(PlayWithRewardComponentParent.t)
local IXPServiceWrapper = require(PlayWithRewardComponentParent.IXPServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(PlayWithRewardComponentParent.ExperimentLayers).AppUserLayers
local v12 = game:DefineFastFlag("LuaAppRemovePlayWithRewardBetaAllowlist", false)
local PlayWithRewardState = require(PlayWithRewardComponentParent.PlayWithRewardState)
local PlayWithRewardAdData = PlayWithRewardState.PlayWithRewardAdData
local SetPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState
local v16 = game:DefineFastString("LuaAppPlayWithRewardBetaUniverses", "")
local v17 = game:DefineFastString("LuaAppPlayWithRewardBetaIxpVariantKey", "Variant")
local v18 = game:DefineFastString("LuaAppPlayWithRewardBetaIxpTreatmentValue", "Treatment")
local v19 = game:DefineFastFlag("LuaAppPlayWithRewardSkipIxpForShimmer", false)
local v20 = game:DefineFastFlag("LuaAppPlayWithRewardUsePlatformSpecificLayerValueForShimmer", false)

local function isUniverseIdInPlayWithRewardBetaAllowList(s1: string, s2: string) -- line: 31
	local v31 = s1:gsub("^%s+", ""):gsub("%s+$", "")

	if v31 == "" or (s2 == "" or s2:find(",", 1, true) ~= nil) then
		return false
	end

	return ("," .. v31 .. ","):find("," .. s2 .. ",", 1, true) ~= nil
end

local v22 = t.interface({
	AdAvailabilityResult = t.userdata,
	ProductId = t.optional(t.string),
	ProductName = t.optional(t.string),
	ProductImageAssetId = t.optional(t.string),
	ExperimentVariantData = t.optional(t.string)
})
local v23 = t.interface({
	IsEligible = t.boolean
})

local function getDurationSinceStartFetchMs(n1: number) -- line: 54
	return (os.clock() - n1) * 1000
end
local function fetchAd(p1, p2, _) -- line: 58
	local AdAvailabilityNowForUniverseAsync = p1:GetAdAvailabilityNowForUniverseAsync(Enum.AdFormat.RewardedVideo, tonumber(p2), true)

	if AdAvailabilityNowForUniverseAsync then
		return AdAvailabilityNowForUniverseAsync
	end

	return nil
end
local function fetchPlayWithRewardStateAsync(p4, s3: string, _: number, s4: string) -- line: 69
	-- upvalues: Logger (copy), PlayWithRewardTelemetry (copy), v22 (copy), mutedError (copy), PlayWithRewardAdData (copy)
	if not p4 then
		Logger:warning(`AdService is not available. Cannot fetch Play with Reward data for universe ID { s3 }.`)

		return nil
	end

	local elapsed = os.clock()

	PlayWithRewardTelemetry.logPlayWithRewardAdRequested(s4, s3)

	local v42 = p4:GetAdAvailabilityNowForUniverseAsync(Enum.AdFormat.RewardedVideo, tonumber(s3), true) or nil

	if v42 == nil then
		Logger:warning(`Could not fetch Play with Reward ad for universe ID { s3 }.`)
		PlayWithRewardTelemetry.logPlayWithRewardAdReceived(s4, s3, false, nil, (os.clock() - elapsed) * 1000, nil)

		return nil
	end

	local v43, v44 = v22(v42)

	if not v43 then
		mutedError(`PlayWithRewardAdData invalid: { tostring(v44) }`)
		PlayWithRewardTelemetry.logPlayWithRewardAdReceived(s4, s3, false, nil, (os.clock() - elapsed) * 1000, nil)

		return nil
	end

	local AdAvailabilityResult = v42.AdAvailabilityResult
	local ProductId = v42.ProductId
	local ProductName = v42.ProductName
	local ProductImageAssetId = v42.ProductImageAssetId
	local ExperimentVariantData = v42.ExperimentVariantData

	PlayWithRewardTelemetry.logPlayWithRewardAdReceived(s4, s3, true, tostring(AdAvailabilityResult), (os.clock() - elapsed) * 1000, ProductId)

	return PlayWithRewardAdData.new(AdAvailabilityResult, ProductId, ProductName, ProductImageAssetId, ExperimentVariantData)
end
local function shouldShowShimmer(p5, s5: string) -- line: 134
	-- upvalues: Logger (copy), v23 (copy), v19 (copy), v20 (copy), UserInputService (copy), IXPServiceWrapper (copy), AppUserLayers (copy), v17 (copy), v18 (copy)
	if not p5 then
		Logger:warning(`AdService is not available. Cannot determine whether to show shimmer for universe ID { s5 }.`)

		return false
	end

	local ok, result = pcall(function() -- line: 141
		-- upvalues: p5 (copy)
		return p5:GetUniversalAppAdsEligibility()
	end)

	if not ok or not result then
		return false
	end

	local v54, _ = v23(result)

	if v54 and result.IsEligible then
		if v19 then
			return true
		end

		local v56 = if not v20 or UserInputService:GetPlatform() ~= Enum.Platform.Android then IXPServiceWrapper:GetLayerData(AppUserLayers.AdsPlayWithRewardBetaLayer) else IXPServiceWrapper:GetLayerData(AppUserLayers.AdsPlayWithRewardBetaAndroidLayer)

		if v56 and (v56[v17] and v56[v17] == v18) then
			return true
		end
	end

	return false
end
local function FetchPlayWithRewardState(p6, s6: string, n3: number) -- line: 167
	-- upvalues: v12 (copy), isUniverseIdInPlayWithRewardBetaAllowList (copy), v16 (copy), Promise (copy), HttpService (copy), shouldShowShimmer (copy), PlayWithRewardTelemetry (copy), SetPlayWithRewardState (copy), fetchPlayWithRewardStateAsync (copy), Logger (copy)
	return function(p7) -- line: 168
		-- upvalues: v12 (copy), isUniverseIdInPlayWithRewardBetaAllowList (copy), v16 (copy), s6 (copy), Promise (copy), HttpService (copy), shouldShowShimmer (copy), p6 (copy), PlayWithRewardTelemetry (copy), SetPlayWithRewardState (copy), fetchPlayWithRewardStateAsync (copy), n3 (copy), Logger (copy)
		if not v12 and not isUniverseIdInPlayWithRewardBetaAllowList(v16, s6) then
			return Promise.resolve()
		end

		local guid = HttpService:GenerateGUID(false)

		if shouldShowShimmer(p6, s6) then
			PlayWithRewardTelemetry.logPlayWithRewardShimmerShown(guid, s6)
			p7:dispatch(SetPlayWithRewardState(guid, s6, true, nil))
		end

		return Promise.new(function(resolve, reject) -- line: 180
			-- upvalues: fetchPlayWithRewardStateAsync (copy), p6 (copy), s6 (copy), n3 (copy), guid (copy), p7 (copy), SetPlayWithRewardState (copy)
			local ok, result = pcall(function() -- line: 181
				-- upvalues: fetchPlayWithRewardStateAsync (copy), p6 (copy), s6 (copy), n3 (copy), guid (copy)
				return fetchPlayWithRewardStateAsync(p6, s6, n3, guid)
			end)

			if ok and result then
				p7:dispatch(SetPlayWithRewardState(guid, s6, false, result))
				resolve()

				return
			end

			p7:dispatch(SetPlayWithRewardState(guid, s6, false, nil))
			reject(result)
		end):catch(function(p8) -- line: 191
			-- upvalues: Logger (copy), s6 (copy)
			Logger:warning(`Promise for fetching Play With Reward data rejected for universe ID { s6 }: { tostring(p8) }`)
		end)
	end
end

return FetchPlayWithRewardState
