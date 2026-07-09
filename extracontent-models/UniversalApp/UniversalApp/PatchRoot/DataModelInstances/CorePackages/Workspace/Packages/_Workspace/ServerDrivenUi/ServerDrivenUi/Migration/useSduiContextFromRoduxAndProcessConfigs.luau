local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local tutils = require(ServerDrivenUiParent.tutils)
local RoactUtils = require(ServerDrivenUiParent.RoactUtils)

require(ServerDrivenUiParent.CollectionViews)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SduiConfigReducer = require(ServerDrivenUi.Rodux.SduiConfigReducer)
local useSduiContext = require(ServerDrivenUi.System.useSduiContext)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local processCollectionConfig = require(ServerDrivenUi.System.processCollectionConfig)
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

require(ServerDrivenUiParent.SduiCoreSystem)

local FFlagLuaAppLayoutParamsInContext = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppUseEffectInSignalPreprocessing = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppUseEffectInSignalPreprocessing

local function useSduiContextFromRoduxAndProcessConfigs(s1: string, p1, s2: string?) -- line: 30
	-- upvalues: useSelector (copy), SduiConfigReducer (copy), tutils (copy), useSduiContext (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagLuaAppUseEffectInSignalPreprocessing (copy), React (copy), getSduiFeedStore (copy), getItemCollectionKey (copy), processCollectionConfig (copy)
	local v18 = s2 or s1
	local v19 = useSelector(function(p2) -- line: 37
		-- upvalues: SduiConfigReducer (copy), v18 (copy)
		local t1 = {}
		local v23 = p2.Personalization[SduiConfigReducer.key][v18]

		if v23 then
			t1.templates = v23.rootConfig and v23.rootConfig.templates or nil
			t1.dataUpdatedTimestamp = v23.dataUpdatedTimestamp
			t1.itemCollections = v23.itemCollections
		end

		return t1
	end, tutils.shallowEqual)
	local v20 = useSduiContext({
		appPage = s1,
		templates = v19.templates,
		dataUpdatedTimestamp = v19.dataUpdatedTimestamp,
		pageLayoutConfig = if not FFlagLuaAppLayoutParamsInContext then nil else p1
	});

	((if not FFlagLuaAppUseEffectInSignalPreprocessing then React.useLayoutEffect else React.useEffect))(function() -- line: 59
		-- upvalues: getSduiFeedStore (copy), v18 (copy), v19 (copy), getItemCollectionKey (copy), processCollectionConfig (copy), v20 (copy)
		local v24 = getSduiFeedStore(v18)
		local t2 = {}

		if v19.itemCollections then
			for _, v27 in v19.itemCollections do
				t2[getItemCollectionKey(v27.topicId, v27.sortIndex)] = {
					sduiConfig = processCollectionConfig(v27.sduiConfig, v27.topicId, v20),
					dataUpdatedTimestamp = v27.dataUpdatedTimestamp
				}
			end

			v24.updateData({
				templates = v19.templates,
				itemCollections = t2,
				dataUpdatedTimestamp = v19.dataUpdatedTimestamp
			})
		end

		return function() -- line: 77
		end
	end, {
		v20,
		v19.itemCollections,
		v19.templates,
		v19.dataUpdatedTimestamp,
		v18
	})

	return v20
end

return useSduiContextFromRoduxAndProcessConfigs
