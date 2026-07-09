local HttpService = game:GetService("HttpService")
local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local RoactUtils = require(AvatarExperienceSearchParent.RoactUtils)
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local PerformFetch = require(AvatarExperienceSearchParent.Http).PerformFetch
local RetrievalStatus = require(AvatarExperienceSearchParent.Http).Enum.RetrievalStatus
local AvatarScreen = require(AvatarExperienceSearchParent.AvatarExperienceNavigation).Enums.AvatarScreen
local IxpUtils = require(AvatarExperienceSearchParent.IxpUtils)
local useNavigation = require(AvatarExperienceSearchParent.Navigation).useNavigation
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SearchLandingPageWidgetEnum = require(AvatarExperienceSearch.Enums.SearchLandingPageWidgetEnum)
local Counter = require(AvatarExperienceSearch.Enums.Counter)
local RecentlyViewedSearchItemsAppStorage = require(AvatarExperienceSearch.Utils.RecentlyViewedSearchItemsAppStorage)
local findItemInTryOnItems = AXCommon.Utils.findItemInTryOnItems
local GetFIntAXMaxRecentlyViewedSearchItemsInCarousel = require(AvatarExperienceSearch.Flags.GetFIntAXMaxRecentlyViewedSearchItemsInCarousel)
local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function v19(p1) -- line: 50
	return p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function v20(p2) -- line: 54
	return p2.AvatarExperience.Common
end
local function v21(p3) -- line: 76
	-- upvalues: SearchLandingPageWidgetEnum (copy)
	local v32 = p3.AvatarExperience.Common.Widgets.ContextWidgetInfo[SearchLandingPageWidgetEnum.RecentlyViewedItems]

	if v32 and (v32.Details and v32.Details[SearchLandingPageWidgetEnum.RecentlyViewedItems]) then
		return v32.Details[SearchLandingPageWidgetEnum.RecentlyViewedItems].content
	end

	return {}
end
local function useRecentlyViewedSearchItemsWidgetProps(t1: {[any]: any}) -- line: 86
	-- upvalues: React (copy), HttpService (copy), useNavigation (copy), useSelector (copy), PerformFetch (copy), v20 (copy), v19 (copy), v21 (copy), IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy), Counter (copy), RecentlyViewedSearchItemsAppStorage (copy), RetrievalStatus (copy), findItemInTryOnItems (copy), AvatarScreen (copy), SearchLandingPageWidgetEnum (copy), GetFIntAXMaxRecentlyViewedSearchItemsInCarousel (copy)
	local v34 = React.useRef(HttpService:GenerateGUID(true))
	local v35 = useNavigation()
	local v36 = useSelector(function(p4) -- line: 94
		-- upvalues: PerformFetch (copy), v34 (copy)
		return PerformFetch.GetStatus(p4, v34.current)
	end)
	local v37 = useSelector(v20)
	local v38 = useSelector(v19)
	local v39 = useSelector(v21)
	local v40 = React.useMemo(function() -- line: 103
		-- upvalues: IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy)
		return {
			isPositionTopVariant = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledTopVariant) or false,
			isGlobalSaveVariant = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog) or false
		}
	end, {})
	local v41 = React.useRef(false)

	React.useEffect(function() -- line: 114
		-- upvalues: t1 (copy), v40 (copy), v41 (copy), Counter (copy)
		if t1.catalogAnalytics and (v40 and not v41.current) then
			t1.catalogAnalytics.sendAXCounterV2(Counter.RecentlyViewedEligibleUserEntered, {
				isPositionTopVariant = tostring(v40.isPositionTopVariant),
				isGlobalSaveVariant = tostring(v40.isGlobalSaveVariant)
			})
			v41.current = true
		end
	end, { v40 })
	React.useEffect(function() -- line: 125
		-- upvalues: RecentlyViewedSearchItemsAppStorage (copy), v36 (copy), RetrievalStatus (copy), t1 (copy), v34 (copy)
		local v46 = RecentlyViewedSearchItemsAppStorage.getItems()

		if #v46 > 0 and (v36 == RetrievalStatus.NotStarted and t1.fetchSearchRecentlyViewed) then
			t1.fetchSearchRecentlyViewed(v34.current, v46)
		end
	end, {
		v36,
		v37,
		t1.fetchSearchRecentlyViewed
	})

	local v42 = React.useCallback(function(p5, p6) -- line: 132
		-- upvalues: t1 (copy), Counter (copy), v40 (copy)
		if t1.catalogAnalytics then
			t1.catalogAnalytics.sendAXCounterV2(Counter.RecentlyViewedCarouselItemSelected, {
				position = tostring(p6),
				itemType = p5.itemType,
				isPositionTopVariant = tostring(v40.isPositionTopVariant),
				isGlobalSaveVariant = tostring(v40.isGlobalSaveVariant)
			})
		end
	end, {
		t1.catalogAnalytics,
		v40
	})
	local v43 = React.useCallback(function(p7, p8) -- line: 144
		-- upvalues: v42 (copy), t1 (copy), v38 (copy), findItemInTryOnItems (copy), v35 (copy), AvatarScreen (copy), SearchLandingPageWidgetEnum (copy)
		return function() -- line: 145
			-- upvalues: v42 (copy), p7 (copy), p8 (copy), t1 (copy), v38 (copy), findItemInTryOnItems (copy), v35 (copy), AvatarScreen (copy), SearchLandingPageWidgetEnum (copy)
			v42(p7, p8)

			if t1.toggleTryOn then
				local v58 = v38
				local id = p7.id

				if not id or findItemInTryOnItems(v58, id) == nil then
					t1.toggleTryOn(p7)
				end
			end

			v35.navigate(AvatarScreen.SearchLandingFocusedWidgetPage, {
				widgetType = SearchLandingPageWidgetEnum.RecentlyViewedItems
			})
		end
	end, {
		v35,
		t1.toggleTryOn,
		v38,
		v42
	})
	local v44 = React.useMemo(function() -- line: 156
		-- upvalues: v39 (copy), GetFIntAXMaxRecentlyViewedSearchItemsInCarousel (copy), v37 (copy), v43 (copy)
		local t2 = {}

		for v52, v53 in v39 do
			if #t2 >= GetFIntAXMaxRecentlyViewedSearchItemsInCarousel() then
				return t2
			end

			local v54 = v37
			local id = v53.id
			local type = v53.type
			local v57 = nil

			if type == "Asset" then
				v57 = v54.AssetInfos[id]
			elseif type == "Bundle" then
				v57 = v54.BundleInfos[id]
			end

			if v57 then
				v57 = table.clone(v57)
			end

			if v57 then
				v57.itemType = v53.type
				v57.onActivated = v43(v57, v52)
				table.insert(t2, v57)
			end
		end

		return t2
	end, {
		v37,
		v43,
		v39
	})

	React.useEffect(function() -- line: 175
		-- upvalues: v44 (copy), IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy)
		if v44 and #v44 > 0 then
			IxpUtils.logExperimentExposure(AXRecentlyViewedSearchItemsIXPTest)
		end
	end, { v44 })

	return {
		items = v44,
		fetchStatus = v36
	}
end

return useRecentlyViewedSearchItemsWidgetProps
