local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local ArgCheck = require(ServerDrivenUiParent.ArgCheck)
local Cryo = require(ServerDrivenUiParent.Cryo)
local AddSduiRootConfig = require(ServerDrivenUi.Rodux.AddSduiRootConfig)
local RemoveSduiRootConfig = require(ServerDrivenUi.Rodux.RemoveSduiRootConfig)
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

return {
	key = "SduiConfigKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 30
		-- upvalues: ArgCheck (copy), AddSduiRootConfig (copy), SduiLogger (copy), SduiErrors (copy), getItemCollectionKey (copy), Cryo (copy), RemoveSduiRootConfig (copy)
		local v13 = t1 or {}

		assert(v13, "state must exist")
		ArgCheck.assert(typeof(v13) == "table", "state must be a table")

		if p1.type == AddSduiRootConfig.name then
			local v14 = p1.customFeedStoreKey or p1.page
			local v15 = v13[v14]
			local v16 = v15 and v15.itemCollections or {}
			local t2 = {
				rootConfig = p1.rootConfig,
				dataUpdatedTimestamp = p1.dataUpdatedTimestamp,
				itemCollections = v16
			}
			local v18 = p1.rootConfig.feed or (p1.rootConfig or nil)

			if typeof(v18) ~= "table" then
				SduiLogger.reportError(SduiErrors.SduiErrorType.InvalidFeedInResponse, {
					message = `Invalid sdui.feed in response of type { typeof(v18) }`
				}, p1.page)

				return v13
			end

			local v19 = v18.props and v18.props.feedItems or nil

			if v19 then
				for _, v21 in v19 do
					local feedItemKey = v21.feedItemKey

					if feedItemKey then
						if t2.itemCollections[feedItemKey] ~= nil then
							SduiLogger.reportError(SduiErrors.SduiErrorType.DuplicateFeedItemKey, {
								message = `Multiple item collections with same feedItemKey { feedItemKey }`
							}, p1.page)
						end

						if p1.expectedSduiFeedItems then
							local topicId = nil
							local sortIndex = nil

							for _, v26 in p1.expectedSduiFeedItems do
								if feedItemKey == v26.feedItemKey then
									topicId = v26.topicId
									sortIndex = v26.sortIndex

									break
								end
							end

							if topicId == nil or sortIndex == nil then
								SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFindCollectionId, {
									message = `Missing topicId or sortIndex for { feedItemKey } in ConfigReducer. sortIndex = { sortIndex } topicId = { topicId }`
								}, p1.page)
							end

							local v27 = getItemCollectionKey(topicId, sortIndex)

							t2.itemCollections[v27] = {
								sduiConfig = v21,
								dataUpdatedTimestamp = p1.dataUpdatedTimestamp,
								topicId = topicId,
								sortIndex = sortIndex
							}
						else
							t2.itemCollections[feedItemKey] = {
								sduiConfig = v21,
								dataUpdatedTimestamp = p1.dataUpdatedTimestamp
							}
						end
					else
						SduiLogger.reportError(SduiErrors.SduiErrorType.NilFeedItemKey, {
							message = "Missing feedItemKey for itemCollection in ConfigReducer"
						}, p1.page)
					end
				end
			end

			if p1.expectedSduiFeedItems then
				for _, v29 in p1.expectedSduiFeedItems do
					local v30 = getItemCollectionKey(v29.topicId, v29.sortIndex)

					if t2.itemCollections[v30] == nil then
						SduiLogger.reportError(SduiErrors.SduiErrorType.NilItemCollection, {
							message = `Missing item collection data for an sdui feed item for topic: { v29.topicId } sortIndex: { v29.sortIndex }`,
							name = v29.topicId
						}, p1.page)
					end
				end
			end

			return (Cryo.Dictionary.union(v13, {
				[v14] = t2
			}))
		end

		if p1.type == RemoveSduiRootConfig.name then
			local feedStoreKey = p1.feedStoreKey

			if v13[feedStoreKey] then
				v13 = Cryo.Dictionary.omit(v13, feedStoreKey)
			end
		end

		return v13
	end
}
