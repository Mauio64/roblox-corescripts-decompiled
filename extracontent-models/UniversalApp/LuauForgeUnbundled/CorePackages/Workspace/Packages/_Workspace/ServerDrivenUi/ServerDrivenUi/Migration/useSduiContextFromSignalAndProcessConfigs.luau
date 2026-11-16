local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local useSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/useSduiContext")
local getSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getSduiFeedStore")
local processCollectionConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/processCollectionConfig")
local getItemCollectionKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getItemCollectionKey")

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local function useSduiContextFromSignalAndProcessConfigs(p2, p3, p4)
	local v5 = React.useMemo(function()
		return function(p5)
			if not p4 then
				return {}
			end

			local v6 = getSduiFeedStore(p2)
			local templates = v6.getTemplates(p5)
			local dataUpdatedTimestamp = v6.getDataUpdatedTimestamp(p5)

			local v7 = {}

			for k, v8 in not v6.getItemCollectionKeys and {} or v6.getItemCollectionKeys(p5) do
				local itemCollection = v6.getItemCollection(v8)

				if itemCollection then
					v7[v8] = itemCollection(p5)
				end
			end

			return {
				templates = templates,
				dataUpdatedTimestamp = dataUpdatedTimestamp,
				unprocessedItemCollections = v7
			}
		end
	end, { p2, p4 })

	local v6 = SignalsReact.useSignalState(v5)

	local v7 = useSduiContext({
		appPage = p3,
		templates = v6.templates,
		dataUpdatedTimestamp = v6.dataUpdatedTimestamp
	})

	React.useEffect(function()
		if not p4 then
			return
		end

		local v8 = getSduiFeedStore(p3)
		local v9 = {}

		if v6.unprocessedItemCollections then
			for k, unprocessedItemCollection in v6.unprocessedItemCollections do
				v9[getItemCollectionKey(unprocessedItemCollection.topicId, unprocessedItemCollection.sortIndex)] = {
					sduiConfig = processCollectionConfig(
						unprocessedItemCollection.componentConfig,
						unprocessedItemCollection.topicId,
						v7
					),
					dataUpdatedTimestamp = v6.dataUpdatedTimestamp
				}
			end

			v8.updateData({
				templates = v6.templates,
				itemCollections = v9,
				dataUpdatedTimestamp = v6.dataUpdatedTimestamp
			})
		end
	end, {
		v7,
		v6.unprocessedItemCollections,
		v6.templates,
		v6.dataUpdatedTimestamp,
		p3,
		p4
	})

	return v7
end

return useSduiContextFromSignalAndProcessConfigs
