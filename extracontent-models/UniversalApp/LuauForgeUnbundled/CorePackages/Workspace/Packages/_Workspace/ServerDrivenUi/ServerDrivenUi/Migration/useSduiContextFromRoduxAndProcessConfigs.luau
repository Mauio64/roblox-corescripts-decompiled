local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/tutils")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SduiConfigReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/SduiConfigReducer")
local useSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/useSduiContext")
local getSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getSduiFeedStore")
local processCollectionConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/processCollectionConfig")
local getItemCollectionKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getItemCollectionKey")

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppLayoutParamsInContext

local fFlagLuaAppUseEffectInSignalPreprocessing = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppUseEffectInSignalPreprocessing

local function useSduiContextFromRoduxAndProcessConfigs(p2, pageLayoutConfig, p3)
	local v5 = p3 or p2

	local v6 = useSelector(function(p4)
		local v7 = {}
		local v8 = p4.Personalization[SduiConfigReducer.key][v5]

		if not v8 then
			return v7
		end

		local v9 = if v8.rootConfig then v8.rootConfig.templates or nil else nil
		v7.templates = v9
		v7.dataUpdatedTimestamp = v8.dataUpdatedTimestamp
		v7.itemCollections = v8.itemCollections

		return v7
	end, tutils.shallowEqual)

	local v8 = {
		appPage = p2,
		templates = v6.templates,
		dataUpdatedTimestamp = v6.dataUpdatedTimestamp,
		pageLayoutConfig = 0
	}

	if not fFlagLuaAppLayoutParamsInContext then
		pageLayoutConfig = nil
	end

	v8.pageLayoutConfig = pageLayoutConfig
	local v9 = useSduiContext(v8)
	local v10

	if fFlagLuaAppUseEffectInSignalPreprocessing then
		v10 = React.useEffect
	else
		v10 = React.useLayoutEffect
	end

	v10(function()
		local v11 = getSduiFeedStore(v5)
		local v12 = {}

		if v6.itemCollections then
			for k, itemCollection in v6.itemCollections do
				v12[getItemCollectionKey(itemCollection.topicId, itemCollection.sortIndex)] = {
					sduiConfig = processCollectionConfig(itemCollection.sduiConfig, itemCollection.topicId, v9),
					dataUpdatedTimestamp = itemCollection.dataUpdatedTimestamp
				}
			end

			v11.updateData({
				templates = v6.templates,
				itemCollections = v12,
				dataUpdatedTimestamp = v6.dataUpdatedTimestamp
			})
		end

		return function() end
	end, { v9, v6.itemCollections, v6.templates, v6.dataUpdatedTimestamp, v5 })

	return v9
end

return useSduiContextFromRoduxAndProcessConfigs
