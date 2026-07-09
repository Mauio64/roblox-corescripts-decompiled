local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent

require(DiscoveryMonolithParent.DiscoveryTypes)

local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Promise = require(DiscoveryMonolithParent.Promise)
local DiscoveryUtils = require(DiscoveryMonolithParent.DiscoveryUtils)
local TopicContentsReducer = require(DiscoveryMonolithParent.TopicContentsRodux).TopicContentsReducer
local LoggingProtocol = require(DiscoveryMonolithParent.LoggingProtocol)
local Modules = DiscoveryMonolith.Modules
local OmniGetRecommendationsMetadata = require(Modules.LuaApp.Http.Requests.DiscoveryApi.OmniGetRecommendationsMetadata)
local SetOmniRecommendationsMetadataRequestStatus = require(Modules.LuaApp.Actions.Games.SetOmniRecommendationsMetadataRequestStatus)
local OmniUtils = require(Modules.LuaApp.Util.Omni.OmniUtils)
local GenerateTopicContents = require(Modules.Personalization.Games.DataStore.GenerateTopicContents)
local parseAndAddContentMetadata = require(Modules.LuaApp.Thunks.Omni.parseAndAddContentMetadata)
local FFlagLuaAppLogOmniRecommendationsMetadata = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppLogOmniRecommendationsMetadata
local v15 = game:DefineFastInt("OmniRecommendationsMetadataEventThrottlingHundredthsPercent", 0)

local function itemForId(p1, s1: string, p2) -- line: 24
	-- upvalues: OmniUtils (copy)
	local v22 = OmniUtils.storeForContentType(p1, s1)

	if v22 == nil then
		return nil
	end

	assert(v22, "store should always exist after this point")

	return v22[tostring(p2)]
end
local function getFetchingStatus(p3, s2: string, p4) -- line: 34
	if p3.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus == nil then
		return nil
	end

	local v26 = p3.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus[s2]

	if v26 == nil then
		return nil
	end

	return v26[tostring(p4)]
