local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require(CorePackages.Packages.LuauPolyfill)

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local GetRecommendedAssets = require(Modules.AvatarExperience.Catalog.Thunks.GetRecommendedAssets)
local GetRecommendedBundles = require(Modules.AvatarExperience.Catalog.Thunks.GetRecommendedBundles)
local BaseItemCard = require(Modules.AvatarExperience.Catalog.Components.ItemsList.BaseItemCard)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local NavigateDownToAvatarScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.NavigateDownToAvatarScreen)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local SendDetailedCatalogAnalytics = require(Modules.AvatarExperience.Catalog.Thunks.SendDetailedCatalogAnalytics)
local MaybePromptForR15Upgrade = require(Modules.AvatarExperience.Catalog.Thunks.MaybePromptForR15Upgrade)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local GetFFlagAXHideRecommendationsOnFetchFailure = require(Modules.AvatarExperience.Flags.GetFFlagAXHideRecommendationsOnFetchFailure)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local FFlagAXMigrateRecommendedItemsGridToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateRecommendedItemsGridToFocusNavigation
local FFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local v43 = Roact.PureComponent:extend("RecommendedItemsGrid")

v43.validateProps = t.strictInterface({
	itemId = t.string,
	itemType = t.string,
	itemSubType = t.optional(t.string),
	LayoutOrder = t.optional(t.integer),
	hideItemTitle = t.optional(t.boolean),
	getItemMetrics = t.optional(t.callback),
	onActivatedMountAsFullView = t.optional(t.boolean),
	onFetchRecommendationsFailed = if not GetFFlagAXHideRecommendationsOnFetchFailure() then nil else t.optional(t.callback),
	focusNavigationRef = if not FFlagAXMigrateRecommendedItemsGridToFocusNavigation then nil else t.union(t.callback, t.table),
	recommendedItemSummaries = t.optional(t.array(t.strictInterface({
		id = t.string,
		type = t.string,
		subType = t.string,
		gridInformation = t.optional(t.table)
	}))),
	resultsListRef = t.optional(t.table),
	forwardRef = t.optional(t.table),
	itemDetailsPeekViewRefs = t.optional(t.table),
	getRecommendedAssets = t.callback,
	getRecommendedBundles = t.callback,
	sendDetailedCatalogAnalytics = t.callback,
	maybePromptForR15Upgrade = t.callback,
	navigateDownToAvatarScreen = t.callback,
	navigation = t.table,
	analytics = t.table
})
v43.defaultProps = {
	itemType = Constants.ItemType.Asset
}

local t1 = {
	[Enum.KeyCode.ButtonR2] = FocusNavigationEventNameEnum.MoveToActionBar
}

