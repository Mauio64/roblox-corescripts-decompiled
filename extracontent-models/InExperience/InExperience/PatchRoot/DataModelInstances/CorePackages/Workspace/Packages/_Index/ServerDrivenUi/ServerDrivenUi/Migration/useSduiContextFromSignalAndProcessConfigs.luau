local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local useSduiContext = require(ServerDrivenUi.System.useSduiContext)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local processCollectionConfig = require(ServerDrivenUi.System.processCollectionConfig)
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

require(ServerDrivenUiParent.SduiCoreSystem)

local FFlagSduiGetItemCollectionKeys = require(ServerDrivenUi.Flags).FFlagSduiGetItemCollectionKeys

local function useSduiContextFromSignalAndProcessConfigs(s1: string, s2: string, b1: boolean?) -- line: 23
	-- upvalues: React (copy), getSduiFeedStore (copy), FFlagSduiGetItemCollectionKeys (copy), SignalsReact (copy), useSduiContext (copy), getItemCollectionKey (copy), processCollectionConfig (copy)
	local v14 = React.useMemo(function() -- line: 28
		-- upvalues: b1 (copy), getSduiFeedStore (copy), s1 (copy), FFlagSduiGetItemCollectionKeys (copy)
		return function(p1) -- line: 29
			-- upvalues: b1 (copy), getSduiFeedStore (copy), s1 (copy), FFlagSduiGetItemCollectionKeys (copy)
			if not b1 then
				return {}
			end

			local v22 = getSduiFeedStore(s1)
			local v23 = v22.getTemplates(p1)
			local v24 = v22.getDataUpdatedTimestamp(p1)
			local t1 = {}

			for _, v27 in if not FFlagSduiGetItemCollectionKeys or not v22.getItemCollectionKeys then {} else v22.getItemCollectionKeys(p1) do
				local v28 = v22.getItemCollection(v27)

				if v28 then
					t1[v27] = v28(p1)
				end
			end

			return {
				templates = v23,
				dataUpdatedTimestamp = v24,
				unprocessedItemCollections = t1
			}
		end
	end, {
		s1,
		b1
	})
	local v15 = SignalsReact.useSignalState(v14)
	local v16 = useSduiContext({
		appPage = s2,
		templates = v15.templates,
		dataUpdatedTimestamp = v15.dataUpdatedTimestamp
	})

	React.useEffect(function() -- line: 66
		-- upvalues: b1 (copy), getSduiFeedStore (copy), s2 (copy), v15 (copy), getItemCollectionKey (copy), processCollectionConfig (copy), v16 (copy)
		if not b1 then
			return
		end

		local v17 = getSduiFeedStore(s2)
		local t2 = {}

		if v15.unprocessedItemCollections then
			for _, v20 in v15.unprocessedItemCollections do
				t2[getItemCollectionKey(v20.topicId, v20.sortIndex)] = {
					sduiConfig = processCollectionConfig(v20.componentConfig, v20.topicId, v16),
					dataUpdatedTimestamp = v15.dataUpdatedTimestamp
				}
			end

			v17.updateData({
				templates = v15.templates,
				itemCollections = t2,
				dataUpdatedTimestamp = v15.dataUpdatedTimestamp
			})
		end
	end, {
		v16,
		v15.unprocessedItemCollections,
		v15.templates,
		v15.dataUpdatedTimestamp,
		s2,
		b1
	})

	return v16
end

return useSduiContextFromSignalAndProcessConfigs
