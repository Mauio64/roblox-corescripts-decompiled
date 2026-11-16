local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")

local AddSduiRootConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/AddSduiRootConfig")
local RemoveSduiRootConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/RemoveSduiRootConfig")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local getItemCollectionKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getItemCollectionKey")

return {
	key = "SduiConfigKey",
	reducer = function(options, data)
		local v5 = options or {}
		assert(v5, "state must exist")

		ArgCheck.assert(typeof(v5) == "table", "state must be a table")

		if data.type == AddSduiRootConfig.name then
			local customFeedStoreKey = data.customFeedStoreKey or data.page

			local v6 = v5[customFeedStoreKey]
			local itemCollections = v6 and v6.itemCollections or {}
			local v7 = {
				rootConfig = data.rootConfig,
				dataUpdatedTimestamp = data.dataUpdatedTimestamp,
				itemCollections = itemCollections
			}

			local feed = data.rootConfig.feed or data.rootConfig or nil

			if typeof(feed) ~= "table" then
				sduiLogger.reportError(
					sduiErrors.SduiErrorType.InvalidFeedInResponse,
					{
						message = `Invalid sdui.feed in response of type {typeof(feed)}`
					},
					data.page
				)
				return v5
			end

			local feedItems = feed.props and feed.props.feedItems or nil

			if feedItems then
				for k, feedItem in feedItems do
					local feedItemKey = feedItem.feedItemKey

					if feedItemKey then
						if v7.itemCollections[feedItemKey] ~= nil then
							sduiLogger.reportError(
								sduiErrors.SduiErrorType.DuplicateFeedItemKey,
								{
									message = `Multiple item collections with same feedItemKey {feedItemKey}`
								},
								data.page
							)
						end

						if data.expectedSduiFeedItems then
							local topicId = nil
							local sortIndex = nil

							for k2, expectedSduiFeedItem in data.expectedSduiFeedItems do
								if expectedSduiFeedItem.feedItemKey == feedItemKey then
									topicId = expectedSduiFeedItem.topicId
									sortIndex = expectedSduiFeedItem.sortIndex
									break
								end
							end

							if topicId == nil or sortIndex == nil then
								sduiLogger.reportError(
									sduiErrors.SduiErrorType.FailedToFindCollectionId,
									{
										message = `Missing topicId or sortIndex for {feedItemKey} in ConfigReducer. sortIndex = {sortIndex} topicId = {topicId}`
									},
									data.page
								)
							end

							local v9 = getItemCollectionKey(topicId, sortIndex)
							v7.itemCollections[v9] = {
								sduiConfig = feedItem,
								dataUpdatedTimestamp = data.dataUpdatedTimestamp,
								topicId = topicId,
								sortIndex = sortIndex
							}
						else
							v7.itemCollections[feedItemKey] = {
								sduiConfig = feedItem,
								dataUpdatedTimestamp = data.dataUpdatedTimestamp
							}
						end
					else
						sduiLogger.reportError(
							sduiErrors.SduiErrorType.NilFeedItemKey,
							{
								message = "Missing feedItemKey for itemCollection in ConfigReducer"
							},
							data.page
						)
					end
				end
			end

			if data.expectedSduiFeedItems then
				for k, expectedSduiFeedItem in data.expectedSduiFeedItems do
					local v8 = getItemCollectionKey(expectedSduiFeedItem.topicId, expectedSduiFeedItem.sortIndex)

					if v7.itemCollections[v8] == nil then
						sduiLogger.reportError(
							sduiErrors.SduiErrorType.NilItemCollection,
							{
								message = `Missing item collection data for an sdui feed item for topic: {expectedSduiFeedItem.topicId} sortIndex: {expectedSduiFeedItem.sortIndex}`,
								name = expectedSduiFeedItem.topicId
							},
							data.page
						)
					end
				end
			end

			return (Cryo.Dictionary.union(v5, { [customFeedStoreKey] = v7 }))
		end

		if data.type == RemoveSduiRootConfig.name then
			local feedStoreKey = data.feedStoreKey

			if v5[feedStoreKey] then
				v5 = Cryo.Dictionary.omit(v5, feedStoreKey)
			end
		end

		return v5
	end
}