local function useRecommendedItemsGridFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 114
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v51 = ReactFocusNavigation.useEventMap(t1, p1)
	local v52 = React.useMemo(function() -- line: 116
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.MoveToActionBar] = {
				handler = InputHandlers.onRelease(function(_) -- line: 119
					-- upvalues: p2 (copy)
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v52, v51)
end

function v43.init(p4) -- line: 128
	-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagAXFixPurchaseSurfaceLogging (copy), Constants (copy), FFlagAXTryOnScreenImprovements (copy), AvatarScreen (copy), CatalogConstants (copy), Roact (copy), BaseItemCard (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), FFlagAXItemDetailsIxpExposure (copy)
	function p4.selectRecommendedItem(p5, p6, _) -- line: 129
		-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), p4 (copy)
		local id = p5.id
		local type = p5.type
		local subType = p5.subType

		if p4.props.maybePromptForR15Upgrade(p4.props.navigation, id, type, function() -- line: 134
			-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy)
			local v126 = wasLastInputGamepad()

			logOnOverlayClosed("RecommendedItemsGrid", v126)
		end, function() -- line: 140
			-- upvalues: p4 (copy), id (copy), type (copy), subType (copy), p6 (copy)
			p4.navigateToRecommendedItem(id, type, subType, p6)
		end) then
			return
		end

		p4.navigateToRecommendedItem(id, type, subType, p6)
	end
	function p4.navigateToRecommendedItem(p8, p9, p10, p11) -- line: 161
		-- upvalues: p4 (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagAXFixPurchaseSurfaceLogging (copy), Constants (copy), FFlagAXTryOnScreenImprovements (copy), AvatarScreen (copy), CatalogConstants (copy)
		if not p8 or (not p9 or not p10) then
			return
		end

		local v82 = p4.props.onActivatedMountAsFullView == nil or p4.props.onActivatedMountAsFullView
		local v83 = p4.props.navigation.getParam("fromProfile")
		local v84 = if not FFlagAXEnableHomeTryOnComplexView then nil else p4.props.navigation.getParam("fromHome")
		local v85 = p4.props.navigation.getParam("showFullWithNoPeekView")
		local t2 = {
			mountAnimation = false,
			isFirstItemDetails = false,
			itemId = p8,
			itemType = p9,
			itemSubType = p10,
			mountAsFullView = v82,
			itemDetailsPeekViewRefs = p4.props.itemDetailsPeekViewRefs,
			resultsListRef = p4.props.resultsListRef,
			fromProfile = v83,
			showFullWithNoPeekView = v85,
			fromSurface = if not FFlagAXFixPurchaseSurfaceLogging or not p4.props.navigation then nil else p4.props.navigation.getParam(Constants.NavigationParams.fromSurface)
		}

		if FFlagAXTryOnScreenImprovements then
			if v83 then
				t2.mountAnimation = false
				t2.isFirstItemDetails = false

				local v87 = p9 .. p8

				p4.props.navigateDownToAvatarScreen(AvatarScreen.ItemDetails, v87, t2)
			elseif p4.props.navigation.getParam("shouldNavigateDown") then
				t2.mountAnimation = p4.props.navigation.getParam("mountAnimation")
				t2.showRobuxBalance = p4.props.navigation.getParam("showRobuxBalance")
				t2.showDropDownTopBar = p4.props.navigation.getParam("showDropDownTopBar")
				t2.shouldNavigateDown = p4.props.navigation.getParam("shouldNavigateDown")
				t2.hideTab = p4.props.navigation.getParam("hideTab")
				t2.simpleView = p4.props.navigation.getParam("simpleView")

				local v88 = p9 .. p8

				p4.props.navigateDownToAvatarScreen(p4.props.navigation.state.routeName, v88, t2)
			else
				t2.mountAnimation = false
				t2.isFirstItemDetails = false
				p4.props.navigation.push(AvatarScreen.ItemDetails, t2)
			end
		elseif FFlagAXEnableHomeTryOnComplexView and v84 then
			local t3 = {
				mountAsFullView = false,
				mountAnimation = true,
				showRobuxBalance = true,
				showDropDownTopBar = true,
				fromHome = true,
				itemId = p8,
				itemType = p9,
				itemSubType = p10
			}
			local v90 = p9 .. p8

			p4.props.navigateDownToAvatarScreen(AvatarScreen.TryOnItem, v90, t3)
		elseif v83 then
			local v91 = p9 .. p8

			p4.props.navigateDownToAvatarScreen(AvatarScreen.ItemDetails, v91, t2)
		else
			p4.props.navigation.push(AvatarScreen.ItemDetails, t2)
		end

		local analytics = p4.props.analytics

		p4.props.sendDetailedCatalogAnalytics(CatalogConstants.AnalyticsContext.ItemDetailsRecommendedItem, analytics.clickCatalogItem, p8, p9, p11, Constants.NumRecommendedItems, v83)
	end
	function p4.renderRecommendedItem(p12, p13, _) -- line: 250
		-- upvalues: Roact (copy), BaseItemCard (copy), p4 (copy)
		return Roact.createElement(BaseItemCard, {
			itemId = p12.id,
			itemType = p12.type,
			itemSubType = p12.subtype,
			hideItemTitle = p4.props.hideItemTitle,
			gridInformation = p12.gridInformation,
			onActivated = function() -- line: 257
				-- upvalues: p4 (copy), p12 (copy), p13 (copy)
				p4.selectRecommendedItem(p12, p13)
			end
		})
	end
	function p4.fetchRecommended() -- line: 263
		-- upvalues: p4 (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), Constants (copy), FFlagAXItemDetailsIxpExposure (copy)
		local itemId = p4.props.itemId
		local itemType = p4.props.itemType
		local itemSubType = p4.props.itemSubType

		if not itemId or (not itemType or not itemSubType) then
			return nil
		end

		if GetFFlagAXHideRecommendationsOnFetchFailure() then
			local v99 = if itemType ~= Constants.ItemType.Asset then p4.props.getRecommendedBundles(itemId, itemSubType, Constants.NumRecommendedItems, true) else p4.props.getRecommendedAssets(itemId, itemSubType, Constants.NumRecommendedItems, true)

			v99:catch(function() -- line: 276
				-- upvalues: p4 (copy)
				if p4.props.onFetchRecommendationsFailed then
					p4.props.onFetchRecommendationsFailed()
				end
			end)

			if FFlagAXItemDetailsIxpExposure then
				return v99
			end

			return nil
		end

		if itemType == Constants.ItemType.Asset then
			p4.props.getRecommendedAssets(itemId, itemSubType, Constants.NumRecommendedItems, true)
		else
			p4.props.getRecommendedBundles(itemId, itemSubType, Constants.NumRecommendedItems, true)
		end

		return nil
	end
end
function v43.didMount(p15) -- line: 306
	-- upvalues: FFlagAXItemDetailsIxpExposure (copy), addUnifiedEventLogging (copy)
	if FFlagAXItemDetailsIxpExposure then
		local v55 = p15.fetchRecommended()

		if v55 then
			v55:andThen(function() -- line: 310
				-- upvalues: p15 (copy), addUnifiedEventLogging (copy)
				if p15.props.forwardRef then
					addUnifiedEventLogging(p15.props.forwardRef, {})
				end
			end)

			return
		end
	else
		p15.fetchRecommended()
	end
end
function v43.didUpdate(p16, p17) -- line: 321
	local itemSubType = p17.itemSubType

	if p16.props.itemSubType and not itemSubType then
		p16.fetchRecommended()
	end
end
function v43.render(p18) -- line: 330
	-- upvalues: withStyle (copy), RoactGamepad (copy), FFlagAXMigrateRecommendedItemsGridToFocusNavigation (copy), Roact (copy), LoadableGridView (copy), FFlagAXItemDetailsIxpExposure (copy), CatalogUtils (copy), Constants (copy), withTextSizeOffset (copy)
	if p18.props.itemId == nil then
		return
	end

	local propsLayoutOrder = p18.props.LayoutOrder
	local recommendedItemSummaries = p18.props.recommendedItemSummaries

	local function v62(p19) -- line: 338
		-- upvalues: withStyle (copy), p18 (copy), RoactGamepad (copy), FFlagAXMigrateRecommendedItemsGridToFocusNavigation (copy), Roact (copy), propsLayoutOrder (copy), LoadableGridView (copy), recommendedItemSummaries (copy), FFlagAXItemDetailsIxpExposure (copy), CatalogUtils (copy), Constants (copy)
		return withStyle(function(p20) -- line: 339
			-- upvalues: p18 (copy), RoactGamepad (copy), FFlagAXMigrateRecommendedItemsGridToFocusNavigation (copy), Roact (copy), propsLayoutOrder (copy), LoadableGridView (copy), recommendedItemSummaries (copy), FFlagAXItemDetailsIxpExposure (copy), CatalogUtils (copy), p19 (copy), Constants (copy)
			local p20Font = p20.Font
			local forwardRef = p18.props.forwardRef

			return RoactGamepad.withFocusController(function(_) -- line: 343
				-- upvalues: FFlagAXMigrateRecommendedItemsGridToFocusNavigation (copy), Roact (copy), propsLayoutOrder (copy), p18 (copy), LoadableGridView (copy), recommendedItemSummaries (copy), FFlagAXItemDetailsIxpExposure (copy), CatalogUtils (copy), p20Font (copy), p19 (copy), Constants (copy), forwardRef (copy)
				if FFlagAXMigrateRecommendedItemsGridToFocusNavigation then
					return Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 0),
						LayoutOrder = propsLayoutOrder,
						AutomaticSize = Enum.AutomaticSize.Y,
						ref = p18.props.focusNavigationRef
					}, Roact.createElement(LoadableGridView, {
						items = recommendedItemSummaries,
						renderItem = function(p22, p23, p24) -- line: 356
							-- upvalues: FFlagAXItemDetailsIxpExposure (copy), p18 (copy)
							if FFlagAXItemDetailsIxpExposure then
								p22.gridInformation = p24
							end

							return p18.renderRecommendedItem(p22, p23)
						end,
						getItemHeight = function(p25) -- line: 362
							-- upvalues: CatalogUtils (copy), p20Font (copy), p19 (copy)
							local v135 = CatalogUtils.getRecommendedItemsGridItemTitleHeight(p20Font, p19)

							return p25 + 10 + v135
						end,
						totalNumItems = Constants.NumRecommendedItems,
						getItemMetrics = p18.props.getItemMetrics,
						[Roact.Ref] = forwardRef
					}))
				end

				return Roact.createElement(LoadableGridView, {
					items = recommendedItemSummaries,
					renderItem = function(p26, p27, p28) -- line: 376
						-- upvalues: p18 (copy)
						p26.gridInformation = p28

						return p18.renderRecommendedItem(p26, p27)
					end,
					getItemHeight = function(p29) -- line: 380
						-- upvalues: CatalogUtils (copy), p20Font (copy), p19 (copy)
						local v140 = CatalogUtils.getRecommendedItemsGridItemTitleHeight(p20Font, p19)

						return p29 + 10 + v140
					end,
					LayoutOrder = propsLayoutOrder,
					totalNumItems = Constants.NumRecommendedItems,
					getItemMetrics = p18.props.getItemMetrics,
					[Roact.Ref] = forwardRef
				})
			end)
		end)
	end

	return withTextSizeOffset(function(p30) -- line: 392
		-- upvalues: v62 (copy)
		return v62(p30)
	end)
