local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator

require(parent.SduiCoreSystem)

return makeActionCreator(
	script.Name,
	function(page: string, rootConfig, dataUpdatedTimestamp: number, expectedSduiFeedItems, customFeedStoreKey: string?)
		return {
			page = page,
			rootConfig = rootConfig,
			dataUpdatedTimestamp = dataUpdatedTimestamp,
			expectedSduiFeedItems = expectedSduiFeedItems,
			customFeedStoreKey = customFeedStoreKey
		}
	end
)
