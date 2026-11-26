local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiCoreSystem")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")
local sduiRequestConcurrencyPolicy = SduiSharedUtilities.SduiRequestConcurrencyPolicy
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")

local fFlagSduiRefreshFeedItemIsOmissionExpected = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagSduiRefreshFeedItemIsOmissionExpected

local v5 = {}
local count = 0

local v6 = {}

local function getMountedInputData()
	return getSduiApiStore().getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
end

local function isTargetMounted(p2): boolean
	local inputData = getSduiApiStore().getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)

	return typeof(inputData) == "table"
		and typeof(inputData.entry_map) == "table"
		and inputData.entry_map[p2] ~= nil
end

function v6.isCurrent(data)
	local sduiApiStore = getSduiApiStore()
	local v7

	if
		v5[data.options.feedItemKey] == data.requestId
		and sduiApiStore.getDataUpdatedTimestamp(HomeConstants.ConfigKey, false, HomeConstants.FeedEntryCacheKey) == data.capturedTimestamp
	then
		local feedItemKey = data.options.feedItemKey
		local inputData = getSduiApiStore().getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)

		if typeof(inputData) == "table" and typeof(inputData.entry_map) == "table" then
			v7 = inputData.entry_map[feedItemKey] ~= nil
		else
			v7 = false
		end
	else
		v7 = false
	end

	return v7
end

function v6.register(p2)
	local dataUpdatedTimestamp = getSduiApiStore().getDataUpdatedTimestamp(
		HomeConstants.ConfigKey,
		false,
		HomeConstants.FeedEntryCacheKey
	)

	if dataUpdatedTimestamp == nil then
		return nil
	end

	local feedItemKey = p2.feedItemKey
	local inputData = getSduiApiStore().getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
	local v7

	if typeof(inputData) == "table" and typeof(inputData.entry_map) == "table" then
		v7 = inputData.entry_map[feedItemKey] ~= nil
	else
		v7 = false
	end

	if v7 then
		count += 1
		v5[p2.feedItemKey] = count
		return {
			options = p2,
			requestId = count,
			capturedTimestamp = dataUpdatedTimestamp,
			foundTarget = false
		}
	end

	return nil
end

function v6:applyToRequestConfig(p3)
	self.concurrencyKey = `{module3.ConfigKey}_{p3.options.feedItemKey}`
	self.concurrencyPolicy = sduiRequestConcurrencyPolicy.LatestWins
	function self.isResponseCurrent()
		return v6.isCurrent(p3)
	end

	self.enableInputDataMerge = true
	self.cacheSingleEntryWithIdentifier = true
	function self.mergeStrategy(list): nil | string
		if #list == 1 then
			if list[1] == "entry_map" then
				return nil
			end

			if list[1] == "content_pools" then
				return "merge"
			end

			return "preserve"
		end

		if #list ~= 2 or list[1] ~= "entry_map" then
			return nil
		end

		if list[2] ~= p3.options.feedItemKey then
			return "preserve"
		end

		p3.foundTarget = true
		return "replace"
	end
end

local function reportError(p2, p3, p4)
	p2.options.reportError(p3, {
		name = HomeConstants.ApiName,
		message = `{p4}, topicIds: {p2.options.topicId}`
	})
end

function v6.resolve(object, p2)
	return object:andThen(function(): boolean
		if not v6.isCurrent(p2) then
			return false
		end

		if p2.foundTarget then
			return true
		end

		if not (fFlagSduiRefreshFeedItemIsOmissionExpected and p2.options.isOmissionExpected) then
			local v7 = p2
			local invalidFeedInResponse = SduiCoreSystem.SduiErrors.SduiErrorType.InvalidFeedInResponse
			v7.options.reportError(invalidFeedInResponse, {
				name = HomeConstants.ApiName,
				message = `Focused response omitted target, topicIds: {v7.options.topicId}`
			})
		end

		return false
	end, function(p3): boolean
		if not v6.isCurrent(p2) then
			return false
		end

		local v7 = p2
		local failedToFetchPage = SduiCoreSystem.SduiErrors.SduiErrorType.FailedToFetchPage
		local stringifyValue = SduiCoreSystem.SduiParseHelpers.stringifyValue(p3)
		v7.options.reportError(failedToFetchPage, {
			name = HomeConstants.ApiName,
			message = `{stringifyValue}, topicIds: {v7.options.topicId}`
		})

		return false
	end)
end

return v6