end

local v46 = RoactRodux.connect(function(p31, p32) -- line: 397
	-- upvalues: ItemData (copy)
	local v65 = ItemData(p31.AvatarExperience.Common, p32.itemId, p32.itemType)

	return {
		recommendedItemSummaries = v65 and v65.recommendedItemSummaries
	}
end, function(p33) -- line: 402
	-- upvalues: GetFFlagAXHideRecommendationsOnFetchFailure (copy), GetRecommendedBundles (copy), GetRecommendedAssets (copy), SendDetailedCatalogAnalytics (copy), MaybePromptForR15Upgrade (copy), NavigateDownToAvatarScreen (copy)
	return {
		getRecommendedAssets = function(p34, p35, p36, p37) -- line: 411
			-- upvalues: GetFFlagAXHideRecommendationsOnFetchFailure (copy), p33 (copy), GetRecommendedAssets (copy)
			if GetFFlagAXHideRecommendationsOnFetchFailure() then
				return p33(GetRecommendedAssets(p34, p35, p36, p37))
			end

			p33(GetRecommendedAssets(p34, p35, p36, p37))
		end,
		getRecommendedBundles = function(p38, p39, p40, p41) -- line: 403
			-- upvalues: GetFFlagAXHideRecommendationsOnFetchFailure (copy), p33 (copy), GetRecommendedBundles (copy)
			if GetFFlagAXHideRecommendationsOnFetchFailure() then
				return p33(GetRecommendedBundles(p38, p39, p40, p41))
			end

			p33(GetRecommendedBundles(p38, p39, p40, p41))
		end,
		sendDetailedCatalogAnalytics = function(p42, p43, p44, p45, p46, p47, p48) -- line: 423
			-- upvalues: p33 (copy), SendDetailedCatalogAnalytics (copy)
			p33(SendDetailedCatalogAnalytics(p42, p43, p44, p45, p46, p47, p48))
		end,
		maybePromptForR15Upgrade = function(p49, p50, p51, p52, p53) -- line: 444
			-- upvalues: p33 (copy), MaybePromptForR15Upgrade (copy)
			return p33(MaybePromptForR15Upgrade(p49, p50, p51, p52, p53, false))
		end,
		navigateDownToAvatarScreen = function(p54, p55, p56) -- line: 456
			-- upvalues: p33 (copy), NavigateDownToAvatarScreen (copy)
			return p33(NavigateDownToAvatarScreen(p54, p55, p56))
		end
	}
end)(v43)
local v47 = RoactServices.connect({
	analytics = Analytics
})(v46)
local u48 = RoactNavigation.withNavigation(v47)

return Roact.forwardRef(function(p57, p58) -- line: 468
	-- upvalues: FFlagAXMigrateRecommendedItemsGridToFocusNavigation (copy), useFocusGuiObject (copy), React (copy), useRecommendedItemsGridFocusNavigationBindings (copy), Roact (copy), u48 (ref), Cryo (copy)
	local v69 = nil

	if FFlagAXMigrateRecommendedItemsGridToFocusNavigation then
		local v70 = useFocusGuiObject()
		local v71 = React.useCallback(function() -- line: 473
			-- upvalues: v70 (copy), p57 (copy)
			if v70 and (p57.NextSelectionDown and p57.NextSelectionDown.current) then
				v70(p57.NextSelectionDown.current)
			end
		end, { p57.NextSelectionDown })

		v69 = useRecommendedItemsGridFocusNavigationBindings(nil, v71)
	end

	return Roact.createElement(u48, Cryo.Dictionary.join(p57, {
		forwardRef = p58,
		focusNavigationRef = if not FFlagAXMigrateRecommendedItemsGridToFocusNavigation then nil else v69
	}))
end)
