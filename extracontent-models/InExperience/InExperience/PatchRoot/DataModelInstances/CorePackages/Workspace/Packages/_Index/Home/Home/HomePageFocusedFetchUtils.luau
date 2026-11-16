local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiRequestConcurrencyPolicy = SduiSharedUtilities.SduiRequestConcurrencyPolicy
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local HomeConstants = require(Home.HomeConstants)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiRefreshFeedItemIsOmissionExpected = SharedFlags.FFlagSduiRefreshFeedItemIsOmissionExpected

local v = {}
local count = 0

local HomePageFocusedFetchUtils = {}

local function getMountedInputData() -- 1 equivalent call inferred from this helper
	return getSduiApiStore().getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
end

local function isTargetMounted(feedItemKey: string): boolean -- 2 equivalent calls inferred from this helper
	local mountedInputData = getMountedInputData() -- inferred equivalent call
	return typeof(mountedInputData) == "table"
		and typeof(mountedInputData.entry_map) == "table"
		and mountedInputData.entry_map[feedItemKey] ~= nil
end

function HomePageFocusedFetchUtils.isCurrent(data)
	local sduiApiStore = getSduiApiStore()
	return v[data.options.feedItemKey] == data.requestId
		and sduiApiStore.getDataUpdatedTimestamp(HomeConstants.ConfigKey, false, HomeConstants.FeedEntryCacheKey) == data.capturedTimestamp
		and isTargetMounted(data.options.feedItemKey) -- inferred equivalent call
end

function HomePageFocusedFetchUtils.register(options)
	local dataUpdatedTimestamp = getSduiApiStore().getDataUpdatedTimestamp(
		HomeConstants.ConfigKey,
		false,
		HomeConstants.FeedEntryCacheKey
	)

	if dataUpdatedTimestamp == nil then
		return nil
	end

	if isTargetMounted(options.feedItemKey) then -- inferred equivalent call
		count += 1
		v[options.feedItemKey] = count
		return {
			options = options,
			requestId = count,
			capturedTimestamp = dataUpdatedTimestamp,
			foundTarget = false
		}
	end

	return nil
end

function HomePageFocusedFetchUtils:applyToRequestConfig(p)
	self.concurrencyKey = `{HomeConstants.ConfigKey}_{p.options.feedItemKey}`
	self.concurrencyPolicy = SduiRequestConcurrencyPolicy.LatestWins
	function self.isResponseCurrent()
		return HomePageFocusedFetchUtils.isCurrent(p)
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

		if list[2] ~= p.options.feedItemKey then
			return "preserve"
		end

		p.foundTarget = true
		return "replace"
	end
end

local function reportError(p, failedToFetchPage, p2: string) -- 1 equivalent call inferred from this helper
	p.options.reportError(failedToFetchPage, {
		name = HomeConstants.ApiName,
		message = `{p2}, topicIds: {p.options.topicId}`
	})
end

function HomePageFocusedFetchUtils.resolve(object, p)
	return object:andThen(function(): boolean
		if not HomePageFocusedFetchUtils.isCurrent(p) then
			return false
		end

		if p.foundTarget then
			return true
		end

		if not (FFlagSduiRefreshFeedItemIsOmissionExpected and p.options.isOmissionExpected) then
			local v2 = p
			local invalidFeedInResponse = SduiCoreSystem.SduiErrors.SduiErrorType.InvalidFeedInResponse
			v2.options.reportError(invalidFeedInResponse, {
				name = HomeConstants.ApiName,
				message = `Focused response omitted target, topicIds: {v2.options.topicId}`
			})
		end

		return false
	end, function(p2): boolean
		if HomePageFocusedFetchUtils.isCurrent(p) then
			reportError( -- inferred equivalent call
				p,
				SduiCoreSystem.SduiErrors.SduiErrorType.FailedToFetchPage,
				SduiCoreSystem.SduiParseHelpers.stringifyValue(p2)
			)
		end

		return false
	end)
end

return HomePageFocusedFetchUtils
