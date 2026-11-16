local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
require(CorePackages.Packages.LuauPolyfill)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/dME")
local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/bundled/dRQ")
local module5 = require("@luauforge/deferred/gkK")
local module6 = require("@luauforge/deferred/gkL")
local module7 = require("@luauforge/deferred/gkM")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed

local navigateDownToAvatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateDownToAvatarScreen
local module9 = require("@luauforge/bundled/fvF")
local module10 = require("@luauforge/deferred/gkQ")
local module11 = require("@luauforge/deferred/gkR")
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging

local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData

local module12 = require("@luauforge/deferred/gkS")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset

local extended = Roact.PureComponent:extend("RecommendedItemsGrid")

local strictInterface = t.strictInterface
local v5 = {
	itemId = t.string,
	itemType = t.string,
	itemSubType = t.optional(t.string),
	LayoutOrder = t.optional(t.integer),
	hideItemTitle = t.optional(t.boolean),
	getItemMetrics = t.optional(t.callback),
	onActivatedMountAsFullView = t.optional(t.boolean),
	onFetchRecommendationsFailed = 0,
	focusNavigationRef = 0,
	recommendedItemSummaries = 0,
	resultsListRef = 0,
	forwardRef = 0,
	itemDetailsPeekViewRefs = 0,
	getRecommendedAssets = 0,
	getRecommendedBundles = 0,
	sendDetailedCatalogAnalytics = 0,
	maybePromptForR15Upgrade = 0,
	navigateDownToAvatarScreen = 0,
	navigation = 0,
	analytics = 0
}
local v6 = if module12() then t.optional(t.callback) else nil
v5.onFetchRecommendationsFailed = v6

v5.focusNavigationRef = t.union(t.callback, t.table)

v5.recommendedItemSummaries = t.optional(t.array(t.strictInterface({
	id = t.string,
	type = t.string,
	subType = t.string,
	gridInformation = t.optional(t.table)
})))

v5.resultsListRef = t.optional(t.table)
v5.forwardRef = t.optional(t.table)
v5.itemDetailsPeekViewRefs = t.optional(t.table)

v5.getRecommendedAssets = t.callback
v5.getRecommendedBundles = t.callback
v5.sendDetailedCatalogAnalytics = t.callback
v5.maybePromptForR15Upgrade = t.callback
v5.navigateDownToAvatarScreen = t.callback

v5.navigation = t.table

v5.analytics = t.table
extended.validateProps = strictInterface(v5)

extended.defaultProps = { itemType = module3.ItemType.Asset }

local moveToActionBarsByButtonR2 = {
	[Enum.KeyCode.ButtonR2] = focusNavigationEventNameEnum.MoveToActionBar
}

