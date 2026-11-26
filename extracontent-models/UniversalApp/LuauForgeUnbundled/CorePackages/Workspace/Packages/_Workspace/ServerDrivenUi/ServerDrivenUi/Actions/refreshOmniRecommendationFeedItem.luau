local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local omniFeedTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryTypes").OmniFeedTypes
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/LuauPolyfill")
local makeOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GraphQlShared").MakeOmniRecommendationsRequest
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").SduiLoadTimer

local seedHomeOmniSduiV2Payload = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/seedHomeOmniSduiV2Payload")

local fStringLuaEnabledSduiTreatmentTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FStringLuaEnabledSduiTreatmentTypes

local v5 = {}

local function getRefreshRequestKey(p2, p3, p4)
	return `{p2}:{p3}:{p4}`
end

local function isCurrentRequest(p2, p3): boolean
	return v5[p2] == p3
end

local function getSupportedSduiTreatmentTypes()
	local robloxVersion = RunService:GetRobloxVersion()
	local v6 = tonumber(string.match(robloxVersion, ".(%d+)."))

	local v7 = string.split(fStringLuaEnabledSduiTreatmentTypes, ",")
	local supportedSduiTreatmentTypes = {}

	for i, v8 in ipairs(v7) do
		if v8 == "" then
			continue
		end

		local v9, v10 = string.match(v8, "(.*):(.*)")
		local v11 = tonumber(v10)

		if v9 and v11 and v11 <= v6 then
			table.insert(supportedSduiTreatmentTypes, v9)
		end
	end

	return supportedSduiTreatmentTypes
end

local function findSortByTopicId(sorts, p2)
	for k, item in sorts do
		if typeof(item) == "table" and item.topicId and tostring(item.topicId) == p2 then
			return item
		end
	end

	return nil
end

local function hasPageEntryForFeedItemKey(sduiv2, p2): boolean
	local pageEntries = sduiv2.pageEntries

	if typeof(pageEntries) ~= "table" then
		return false
	end

	for k, pageEntry in pageEntries do
		if
			pageEntry
			and typeof(pageEntry) == "table"
			and pageEntry.pageEntry
			and pageEntry.pageEntry.identifier == p2
		then
			return true
		end
	end

	return false
end

local function reportValidationError(callback, p2, p3)
	callback(p3.errorType, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `{p3.message}, topicIds: {p2}`
	})
end

local function reportNetworkError(callback, p2, p3)
	callback(sduiErrors.SduiErrorType.FailedToFetchPage, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `Omni recommendation feed item refresh failed: {sduiParseHelpers.stringifyValue(p3)}, topicIds: {p2}`
	})
end

local function validateResponseBody(responseBody, p2, p3)
	if responseBody == nil or typeof(responseBody) ~= "table" then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "No response data from omni recommendation feed item refresh"
			}
	end

	if responseBody.sorts == nil or typeof(responseBody.sorts) ~= "table" or #responseBody.sorts == 0 then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "No sort data in omni recommendation feed item refresh response"
			}
	end

	local sortByTopicId = findSortByTopicId(responseBody.sorts, p2)

	if sortByTopicId == nil then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "Requested sort not found in omni recommendation feed item refresh response"
			}
	end

	if sortByTopicId.treatmentType ~= omniFeedTypes.ServerDrivenUiV2 then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = `Requested sort is not SDUI V2 in omni recommendation feed item refresh response: {sortByTopicId.treatmentType}`
			}
	end

	local feedItemKey = if typeof(sortByTopicId) == "table" then sortByTopicId.feedItemKey else nil

	if typeof(feedItemKey) ~= "string" or feedItemKey == "" then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = "Missing feedItemKey in omni recommendation feed item refresh response"
			}
	end

	if feedItemKey ~= p3 then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
				message = `Wrong feedItemKey in omni recommendation feed item refresh response: {feedItemKey}`
			}
	end

	if responseBody.sduiv2 == nil or typeof(responseBody.sduiv2) ~= "table" then
		return
			false,
			{
				errorType = sduiErrors.SduiErrorType.NilSduiTreeInResponse,
				message = "No sduiv2 field in omni recommendation feed item refresh response"
			}
	end

	if hasPageEntryForFeedItemKey(responseBody.sduiv2, p3) then
		return true, nil
	end

	return
		false,
		{
			errorType = sduiErrors.SduiErrorType.InvalidFeedInResponse,
			message = "Requested feed item not found in sduiv2 page entries"
		}
end

local function refreshOmniRecommendationFeedItem(p2, p3, p4, p5, p6, callback, p7)
	local loadTimer = p7.loadTimer or sduiLoadTimer.createLoadTimer(p3)
	loadTimer.start("feed-item-refresh")

	local omniFeedTypes2 = {}

	for k, omniFeedType in pairs(omniFeedTypes) do
		table.insert(omniFeedTypes2, omniFeedType)
	end

	local success, result = pcall(getSupportedSduiTreatmentTypes)

	if not success then
		result = nil
	end

	local formatted = `{p3}:{p4}:{p5}`

	local lower = HttpService:GenerateGUID(false):lower()
	v5[formatted] = lower

	return makeOmniRecommendationsRequest(
		p2,
		p3,
		HttpService:GenerateGUID(false):lower(),
		nil,
		omniFeedTypes2,
		p6,
		{ p4 },
		result,
		p7.contextFeatures
	):andThen(function(p8)
		if v5[formatted] ~= lower then
			return
		end

		local responseBody = if typeof(p8) == "table" then p8.responseBody else nil

		local v7, v8 = validateResponseBody(responseBody, p4, p5)

		if v7 then
			local success2, result2 = pcall(function()
				seedHomeOmniSduiV2Payload(responseBody.sduiv2, p3, loadTimer)
			end)

			if success2 then
				return
			end

			callback(sduiErrors.SduiErrorType.ErrorStoringOmniData, {
				name = "discovery-api/omni-recommendation/sduiv2",
				message = `Error seeding omni recommendation feed item: {result2}, topicIds: {p4}`
			})
		else
			assert(v8, "Validation error should exist when response is invalid")
			callback(v8.errorType, {
				name = "discovery-api/omni-recommendation/sduiv2",
				message = `{v8.message}, topicIds: {p4}`
			})
		end
	end):catch(function(p8)
		if v5[formatted] ~= lower then
			return
		end

		callback(sduiErrors.SduiErrorType.FailedToFetchPage, {
			name = "discovery-api/omni-recommendation/sduiv2",
			message = `Omni recommendation feed item refresh failed: {sduiParseHelpers.stringifyValue(p8)}, topicIds: {p4}`
		})
	end):finally(function()
		if v5[formatted] == lower then
			loadTimer.logRefreshComplete()

			v5[formatted] = nil
		end
	end)
end

return refreshOmniRecommendationFeedItem
