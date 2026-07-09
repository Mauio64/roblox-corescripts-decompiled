local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local OmniFeedTypes = require(ServerDrivenUiParent.DiscoveryTypes).OmniFeedTypes

require(ServerDrivenUiParent.LuauPolyfill)

local MakeOmniRecommendationsRequest = require(ServerDrivenUiParent.GraphQlShared).MakeOmniRecommendationsRequest
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local SduiLoadTimer = require(ServerDrivenUiParent.SduiSharedUtilities).SduiLoadTimer
local seedHomeOmniSduiV2Payload = require(ServerDrivenUi.Migration.seedHomeOmniSduiV2Payload)
local FStringLuaEnabledSduiTreatmentTypes = require(ServerDrivenUiParent.SharedFlags).FStringLuaEnabledSduiTreatmentTypes
local t1 = {}

local function getRefreshRequestKey(s1: string, s2: string, s3: string) -- line: 39
	return `{ s1 }:{ s2 }:{ s3 }`
end
local function isCurrentRequest(s4: string, s5: string) -- line: 43
	-- upvalues: t1 (copy)
	return s5 == t1[s4]
end
local function getSupportedSduiTreatmentTypes() -- line: 47
	-- upvalues: RunService (copy), FStringLuaEnabledSduiTreatmentTypes (copy)
	local RobloxVersion = RunService:GetRobloxVersion()
	local num = tonumber(string.match(RobloxVersion, ".(%d+)."))
	local t2 = {}
	local parts = string.split(FStringLuaEnabledSduiTreatmentTypes, ",")

	for _, v in ipairs(parts) do
		if v ~= "" then
			local v34, v35 = string.match(v, "(.*):(.*)")
			local num2 = tonumber(v35)

			if v34 and num2 and num2 <= num then
				table.insert(t2, v34)
			end
		end
	end

	return t2
end
local function findSortByTopicId(t3: {[any]: any}, s6: string) -- line: 65
	for _, v40 in t3 do
		if typeof(v40) == "table" and v40.topicId and s6 == tostring(v40.topicId) then
			return v40
		end
	end

	return nil
end
local function hasPageEntryForFeedItemKey(t4: {[any]: any}, s7: string) -- line: 74
	local pageEntries = t4.pageEntries

	if typeof(pageEntries) ~= "table" then
		return false
	end

	for _, v45 in pageEntries do
		if v45 and typeof(v45) == "table" and v45.pageEntry and s7 == v45.pageEntry.identifier then
			return true
		end
	end

	return false
end
local function reportValidationError(p1: ((...any) -> ...any), s8: string, t5: {[any]: any}) -- line: 94
	p1(t5.errorType, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `{ t5.message }, topicIds: { s8 }`
	})
end
local function reportNetworkError(p2: ((...any) -> ...any), s9: string, p3) -- line: 101
	-- upvalues: SduiErrors (copy), SduiParseHelpers (copy)
	p2(SduiErrors.SduiErrorType.FailedToFetchPage, {
		name = "discovery-api/omni-recommendation/sduiv2",
		message = `Omni recommendation feed item refresh failed: { SduiParseHelpers.stringifyValue(p3) }, topicIds: { s9 }`
	})
end
local function validateResponseBody(p4, s10: string, s11: string) -- line: 108
	-- upvalues: SduiErrors (copy), findSortByTopicId (copy), OmniFeedTypes (copy), hasPageEntryForFeedItemKey (copy)
	if p4 == nil or typeof(p4) ~= "table" then
		return false, {
			message = "No response data from omni recommendation feed item refresh",
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse
		}
	end

	if p4.sorts == nil or typeof(p4.sorts) ~= "table" or #p4.sorts == 0 then
		return false, {
			message = "No sort data in omni recommendation feed item refresh response",
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse
		}
	end

	local v55 = findSortByTopicId(p4.sorts, s10)

	if v55 == nil then
		return false, {
			message = "Requested sort not found in omni recommendation feed item refresh response",
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse
		}
	end

	if v55.treatmentType ~= OmniFeedTypes.ServerDrivenUiV2 then
		return false, {
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
			message = `Requested sort is not SDUI V2 in omni recommendation feed item refresh response: { v55.treatmentType }`
		}
	end

	local v56 = if typeof(v55) ~= "table" then nil else v55.feedItemKey

	if typeof(v56) ~= "string" or v56 == "" then
		return false, {
			message = "Missing feedItemKey in omni recommendation feed item refresh response",
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse
		}
	end

	if v56 ~= s11 then
		return false, {
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse,
			message = `Wrong feedItemKey in omni recommendation feed item refresh response: { v56 }`
		}
	end

	if p4.sduiv2 == nil or typeof(p4.sduiv2) ~= "table" then
		return false, {
			message = "No sduiv2 field in omni recommendation feed item refresh response",
			errorType = SduiErrors.SduiErrorType.NilSduiTreeInResponse
		}
	end

	if not hasPageEntryForFeedItemKey(p4.sduiv2, s11) then
		return false, {
			message = "Requested feed item not found in sduiv2 page entries",
			errorType = SduiErrors.SduiErrorType.InvalidFeedInResponse
		}
	end

	return true, nil