local function useRecommendedItemsGridFocusNavigationBindings(p2, callback)
	local v7 = ReactFocusNavigation.useEventMap(moveToActionBarsByButtonR2, p2)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.MoveToActionBar] = {
				handler = InputHandlers.onRelease(function(p3)
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

function extended:init()
	function self.selectRecommendedItem(data, p2, p3)
		local id = data.id
		local kind = data.type
		local subType = data.subType

		local function fn()
			logOnOverlayClosed("RecommendedItemsGrid", (wasLastInputGamepad()))
		end

		local function fn2()
			self.navigateToRecommendedItem(id, kind, subType, p2)
		end

		if self.props.maybePromptForR15Upgrade(self.props.navigation, id, kind, fn, fn2) then
			return
		end

		self.navigateToRecommendedItem(id, kind, subType, p2)
	end

	function self.navigateToRecommendedItem(p2, p3, p4, p5)
		if not (p2 and p3 and p4) then
			return
		end

		local v7 = self.props.onActivatedMountAsFullView == nil or self.props.onActivatedMountAsFullView

		local param = self.props.navigation.getParam("fromProfile")
		local param2 = self.props.navigation.getParam("showFullWithNoPeekView")

		local v8 = {
			itemId = p2,
			itemType = p3,
			itemSubType = p4,
			mountAsFullView = v7,
			mountAnimation = false,
			itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
			resultsListRef = self.props.resultsListRef,
			isFirstItemDetails = false,
			fromProfile = param,
			showFullWithNoPeekView = param2,
			fromSurface = 0
		}

		local v9 = if fFlagAXFixPurchaseSurfaceLogging and self.props.navigation then self.props.navigation.getParam(module3.NavigationParams.fromSurface) else nil
		v8.fromSurface = v9

		if param then
			v8.mountAnimation = false
			v8.isFirstItemDetails = false

			local v10 = p3 .. p2
			self.props.navigateDownToAvatarScreen(avatarScreen.ItemDetails, v10, v8)
		elseif self.props.navigation.getParam("shouldNavigateDown") then
			v8.mountAnimation = self.props.navigation.getParam("mountAnimation")
			v8.showRobuxBalance = self.props.navigation.getParam("showRobuxBalance")
			v8.showDropDownTopBar = self.props.navigation.getParam("showDropDownTopBar")
			v8.shouldNavigateDown = self.props.navigation.getParam("shouldNavigateDown")
			v8.hideTab = self.props.navigation.getParam("hideTab")
			v8.simpleView = self.props.navigation.getParam("simpleView")

			local v10 = p3 .. p2
			self.props.navigateDownToAvatarScreen(self.props.navigation.state.routeName, v10, v8)
		else
			v8.mountAnimation = false
			v8.isFirstItemDetails = false

			self.props.navigation.push(avatarScreen.ItemDetails, v8)
		end

		local analytics = self.props.analytics
		self.props.sendDetailedCatalogAnalytics(
			module2.AnalyticsContext.ItemDetailsRecommendedItem,
			analytics.clickCatalogItem,
			p2,
			p3,
			p5,
			module3.NumRecommendedItems,
			param
		)
	end

	function self.renderRecommendedItem(props, p2, p3)
		return Roact.createElement(module7, {
			itemId = props.id,
			itemType = props.type,
			itemSubType = props.subtype,
			hideItemTitle = self.props.hideItemTitle,
			gridInformation = props.gridInformation,
			onActivated = function()
				self.selectRecommendedItem(props, p2)
			end
		})
	end

	function self.fetchRecommended()
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local itemSubType = self.props.itemSubType

		if not (itemId and itemType and itemSubType) then
			return nil
		end

		if module12() then
			local v7

			if itemType == module3.ItemType.Asset then
				v7 = self.props.getRecommendedAssets(itemId, itemSubType, module3.NumRecommendedItems, true)
			else
				v7 = self.props.getRecommendedBundles(
					itemId,
					itemSubType,
					module3.NumRecommendedItems,
					true
				)
			end

			v7:catch(function()
				if self.props.onFetchRecommendationsFailed then
					self.props.onFetchRecommendationsFailed()
				end
			end)

			if fFlagAXItemDetailsIxpExposure then
				return v7
			end

			return nil
		end

		if itemType == module3.ItemType.Asset then
			self.props.getRecommendedAssets(itemId, itemSubType, module3.NumRecommendedItems, true)
		else
			self.props.getRecommendedBundles(itemId, itemSubType, module3.NumRecommendedItems, true)
		end

		return nil
	end
end

function extended.didMount(p2)
	if fFlagAXItemDetailsIxpExposure then
		local recommended = p2.fetchRecommended()

		if recommended then
			recommended:andThen(function()
				if p2.props.forwardRef then
					addUnifiedEventLogging(
						p2.props.forwardRef,
						{},
						fFlagAXUnifiedImpressionsOnThumbnail and {
							skipImpressionDetection = true
						} or nil
					)
				end
			end)
		end
	else
		p2.fetchRecommended()
	end
end

function extended.didUpdate(p2, p3)
	local itemSubType = p3.itemSubType

	if p2.props.itemSubType and not itemSubType then
		p2.fetchRecommended()
	end
end

function extended.render(p2)
	if p2.props.itemId == nil then
		return
	end

	local layoutOrder = p2.props.LayoutOrder
	local recommendedItemSummaries = p2.props.recommendedItemSummaries

	local function fn(p3)
		return withStyle(function(p4)
			local font = p4.Font
			local forwardRef = p2.props.forwardRef

			return RoactGamepad.withFocusController(function(p5)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					LayoutOrder = layoutOrder,
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = p2.props.focusNavigationRef
				}, Roact.createElement(DefaultMetricsGridView, {
					items = recommendedItemSummaries,
					renderItem = function(p6, p7, gridInformation)
						if fFlagAXItemDetailsIxpExposure then
							p6.gridInformation = gridInformation
						end

						return p2.renderRecommendedItem(p6, p7)
					end,
					getItemHeight = function(p6)
						local recommendedItemsGridItemTitleHeight = module4.getRecommendedItemsGridItemTitleHeight(font, p3)
						return p6 + 10 + recommendedItemsGridItemTitleHeight
					end,
					totalNumItems = module3.NumRecommendedItems,
					getItemMetrics = p2.props.getItemMetrics,
					[Roact.Ref] = forwardRef
				}))
			end)
		end)
	end

	return withTextSizeOffset(function(p3)
		return fn(p3)
	end)
end

local v7 = RoactRodux.connect(function(p2, p3)
	local v8 = itemData(p2.AvatarExperience.Common, p3.itemId, p3.itemType)
	return {
		recommendedItemSummaries = v8 and v8.recommendedItemSummaries
	}
end, function(callback)
	return {
		getRecommendedAssets = function(p2, p3, p4, p5)
			if module12() then
				return callback(module5(p2, p3, p4, p5))
			end

			callback(module5(p2, p3, p4, p5))
		end,
		getRecommendedBundles = function(p2, p3, p4, p5)
			if module12() then
				return callback(module6(p2, p3, p4, p5))
			end

			callback(module6(p2, p3, p4, p5))
		end,
		sendDetailedCatalogAnalytics = function(p2, p3, p4, p5, p6, p7, p8)
			callback(module10(p2, p3, p4, p5, p6, p7, p8))
		end,
		maybePromptForR15Upgrade = function(p2, p3, p4, p5, p6)
			return callback(module11(p2, p3, p4, p5, p6, false))
		end,
		navigateDownToAvatarScreen = function(p2, p3, p4)
			return callback(navigateDownToAvatarScreen(p2, p3, p4))
		end
	}
end)(extended)

local v8 = roactServices.connect({ analytics = module9 })(v7)

local v9 = RoactNavigation.withNavigation(v8)

return Roact.forwardRef(function(p2, p3)
	local v10 = useFocusGuiObject()

	local v11 = useRecommendedItemsGridFocusNavigationBindings(nil, React.useCallback(function()
		if v10 and p2.NextSelectionDown and p2.NextSelectionDown.current then
			v10(p2.NextSelectionDown.current)
		end
	end, { p2.NextSelectionDown, v10 }))

	return Roact.createElement(v9, Cryo.Dictionary.join(p2, {
		forwardRef = p3,
		focusNavigationRef = v11
	}))
end)
