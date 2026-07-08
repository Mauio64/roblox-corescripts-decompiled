local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local requestInternalWrapper = require(CorePackages.Workspace.Packages.Http).NetworkLayers.requestInternalWrapper
local MakeOmniRecommendationsRequest = require(CorePackages.Workspace.Packages.GraphQlShared).MakeOmniRecommendationsRequest
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local Telemetry = require(script.Parent.Telemetry)
local FFlagEnableInGameExitModalNextUpUiRequestCache = require(script.Parent.Flags.FFlagEnableInGameExitModalNextUpUiRequestCache)
local v11 = requestInternalWrapper(nil)
local v12 = game:DefineFastString("InGameExitModalNextUpUiSortTopicId", "100000014")
local v13 = game:DefineFastFlag("InGameExitModalEnableFilterForCurrentExperience", false)

local function metadataToSortEntry(n1: number, n2: number, t1: {[any]: any}) -- line: 46
	local wideImageAssetId = (((t1.layoutDataBySort or {})[n1] or {}).primaryMediaAsset or {}).wideImageAssetId
	local v25 = if not wideImageAssetId or wideImageAssetId == "0" then `rbxthumb://type=GameThumbnail&id={ t1.rootPlaceId }&w=384&h=216` else `rbxthumb://type=Asset&id={ wideImageAssetId }&w=384&h=216`

	return {
		uiIndex = n2,
		universeId = tostring(t1.universeId),
		placeId = tostring(t1.rootPlaceId),
		name = t1.name,
		image = v25,
		upVotes = t1.totalUpVotes,
		downVotes = t1.totalDownVotes,
		layoutDataBySort = t1.layoutDataBySort or {}
	}
end

local v15 = t.interface({
	contentType = t.string,
	contentId = t.number
})
local v16 = t.interface({
	name = t.string,
	universeId = t.number,
	rootPlaceId = t.number,
	totalUpVotes = t.number,
	totalDownVotes = t.number,
	layoutDataBySort = t.optional(t.table)
})

local function parseSortEntries(p1, p2) -- line: 88
	-- upvalues: v15 (copy), v16 (copy), metadataToSortEntry (copy), v13 (copy)
	local t2 = {}

	for _, v30 in p1.recommendationList do
		if v15(v30) and v30.contentType == "Game" then
			local v31 = p2[tostring(v30.contentId)]

			if v16(v31) then
				local v32 = metadataToSortEntry(p1.topicId, #t2 + 1, v31)

				if v32 and (not v13 or v32.universeId ~= tostring(game.GameId)) then
					table.insert(t2, v32)
				end
			end
		end
	end

	return t2
end

local v18 = t.interface({
	responseBody = t.interface({
		sorts = t.table,
		contentMetadata = t.interface({
			Game = t.table
		})
	}),
	responseTimeMs = t.number
})
local v19 = t.interface({
	topicId = t.number,
	recommendationList = t.table
})

local function parseOmniResponse(p3) -- line: 135
	-- upvalues: v18 (copy), Telemetry (copy), v19 (copy), v12 (copy), parseSortEntries (copy)
	if not v18(p3) then
		return nil
	end

	Telemetry.logRequestLatency("discovery-api/omni-recommendation", p3.responseTimeMs)

	local responseBody = p3.responseBody
	local sorts = responseBody.sorts
	local v36 = responseBody.contentMetadata and responseBody.contentMetadata.Game or nil

	for _, v38 in sorts do
		if v19(v38) and tostring(v38.topicId) == v12 then
			return {
				entries = parseSortEntries(v38, v36),
				topicId = tostring(v38.topicId)
			}
		end
	end

	return nil
end

return function() -- line: 168
	-- upvalues: React (copy), Promise (copy), MakeOmniRecommendationsRequest (copy), v11 (copy), HttpService (copy), v12 (copy), parseOmniResponse (copy), FFlagEnableInGameExitModalNextUpUiRequestCache (copy), ContentProvider (copy)
	local v39, v40 = React.useState(nil)
	local v41, v42 = React.useState(false)

	React.useEffect(function() -- line: 173
		-- upvalues: v42 (copy), v40 (copy), Promise (copy), MakeOmniRecommendationsRequest (copy), v11 (copy), HttpService (copy), v12 (copy), parseOmniResponse (copy), FFlagEnableInGameExitModalNextUpUiRequestCache (copy), ContentProvider (copy)
		v42(true)
		v40(nil)

		local v43 = Promise.new(function(_, _, onCancel) -- line: 177
			-- upvalues: MakeOmniRecommendationsRequest (copy), v11 (copy), HttpService (copy), v12 (copy), parseOmniResponse (copy), FFlagEnableInGameExitModalNextUpUiRequestCache (copy), ContentProvider (copy), v40 (copy), v42 (copy)
			local v47 = MakeOmniRecommendationsRequest(v11, "InGameExitModal", HttpService:GenerateGUID(false):lower(), nil, {
				"Carousel",
				"SortlessGrid"
			}, "gameExitRecommendation", { v12 }, nil)

			onCancel(function() -- line: 189
				-- upvalues: v47 (copy)
				v47:cancel()
			end)
			v47:andThen(function(p6) -- line: 194
				-- upvalues: parseOmniResponse (copy), FFlagEnableInGameExitModalNextUpUiRequestCache (copy), ContentProvider (copy), v40 (copy)
				local v49 = parseOmniResponse(p6)

				if not v49 then
					return
				end

				if #v49.entries < 4 then
					return
				end

				if FFlagEnableInGameExitModalNextUpUiRequestCache then
					local t3 = {}

					table.insert(t3, v49.entries[1].image)
					table.insert(t3, v49.entries[2].image)
					table.insert(t3, v49.entries[3].image)
					table.insert(t3, v49.entries[4].image)
					ContentProvider:PreloadAsync(t3)
				end

				v40(v49)
			end, function(_) -- line: 213
			end):finally(function() -- line: 216
				-- upvalues: v42 (copy)
				v42(false)
			end)
		end)

		return function() -- line: 221
			-- upvalues: v43 (copy)
			v43:cancel()
		end
	end, {})

	return {
		data = v39,
		loading = v41
	}
end
