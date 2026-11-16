local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useSduiContext = require(ServerDrivenUi.System.useSduiContext)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local processCollectionConfig = require(ServerDrivenUi.System.processCollectionConfig)
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

require(parent.SduiCoreSystem)

local function useSduiContextFromSignalAndProcessConfigs(p: string, appPage: string, flag: boolean?)
	local v = React.useMemo(function()
		return function(p2)
			if not flag then
				return {}
			end

			local sduiFeedStore = getSduiFeedStore(p)
			local templates = sduiFeedStore.getTemplates(p2)
			local dataUpdatedTimestamp = sduiFeedStore.getDataUpdatedTimestamp(p2)

			local unprocessedItemCollections = {}

			for _, v in not sduiFeedStore.getItemCollectionKeys and {} or sduiFeedStore.getItemCollectionKeys(p2) do
				local itemCollection = sduiFeedStore.getItemCollection(v)

				if itemCollection then
					unprocessedItemCollections[v] = itemCollection(p2)
				end
			end

			return {
				templates = templates,
				dataUpdatedTimestamp = dataUpdatedTimestamp,
				unprocessedItemCollections = unprocessedItemCollections
			}
		end
	end, { p, flag })

	local v2 = SignalsReact.useSignalState(v)

	local v3 = useSduiContext({
		appPage = appPage,
		templates = v2.templates,
		dataUpdatedTimestamp = v2.dataUpdatedTimestamp
	})

	React.useEffect(function()
		if not flag then
			return
		end

		local sduiFeedStore = getSduiFeedStore(appPage)
		local itemCollections = {}

		if v2.unprocessedItemCollections then
			for _, unprocessedItemCollection in v2.unprocessedItemCollections do
				itemCollections[getItemCollectionKey(
					unprocessedItemCollection.topicId,
					unprocessedItemCollection.sortIndex
				)] = {
					sduiConfig = processCollectionConfig(
						unprocessedItemCollection.componentConfig,
						unprocessedItemCollection.topicId,
						v3
					),
					dataUpdatedTimestamp = v2.dataUpdatedTimestamp
				}
			end

			sduiFeedStore.updateData({
				templates = v2.templates,
				itemCollections = itemCollections,
				dataUpdatedTimestamp = v2.dataUpdatedTimestamp
			})
		end
	end, { v3, v2.unprocessedItemCollections, v2.templates, v2.dataUpdatedTimestamp, appPage, flag })

	return v3
end

return useSduiContextFromSignalAndProcessConfigs
