local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local tutils = require(parent.tutils)
local RoactUtils = require(parent.RoactUtils)
require(parent.CollectionViews)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SduiConfigReducer = require(ServerDrivenUi.Rodux.SduiConfigReducer)
local useSduiContext = require(ServerDrivenUi.System.useSduiContext)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local processCollectionConfig = require(ServerDrivenUi.System.processCollectionConfig)
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

require(parent.SduiCoreSystem)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppUseEffectInSignalPreprocessing = SharedFlags2.FFlagLuaAppUseEffectInSignalPreprocessing

local function useSduiContextFromRoduxAndProcessConfigs(appPage: string, pageLayoutConfig, p: string?)
	local v = p or appPage

	local v2 = useSelector(function(p2)
		local v2 = {}
		local v3 = p2.Personalization[SduiConfigReducer.key][v]

		if not v3 then
			return v2
		end

		local templates

		if v3.rootConfig then
			templates = v3.rootConfig.templates or nil
		end

		v2.templates = templates
		v2.dataUpdatedTimestamp = v3.dataUpdatedTimestamp
		v2.itemCollections = v3.itemCollections

		return v2
	end, tutils.shallowEqual)

	local v3 = {
		appPage = appPage,
		templates = v2.templates,
		dataUpdatedTimestamp = v2.dataUpdatedTimestamp,
		pageLayoutConfig = 0
	}

	if not FFlagLuaAppLayoutParamsInContext then
		pageLayoutConfig = nil
	end

	v3.pageLayoutConfig = pageLayoutConfig
	local v4 = useSduiContext(v3)
	local v5

	if FFlagLuaAppUseEffectInSignalPreprocessing then
		v5 = React.useEffect
	else
		v5 = React.useLayoutEffect
	end

	v5(function()
		local sduiFeedStore = getSduiFeedStore(v)
		local itemCollections = {}

		if v2.itemCollections then
			for _, itemCollection in v2.itemCollections do
				itemCollections[getItemCollectionKey(itemCollection.topicId, itemCollection.sortIndex)] = {
					sduiConfig = processCollectionConfig(itemCollection.sduiConfig, itemCollection.topicId, v4),
					dataUpdatedTimestamp = itemCollection.dataUpdatedTimestamp
				}
			end

			sduiFeedStore.updateData({
				templates = v2.templates,
				itemCollections = itemCollections,
				dataUpdatedTimestamp = v2.dataUpdatedTimestamp
			})
		end

		return function() end
	end, { v4, v2.itemCollections, v2.templates, v2.dataUpdatedTimestamp, v })

	return v4
end

return useSduiContextFromRoduxAndProcessConfigs
