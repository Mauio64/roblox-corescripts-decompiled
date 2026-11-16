local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fpZ")
local module3 = require("@luauforge/bundled/fqa")
local performFetch = require("@luauforge/bundled/fqA").PerformFetch
local retrievalStatus = require("@luauforge/bundled/fqA").Enum.RetrievalStatus
local avatarScreen = require("@luauforge/bundled/fqt").Enums.AvatarScreen
local module4 = require("@luauforge/bundled/fqp")

local useNavigation = require("@luauforge/bundled/fqh").useNavigation
local useSelector = module2.Hooks.RoactRodux.useSelector
local module5 = require("@luauforge/bundled/fqy")
local module6 = require("@luauforge/bundled/fqB")

local module7 = require("@luauforge/bundled/fqC")
local findItemInTryOnItems = module3.Utils.findItemInTryOnItems

local module8 = require("@luauforge/bundled/fqG")
local axRecentlyViewedSearchItemsIXPTest = module3.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function fn(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function fn2(p2)
	return p2.AvatarExperience.Common
end

local function fn3(p2)
	local v5 = p2.AvatarExperience.Common.Widgets.ContextWidgetInfo[module5.RecentlyViewedItems]

	if v5 and v5.Details and v5.Details[module5.RecentlyViewedItems] then
		return v5.Details[module5.RecentlyViewedItems].content
	end

	return {}
end

local function useRecentlyViewedSearchItemsWidgetProps(data)
	local ref = React.useRef(HttpService:GenerateGUID(true))
	local v5 = useNavigation()

	local v6 = useSelector(function(p2)
		return performFetch.GetStatus(p2, ref.current)
	end)

	local v7 = useSelector(fn2)
	local v8 = useSelector(fn)

	local v9 = useSelector(fn3)

	local v10 = React.useMemo(function()
		return {
			isPositionTopVariant = module4.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledTopVariant) or false,
			isGlobalSaveVariant = module4.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog) or false
		}
	end, {})

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if data.catalogAnalytics and v10 and not ref2.current then
			data.catalogAnalytics.sendAXCounterV2(module6.RecentlyViewedEligibleUserEntered, {
				isPositionTopVariant = tostring(v10.isPositionTopVariant),
				isGlobalSaveVariant = tostring(v10.isGlobalSaveVariant)
			})

			ref2.current = true
		end
	end, { v10 })

	React.useEffect(function()
		local items = module7.getItems()

		if #items > 0 and v6 == retrievalStatus.NotStarted and data.fetchSearchRecentlyViewed then
			data.fetchSearchRecentlyViewed(ref.current, items)
		end
	end, { v6, v7, data.fetchSearchRecentlyViewed })

	local v11 = React.useCallback(function(p2, p3)
		if data.catalogAnalytics then
			data.catalogAnalytics.sendAXCounterV2(module6.RecentlyViewedCarouselItemSelected, {
				position = tostring(p3),
				itemType = p2.itemType,
				isPositionTopVariant = tostring(v10.isPositionTopVariant),
				isGlobalSaveVariant = tostring(v10.isGlobalSaveVariant)
			})
		end
	end, { data.catalogAnalytics, v10 })

	local v12 = React.useCallback(function(p2, p3)
		return function()
			v11(p2, p3)

			if data.toggleTryOn then
				local id = p2.id

				if not id or findItemInTryOnItems(v8, id) == nil then
					data.toggleTryOn(p2)
				end
			end

			v5.navigate(avatarScreen.SearchLandingFocusedWidgetPage, {
				widgetType = module5.RecentlyViewedItems
			})
		end
	end, { v5, data.toggleTryOn, v8, v11 })

	local v13 = React.useMemo(function()
		local clones = {}

		for k, v14 in v9 do
			if #clones >= module8() then
				break
			end

			local v15 = v7
			local id = v14.id
			local kind = v14.type
			local v16 = nil

			if kind == "Asset" then
				v16 = v15.AssetInfos[id]
			elseif kind == "Bundle" then
				v16 = v15.BundleInfos[id]
			end

			local clone = v16 and table.clone(v16)

			if not clone then
				continue
			end

			clone.itemType = v14.type
			clone.onActivated = v12(clone, k)
			table.insert(clones, clone)
		end

		return clones
	end, { v7, v12, v9 })

	React.useEffect(function()
		if v13 and #v13 > 0 then
			module4.logExperimentExposure(axRecentlyViewedSearchItemsIXPTest)
		end
	end, { v13 })

	return { items = v13, fetchStatus = v6 }
end

return useRecentlyViewedSearchItemsWidgetProps
