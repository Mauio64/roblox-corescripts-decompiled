local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local DiscoveryTypes = require(parent.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
require(parent.LuauPolyfill)
local GraphQlShared = require(parent.GraphQlShared)
local MakeOmniRecommendationsRequest = GraphQlShared.MakeOmniRecommendationsRequest
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local seedHomeOmniSduiV2Payload = require(ServerDrivenUi.Migration.seedHomeOmniSduiV2Payload)

local SharedFlags = require(parent.SharedFlags)
local FStringLuaEnabledSduiTreatmentTypes = SharedFlags.FStringLuaEnabledSduiTreatmentTypes

local v = {}

local function getRefreshRequestKey(p: string, p2: string, p3: string) -- 1 equivalent call inferred from this helper
	return `{p}:{p2}:{p3}`
end

local function isCurrentRequest(refreshRequestKey: string, lower: string): boolean -- 3 equivalent calls inferred from this helper
	return v[refreshRequestKey] == lower
end

local function getSupportedSduiTreatmentTypes()
	local robloxVersion = RunService:GetRobloxVersion()
	local v2 = tonumber(string.match(robloxVersion, ".(%d+)."))

	local v3 = string.split(FStringLuaEnabledSduiTreatmentTypes, ",")
	local supportedSduiTreatmentTypes = {}

	for _, v4 in ipairs(v3) do
		if v4 == "" then
			continue
		end

		local v5, v6 = string.match(v4, "(.*):(.*)")
		local v7 = tonumber(v6)

		if v5 and v7 and v7 <= v2 then
			table.insert(supportedSduiTreatmentTypes, v5)
		end
	end

	return supportedSduiTreatmentTypes
end

local function findSortByTopicId(sorts, p: string)
	for _, item in sorts do
		if typeof(item) == "table" and item.topicId and tostring(item.topicId) == p then
			return item
		end
	end

	return nil
end

local function hasPageEntryForFeedItemKey(sduiv2, p: string): boolean
	local pageEntries = sduiv2.pageEntries

	if typeof(pageEntries) ~= "table" then
		return false
	end

	for _, pageEntry in pageEntries do
		if
			pageEntry
			and typeof(pageEntry) == "table"
			and pageEntry.pageEntry
			and pageEntry.pageEntry.identifier == p
		then
			return true
		end
	end

	return false
end

local function reportValidationError(callback, p: string, p2) -- 1 equivalent call inferred from this helper
	callback(p2.errorType, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `{p2.message}, topicIds: {p}`
	})
end

local function reportNetworkError(callback, p: string, p2) -- 1 equivalent call inferred from this helper
	callback(SduiErrors.SduiErrorType.FailedToFetchPage, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `Omni recommendation feed item refresh failed: {SduiParseHelpers.stringifyValue(p2)}, topicIds: {p}`
	})
end

local function validateResponseBody(responseBody, p: string, p2: string)
	if responseBody == nil or typeof(responseBody) ~= "table" then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "No response data from omni recommendation feed item refresh"
			}
	end

	if responseBody.sorts == nil or typeof(responseBody.sorts) ~= "table" or #responseBody.sorts == 0 then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "No sort data in omni recommendation feed item refresh response"
			}
	end

	local sortByTopicId = findSortByTopicId(responseBody.sorts, p)

	if sortByTopicId == nil then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "Requested sort not found in omni recommendation feed item refresh response"
			}
	end

	if sortByTopicId.treatmentType ~= OmniFeedTypes.ServerDrivenUiV2 then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = `Requested sort is not SDUI V2 in omni recommendation feed item refresh response: {sortByTopicId.treatmentType}`
			}
	end

	local feedItemKey

	if typeof(sortByTopicId) == "table" then
		feedItemKey = sortByTopicId.feedItemKey
	end

	if typeof(feedItemKey) ~= "string" or feedItemKey == "" then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "Missing feedItemKey in omni recommendation feed item refresh response"
			}
	end

	if feedItemKey ~= p2 then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = `Wrong feedItemKey in omni recommendation feed item refresh response: {feedItemKey}`
			}
	end

	if responseBody.sduiv2 == nil or typeof(responseBody.sduiv2) ~= "table" then
		return
			false,
			{
				errorType = SduiErrors.SduiErrorType.NilSduiTreeInResponse,
				message = "No sduiv2 field in omni recommendation feed item refresh response"
			}
	end

	if hasPageEntryForFeedItemKey(responseBody.sduiv2, p2) then
		return true, nil
	end

	return
		false,
		{
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
			message = "Requested feed item not found in sduiv2 page entries"
		}
end

local function refreshOmniRecommendationFeedItem(p, p2: string, p3: string, p4: string, p5: string, callback, p6)
	local loadTimer = p6.loadTimer or SduiLoadTimer.createLoadTimer(p2)
	loadTimer.start("feed-item-refresh")

	local omniFeedTypes = {}

	for _, omniFeedType in pairs(OmniFeedTypes) do
		table.insert(omniFeedTypes, omniFeedType)
	end

	local success, result = pcall(getSupportedSduiTreatmentTypes)

	if not success then
		result = nil
	end

	local refreshRequestKey = getRefreshRequestKey(p2, p3, p4) -- inferred equivalent call
	local lower = HttpService:GenerateGUID(false):lower()
	v[refreshRequestKey] = lower

	return MakeOmniRecommendationsRequest(
		p,
		p2,
		HttpService:GenerateGUID(false):lower(),
		nil,
		omniFeedTypes,
		p5,
		{ p3 },
		result,
		p6.contextFeatures
	):andThen(function(p7)
		if not isCurrentRequest(refreshRequestKey, lower) then -- inferred equivalent call
			return
		end

		local responseBody

		if typeof(p7) == "table" then
			responseBody = p7.responseBody
		else
			responseBody = nil
		end

		local v2, v3 = validateResponseBody(responseBody, p3, p4)

		if v2 then
			local success2, result2 = pcall(function()
				seedHomeOmniSduiV2Payload(responseBody.sduiv2, p2, loadTimer)
			end)

			if success2 then
				return
			end

			callback(SduiErrors.SduiErrorType.ErrorStoringOmniData, {
				name = "discovery-api/omni-recommendation/sduiv2",
				message = `Error seeding omni recommendation feed item: {result2}, topicIds: {p3}`
			})
		else
			assert(v3, "Validation error should exist when response is invalid")
			reportValidationError(callback, p3, v3) -- inferred equivalent call
		end
	end):catch(function(p7)
		if not isCurrentRequest(refreshRequestKey, lower) then -- inferred equivalent call
			return
		end

		reportNetworkError(callback, p3, p7) -- inferred equivalent call
	end):finally(function()
		if isCurrentRequest(refreshRequestKey, lower) then -- inferred equivalent call
			loadTimer.logRefreshComplete()

			v[refreshRequestKey] = nil
		end
	end)
end

return refreshOmniRecommendationFeedItem
