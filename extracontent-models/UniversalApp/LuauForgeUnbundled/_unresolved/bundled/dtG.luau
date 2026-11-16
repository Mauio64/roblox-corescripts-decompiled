require("@luauforge/bundled/dqn")
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus
local module = require("@luauforge/bundled/dqe")
local module2 = require("@luauforge/bundled/dqK")
local topicContentsReducer = require("@luauforge/bundled/dqs").TopicContentsReducer
local module3 = require("@luauforge/bundled/dqq")

local module4 = require("@luauforge/bundled/dth")

local module5 = require("@luauforge/bundled/dqS")
local module6 = require("@luauforge/bundled/drx")
local module7 = require("@luauforge/bundled/drv")
local module8 = require("@luauforge/bundled/dry")

local fFlagLuaAppLogOmniRecommendationsMetadata = require("@luauforge/bundled/dqB").FFlagLuaAppLogOmniRecommendationsMetadata

local defineFastInt = game:DefineFastInt("OmniRecommendationsMetadataEventThrottlingHundredthsPercent", 0)

local function itemForId(p2, p3, p4)
	local v5 = module6.storeForContentType(p2, p3)

	if v5 == nil then
		return nil
	end

	assert(v5, "store should always exist after this point")
	return v5[tostring(p4)]
end

local function getFetchingStatus(p2, p3, p4)
	if p2.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus == nil then
		return nil
	end

	local v5 = p2.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus[p3]

	if v5 == nil then
		return nil
	end

	return v5[tostring(p4)]
end

local function fetchOmniMetadata(object, p2, p3, p4, p5, object2, p6)
	local state = object:getState()
	local v5

	if state.OmniRecommendations and state.OmniRecommendations[p3] then
		v5 = state.OmniRecommendations[p3].sorts[p4] or nil
	end

	if not v5 then
		return module.reject("pageType, sortIndex combo doesn't exist")
	end

	assert(v5, "OmniRecommendations sort should always exist")

	local topicId = v5.topicId

	if topicId == nil then
		return module.reject("TopicId for sortIndex " .. tostring(p4) .. " doesn't exist")
	end

	local v6 = tostring(topicId)
	local v7 = state.Personalization[topicContentsReducer.key][v6]

	if not v7 then
		return module.reject("TopicContents for id: " .. v6 .. " doesn't exist")
	end

	assert(v7, "sortIndexContents always exists after this point")

	if not v7.hasMoreRows then
		return module.resolve("no more rows to fetch")
	end

	if not v5.recommendations then
		return module.reject(`No recommendations for sort index {p4}`)
	end

	local v8 = #v7.entries + 1
	local recommendations = {}

	for i = v8, math.min(v8 + p5, #v5.recommendations) do
		local recommendation = v5.recommendations[i]
		local contentType = recommendation.contentType
		local contentId = recommendation.contentId
		local v9

		if state.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus ~= nil then
			local v10 = state.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus[contentType]

			if v10 ~= nil then
				v9 = v10[tostring(contentId)]
			end
		end

		local v10 = not (v9 == nil) and v9 == retrievalStatus.Fetching
		local contentType2 = recommendation.contentType
		local contentId2 = recommendation.contentId
		local v11 = module6.storeForContentType(state, contentType2)
		local v12

		if v11 ~= nil then
			assert(v11, "store should always exist after this point")
			v12 = v11[tostring(contentId2)]
		end

		if v12 ~= nil or v10 then
			continue
		end

		table.insert(recommendations, recommendation)
	end

	if #recommendations == 0 then
		return module.resolve("nothing new to fetch")
	end

	local v9 = {}

	for i, v10 in ipairs(recommendations) do
		if v9[v10.contentType] == nil then
			v9[v10.contentType] = {}
		end

		v9[v10.contentType][tostring(v10.contentId)] = retrievalStatus.Fetching
	end

	object:dispatch(module5(v9))

	if fFlagLuaAppLogOmniRecommendationsMetadata then
		object2:logRobloxTelemetryEvent({
			eventName = "OmniRecommendationsMetadataRequestEvent",
			backends = { "Points", "EventIngest" },
			throttlingPercentage = defineFastInt
		}, {
			module3.StandardizedFields.addOsInfo,
			module3.StandardizedFields.addSessionId,
			"addSessionInfo"
		}, {
			pageType = p3,
			sortIndex = p4,
			countToFetch = p5,
			numberOfIdsToRequest = #recommendations,
			sortHasMoreRows = v7.hasMoreRows,
			sortNextPageToken = v7.nextPageToken or "none",
			callsite = p6
		})
	end

	return module4(p2, recommendations):andThen(function(p7)
		module2.logResponseTelemetry("discovery-api/omni-recommendation-metadata", p7, object2)
		local v10 = module8(p2, object, p7.responseBody)
		object:dispatch(module7(p3, v6))

		if fFlagLuaAppLogOmniRecommendationsMetadata then
			object2:logRobloxTelemetryEvent({
				eventName = "OmniRecommendationsMetadataResponseEvent",
				backends = { "Points", "EventIngest" },
				throttlingPercentage = defineFastInt
			}, {
				module3.StandardizedFields.addOsInfo,
				module3.StandardizedFields.addSessionId,
				"addSessionInfo"
			}, {
				numberOfContent = v10 and tostring(#v10) or "no content"
			})
		end

		local v11 = {}

		for k, v12 in pairs(v9) do
			v11[k] = {}

			for k2, v13 in pairs(v12) do
				v11[k][tostring(k2)] = retrievalStatus.Failed
			end
		end

		for k, v12 in pairs(v10) do
			if not v11[k] then
				v11[k] = {}
			end

			for k2, v13 in pairs(v12) do
				v11[k][tostring(k2)] = retrievalStatus.Done
			end
		end

		object:dispatch(module5(v11))

		return module.resolve()
	end, function(p7)
		object:dispatch(module5(recommendations, retrievalStatus.Failed))
		warn(p7)
		return module.reject(p7)
	end)
end

return function(p2, p3, p4, p5, p6, p7)
	return function(p8)
		return fetchOmniMetadata(
			p8,
			p2,
			p3,
			p4,
			p5,
			p6,
			if fFlagLuaAppLogOmniRecommendationsMetadata then p7 else nil
		)
	end
end