end
local function refreshOmniRecommendationFeedItem(p5, s12: string, s13: string, s14: string, s15: string, p6: ((...any) -> ...any), t6: {[any]: any}) -- line: 180
	-- upvalues: SduiLoadTimer (copy), OmniFeedTypes (copy), getSupportedSduiTreatmentTypes (copy), HttpService (copy), t1 (copy), MakeOmniRecommendationsRequest (copy), validateResponseBody (copy), seedHomeOmniSduiV2Payload (copy), SduiErrors (copy), SduiParseHelpers (copy)
	local v64 = t6.loadTimer or SduiLoadTimer.createLoadTimer(s12)

	v64.start("feed-item-refresh")

	local t7 = {}

	for _, v in pairs(OmniFeedTypes) do
		table.insert(t7, v)
	end

	local v68 = nil
	local ok, result = pcall(getSupportedSduiTreatmentTypes)

	if ok then
		v68 = result
	end

	local v71 = `{ s12 }:{ s13 }:{ s14 }`
	local v72 = HttpService:GenerateGUID(false):lower()

	t1[v71] = v72

	return MakeOmniRecommendationsRequest(p5, s12, HttpService:GenerateGUID(false):lower(), nil, t7, s15, { s13 }, v68, t6.contextFeatures):andThen(function(p7) -- line: 218
		-- upvalues: v71 (copy), v72 (copy), t1 (copy), validateResponseBody (copy), s13 (copy), s14 (copy), p6 (copy), seedHomeOmniSduiV2Payload (copy), s12 (copy), v64 (copy), SduiErrors (copy)
		local v74 = v71

		if v72 ~= t1[v74] then
			return
		end

		local v75 = if typeof(p7) ~= "table" then nil else p7.responseBody
		local v76, v77 = validateResponseBody(v75, s13, s14)

		if not v76 then
			assert(v77, "Validation error should exist when response is invalid")

			local v78 = p6
			local v79 = s13

			v78(v77.errorType, {
				name = "discovery-api/omni-recommendation/sduiv2",
				message = `{ v77.message }, topicIds: { v79 }`
			})

			return
		end

		local ok2, result2 = pcall(function() -- line: 233
			-- upvalues: seedHomeOmniSduiV2Payload (copy), v75 (copy), s12 (copy), v64 (copy)
			seedHomeOmniSduiV2Payload(v75.sduiv2, s12, v64)
		end)

		if not ok2 then
			p6(SduiErrors.SduiErrorType.ErrorStoringOmniData, {
				name = "discovery-api/omni-recommendation/sduiv2",
				message = `Error seeding omni recommendation feed item: { result2 }, topicIds: { s13 }`
			})

			return
		end
	end):catch(function(p8) -- line: 246
		-- upvalues: v71 (copy), v72 (copy), t1 (copy), p6 (copy), s13 (copy), SduiErrors (copy), SduiParseHelpers (copy)
		local v83 = v71

		if v72 ~= t1[v83] then
			return
		end

		local v84 = p6
		local v85 = s13

		v84(SduiErrors.SduiErrorType.FailedToFetchPage, {
			name = "discovery-api/omni-recommendation/sduiv2",
			message = `Omni recommendation feed item refresh failed: { SduiParseHelpers.stringifyValue(p8) }, topicIds: { v85 }`
		})
	end):finally(function() -- line: 253
		-- upvalues: v71 (copy), v72 (copy), t1 (copy), v64 (copy)
		local v86 = v71

		if v72 == t1[v86] then
			v64.logRefreshComplete()
			t1[v71] = nil
		end
	end)
end

return refreshOmniRecommendationFeedItem