end
local function fetchOmniMetadata(p5, p6, p7, p8, p9, p10, p11) -- line: 45
	-- upvalues: Promise (copy), TopicContentsReducer (copy), RetrievalStatus (copy), OmniUtils (copy), SetOmniRecommendationsMetadataRequestStatus (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy), v15 (copy), LoggingProtocol (copy), OmniGetRecommendationsMetadata (copy), DiscoveryUtils (copy), parseAndAddContentMetadata (copy), GenerateTopicContents (copy)
	local v34 = p5:getState()
	local v35 = v34.OmniRecommendations and (not not v34.OmniRecommendations[p7] and v34.OmniRecommendations[p7].sorts[p8]) or nil

	if not v35 then
		return Promise.reject("pageType, sortIndex combo doesn't exist")
	end

	assert(v35, "OmniRecommendations sort should always exist")

	local topicId = v35.topicId

	if topicId == nil then
		return Promise.reject("TopicId for sortIndex " .. tostring(p8) .. " doesn't exist")
	end

	local str = tostring(topicId)
	local v38 = v34.Personalization[TopicContentsReducer.key][str]

	if not v38 then
		return Promise.reject("TopicContents for id: " .. str .. " doesn't exist")
	end

	assert(v38, "sortIndexContents always exists after this point")

	if not v38.hasMoreRows then
		return Promise.resolve("no more rows to fetch")
	end

	if not v35.recommendations then
		return Promise.reject(`No recommendations for sort index { p8 }`)
	end

	local t1 = {}
	local v40 = #v38.entries + 1

	for i = v40, math.min(v40 + p9, #v35.recommendations) do
		local v42 = v35.recommendations[i]
		local contentType = v42.contentType
		local contentId = v42.contentId
		local v45

		if v34.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus == nil then
			v45 = nil
		else
			local v46 = v34.RequestsStatus.OmniRecommendationsMetadataRetrievalStatus[contentType]

			v45 = if v46 ~= nil then v46[tostring(contentId)] else nil
		end

		local v47 = v45 ~= nil and v45 == RetrievalStatus.Fetching
		local contentType2 = v42.contentType
		local contentId2 = v42.contentId
		local v50 = OmniUtils.storeForContentType(v34, contentType2)
		local v51

		if v50 == nil then
			v51 = nil
		else
			assert(v50, "store should always exist after this point")
			v51 = v50[tostring(contentId2)]
		end

		if v51 == nil and not v47 then
			table.insert(t1, v42)
		end
	end

	if #t1 == 0 then
		return Promise.resolve("nothing new to fetch")
	end

	local t2 = {}

	for _, v in ipairs(t1) do
		if t2[v.contentType] == nil then
			t2[v.contentType] = {}
		end

		t2[v.contentType][tostring(v.contentId)] = RetrievalStatus.Fetching
	end

	p5:dispatch(SetOmniRecommendationsMetadataRequestStatus(t2))

	if FFlagLuaAppLogOmniRecommendationsMetadata then
		p10:logRobloxTelemetryEvent({
			eventName = "OmniRecommendationsMetadataRequestEvent",
			backends = {
				"Points",
				"EventIngest"
			},
			throttlingPercentage = v15
		}, {
			LoggingProtocol.StandardizedFields.addOsInfo,
			LoggingProtocol.StandardizedFields.addSessionId,
			"addSessionInfo"
		}, {
			pageType = p7,
			sortIndex = p8,
			countToFetch = p9,
			numberOfIdsToRequest = #t1,
			sortHasMoreRows = v38.hasMoreRows,
			sortNextPageToken = v38.nextPageToken or "none",
			callsite = p11
		})
	end

	return OmniGetRecommendationsMetadata(p6, t1):andThen(function(p12) -- line: 136
		-- upvalues: DiscoveryUtils (copy), p10 (copy), parseAndAddContentMetadata (copy), p6 (copy), p5 (copy), GenerateTopicContents (copy), p7 (copy), str (ref), FFlagLuaAppLogOmniRecommendationsMetadata (copy), v15 (copy), LoggingProtocol (copy), t2 (copy), RetrievalStatus (copy), SetOmniRecommendationsMetadataRequestStatus (copy), Promise (copy)
		DiscoveryUtils.logResponseTelemetry("discovery-api/omni-recommendation-metadata", p12, p10)

		local responseBody = p12.responseBody
		local v63 = parseAndAddContentMetadata(p6, p5, responseBody)

		p5:dispatch(GenerateTopicContents(p7, str))

		if FFlagLuaAppLogOmniRecommendationsMetadata then
			p10:logRobloxTelemetryEvent({
				eventName = "OmniRecommendationsMetadataResponseEvent",
				backends = {
					"Points",
					"EventIngest"
				},
				throttlingPercentage = v15
			}, {
				LoggingProtocol.StandardizedFields.addOsInfo,
				LoggingProtocol.StandardizedFields.addSessionId,
				"addSessionInfo"
			}, {
				numberOfContent = v63 and tostring(#v63) or "no content"
			})
		end

		local t3 = {}

		for k, v in pairs(t2) do
			t3[k] = {}

			for k2, _ in pairs(v) do
				t3[k][tostring(k2)] = RetrievalStatus.Failed
			end
		end

		for k, v in pairs(v63) do
			if not t3[k] then
				t3[k] = {}
			end

			for k3, _ in pairs(v) do
				t3[k][tostring(k3)] = RetrievalStatus.Done
			end
		end

		p5:dispatch(SetOmniRecommendationsMetadataRequestStatus(t3))

		return Promise.resolve()
	end, function(p13) -- line: 179
		-- upvalues: p5 (copy), SetOmniRecommendationsMetadataRequestStatus (copy), t1 (copy), RetrievalStatus (copy), Promise (copy)
		p5:dispatch(SetOmniRecommendationsMetadataRequestStatus(t1, RetrievalStatus.Failed))
		warn(p13)

		return Promise.reject(p13)
	end)
end

return function(p14, p15, p16, p17, p18, s3: string?) -- line: 186
	-- upvalues: fetchOmniMetadata (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy)
	return function(p19) -- line: 187
		-- upvalues: fetchOmniMetadata (copy), p14 (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy), s3 (copy)
		return fetchOmniMetadata(p19, p14, p15, p16, p17, p18, if not FFlagLuaAppLogOmniRecommendationsMetadata then nil else s3)
	end
end
