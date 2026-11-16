local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)

local AddSduiRootConfig = require(ServerDrivenUi.Rodux.AddSduiRootConfig)
local RemoveSduiRootConfig = require(ServerDrivenUi.Rodux.RemoveSduiRootConfig)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

return {
	key = "SduiConfigKey",
	reducer = function(options, data)
		options = options or {}
		assert(options, "state must exist")

		ArgCheck.assert(typeof(options) == "table", "state must be a table")

		if data.type == AddSduiRootConfig.name then
			local customFeedStoreKey = data.customFeedStoreKey or data.page

			local option = options[customFeedStoreKey]
			local itemCollections = option and option.itemCollections or {}
			local v = {
				rootConfig = data.rootConfig,
				dataUpdatedTimestamp = data.dataUpdatedTimestamp,
				itemCollections = itemCollections
			}

			local feed = data.rootConfig.feed or data.rootConfig or nil

			if typeof(feed) ~= "table" then
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.InvalidFeedInResponse,
					{
						message = `Invalid sdui.feed in response of type {typeof(feed)}`
					},
					data.page
				)
				return options
			end

			local feedItems = feed.props and feed.props.feedItems or nil

			if feedItems then
				for _, feedItem in feedItems do
					local feedItemKey = feedItem.feedItemKey

					if feedItemKey then
						if v.itemCollections[feedItemKey] ~= nil then
							SduiLogger.reportError(
								SduiErrors.SduiErrorType.DuplicateFeedItemKey,
								{
									message = `Multiple item collections with same feedItemKey {feedItemKey}`
								},
								data.page
							)
						end

						if data.expectedSduiFeedItems then
							local topicId = nil
							local sortIndex = nil

							for _, expectedSduiFeedItem in data.expectedSduiFeedItems do
								if expectedSduiFeedItem.feedItemKey == feedItemKey then
									topicId = expectedSduiFeedItem.topicId
									sortIndex = expectedSduiFeedItem.sortIndex
									break
								end
							end

							if topicId == nil or sortIndex == nil then
								SduiLogger.reportError(
									SduiErrors.SduiErrorType.FailedToFindCollectionId,
									{
										message = `Missing topicId or sortIndex for {feedItemKey} in ConfigReducer. sortIndex = {sortIndex} topicId = {topicId}`
									},
									data.page
								)
							end

							local itemCollectionKey = getItemCollectionKey(topicId, sortIndex)
							v.itemCollections[itemCollectionKey] = {
								sduiConfig = feedItem,
								dataUpdatedTimestamp = data.dataUpdatedTimestamp,
								topicId = topicId,
								sortIndex = sortIndex
							}
						else
							v.itemCollections[feedItemKey] = {
								sduiConfig = feedItem,
								dataUpdatedTimestamp = data.dataUpdatedTimestamp
							}
						end
					else
						SduiLogger.reportError(
							SduiErrors.SduiErrorType.NilFeedItemKey,
							{ message = "Missing feedItemKey for itemCollection in ConfigReducer" },
							data.page
						)
					end
				end
			end

			if data.expectedSduiFeedItems then
				for _, expectedSduiFeedItem in data.expectedSduiFeedItems do
					local itemCollectionKey = getItemCollectionKey(
						expectedSduiFeedItem.topicId,
						expectedSduiFeedItem.sortIndex
					)

					if v.itemCollections[itemCollectionKey] == nil then
						SduiLogger.reportError(
							SduiErrors.SduiErrorType.NilItemCollection,
							{
								message = `Missing item collection data for an sdui feed item for topic: {expectedSduiFeedItem.topicId} sortIndex: {expectedSduiFeedItem.sortIndex}`,
								name = expectedSduiFeedItem.topicId
							},
							data.page
						)
					end
				end
			end

			return (Cryo.Dictionary.union(options, { [customFeedStoreKey] = v }))
		end

		if data.type == RemoveSduiRootConfig.name then
			local feedStoreKey = data.feedStoreKey

			if options[feedStoreKey] then
				options = Cryo.Dictionary.omit(options, feedStoreKey)
			end
		end

		return options
	end
}
