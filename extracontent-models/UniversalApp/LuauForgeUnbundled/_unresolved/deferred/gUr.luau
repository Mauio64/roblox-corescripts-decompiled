local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/deferred/gSy")
local module2 = require("@luauforge/bundled/glS")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module4 = require("@luauforge/bundled/dPG")
local module5 = require("@luauforge/bundled/dPF")
local module6 = require("@luauforge/deferred/fvw")
local module7 = require("@luauforge/deferred/gSv")
local module8 = require("@luauforge/deferred/gUs")
require("@luauforge/bundled/dHK")

local module9 = require("@luauforge/bundled/dMn")

local module10 = require("@luauforge/deferred/gqN")
local fFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash
local extended = Roact.PureComponent:extend("CatalogNavigation")
local module11 = require("@luauforge/bundled/dRQ")
local defineFastFlag = game:DefineFastFlag("AXDisableCategoryPillsOnCatalogSearch", false)
local module12 = require("@luauforge/bundled/dCn")
local module13 = require("@luauforge/bundled/dMC")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXLogNilCategoryAndSubcategorySelection = AvatarExperienceFlags.FFlagAXLogNilCategoryAndSubcategorySelection

local strictInterface = t.strictInterface
local v5 = {
	analytics = t.table,
	axAnalytics = t.table,
	layoutOrderMain = t.number,
	layoutOrderSub = t.number,
	navHeightMain = t.number,
	navHeightSub = t.number,
	absoluteSizeChanged = t.optional(t.callback),
	navBarRef = t.table,
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	backToTopSignal = t.optional(t.table),
	showingTopics = t.optional(t.boolean),
	fromSearch = t.optional(t.boolean),
	onCategoryOrSubcategoryChange = t.optional(t.callback),
	onCategoryOrSubcategoryChangeById = t.optional(t.callback),
	categories = 0,
	selectedCategoryId = 0,
	selectedSubcategoryId = 0,
	externalNavigationRequest = 0,
	setCategoryAndSubcategory = 0,
	setSearchCategoryAndSubcategory = 0,
	applyDeepLinkCatalogFilters = 0,
	exit3DFullView = 0,
	navigation = 0
}

local v6 = if fFlagAXCatalogCategoriesSDUI then t.optional(t.table) else nil
v5.categories = v6

v5.selectedCategoryId = t.string
v5.selectedSubcategoryId = t.optional(t.string)
v5.externalNavigationRequest = t.table

v5.setCategoryAndSubcategory = t.callback
v5.setSearchCategoryAndSubcategory = t.callback
v5.applyDeepLinkCatalogFilters = t.callback
v5.exit3DFullView = t.callback

v5.navigation = t.table
extended.validateProps = strictInterface(v5)

function extended:init()
	function self.selectCategory(p2)
		if p2 == self.props.selectedCategoryIndex then
			return
		end

		local onCategoryOrSubcategoryChange = self.props.onCategoryOrSubcategoryChange

		if onCategoryOrSubcategoryChange then
			onCategoryOrSubcategoryChange(p2, 0)
		end

		self:setCategoryAndSubcategory(p2, nil)
	end

	function self.selectSubcategory(p2, p3)
		if p3 == self.props.selectedSubcategoryIndex then
			return
		end

		local onCategoryOrSubcategoryChange = self.props.onCategoryOrSubcategoryChange

		if onCategoryOrSubcategoryChange then
			onCategoryOrSubcategoryChange(self.props.selectedCategoryIndex, p3)
		end

		self:setCategoryAndSubcategory(nil, p3)
	end

	function self.selectCategoryId(p2)
		if module13() then
			if p2 == self.props.selectedCategoryId then
				return
			end
		elseif p2 == self.props.selectedCategoryId and self.props.selectedSubcategoryId == nil then
			return
		end

		local onCategoryOrSubcategoryChangeById = self.props.onCategoryOrSubcategoryChangeById

		if onCategoryOrSubcategoryChangeById then
			onCategoryOrSubcategoryChangeById(p2, nil)
		end

		if fFlagAXLogNilCategoryAndSubcategorySelection and p2 == nil then
			module12("CatalogNavigation:selectCategoryId called with nil categoryId", nil)
		end

		self:setCategoryAndSubcategoryById(p2, nil)
	end

	function self.selectSubcategoryId(p2, p3)
		if p3 == self.props.selectedSubcategoryId then
			return
		end

		local onCategoryOrSubcategoryChangeById = self.props.onCategoryOrSubcategoryChangeById

		if onCategoryOrSubcategoryChangeById then
			onCategoryOrSubcategoryChangeById(self.props.selectedCategoryId, p3)
		end

		if fFlagAXLogNilCategoryAndSubcategorySelection and p3 == nil then
			module12("CatalogNavigation:selectSubcategoryId called with nil subCategoryId", nil)
		end

		self:setCategoryAndSubcategoryById(nil, p3)
	end

	function self.onSubNavigationPropsDidUpdate(p2, p3)
		if self.props.selectedCategoryId ~= p2.selectedCategoryId and p3.current then
			p3.current.CanvasPosition = Vector2.new()
		end
	end
end

function extended:setCategoryAndSubcategoryById(p3, p4)
	local analytics = self.props.analytics
	local axAnalytics = self.props.axAnalytics
	local navigation = self.props.navigation
	local backToTopSignal = self.props.backToTopSignal

	if
		backToTopSignal
		and (p3 == nil or p3 == self.props.selectedCategoryId)
		and (p4 == nil or p4 == self.props.selectedSubcategoryId)
	then
		backToTopSignal:fire()
	end

	if self.props.fromSearch and self.props.setSearchCategoryAndSubcategory then
		self.props.setSearchCategoryAndSubcategory(p3, p4)
	else
		self.props.setCategoryAndSubcategory(p3, p4, analytics)
	end

	self.props.exit3DFullView(axAnalytics, navigation.state.routeName)
end

function extended:processCatalogDeepLink()
	local externalNavigationRequest = self.props.externalNavigationRequest
	local params = externalNavigationRequest.params or {}

	if params.keyword == nil and module2.catalogDeepLinkExists(externalNavigationRequest) then
		local catalogFilterFromDeepLinkParams = module2.buildCatalogFilterFromDeepLinkParams(params)
		self.props.applyDeepLinkCatalogFilters(catalogFilterFromDeepLinkParams)
	end
end

function extended:didUpdate()
	self:processCatalogDeepLink()
end

function extended:didMount()
	self:processCatalogDeepLink()
end

function extended.render(props)
	local layoutOrderMain = props.props.layoutOrderMain
	local layoutOrderSub = props.props.layoutOrderSub
	local navHeightMain = props.props.navHeightMain
	local navHeightSub = props.props.navHeightSub

	local selectedCategoryIndex = props.props.selectedCategoryIndex
	local selectedSubcategoryIndex = props.props.selectedSubcategoryIndex
	local selectedCategoryId = props.props.selectedCategoryId
	local selectedSubcategoryId = props.props.selectedSubcategoryId

	local absoluteSizeChanged = props.props.absoluteSizeChanged
	local showingTopics = props.props.showingTopics

	local selectCategory = props.selectCategory
	local selectSubcategory = props.selectSubcategory

	local selectCategoryId = props.selectCategoryId
	local selectSubcategoryId = props.selectSubcategoryId

	local v7 = module5()

	if fFlagAXCatalogCategoriesSDUI then
		v7 = props.props.categories
	end

	local subcategories = module11.getCategoryId(selectedCategoryId).Subcategories

	local navBarRef = props.props.navBarRef

	if module13() and not (defineFastFlag and props.props.fromSearch) then
		return Roact.createElement(module8, {
			layoutOrderMain = layoutOrderMain,
			navHeightMain = navHeightMain,
			categoryTable = v7,
			selectedCategoryId = selectedCategoryId,
			selectCategoryId = selectCategoryId,
			selectedSubcategoryId = selectedSubcategoryId,
			selectSubcategoryId = selectSubcategoryId,
			absoluteSizeChanged = absoluteSizeChanged,
			showingTopics = showingTopics,
			navigationFrameRef = navBarRef,
			NextSelectionUp = props.props.NextSelectionUp,
			NextSelectionDown = props.props.NextSelectionDown
		})
	end

	return Roact.createElement(module7, {
		layoutOrderMain = layoutOrderMain,
		navHeightMain = navHeightMain,
		layoutOrderSub = layoutOrderSub,
		navHeightSub = navHeightSub,
		categoryTable = v7,
		selectedCategoryIndex = selectedCategoryIndex,
		selectCategory = selectCategory,
		selectedSubcategoryIndex = selectedSubcategoryIndex,
		selectSubcategory = selectSubcategory,
		selectedCategoryId = selectedCategoryId,
		selectCategoryId = selectCategoryId,
		selectedSubcategoryId = selectedSubcategoryId,
		selectSubcategoryId = selectSubcategoryId,
		shouldUseCategoryId = true,
		subcategoryTable = subcategories,
		onSubNavigationPropsDidUpdate = props.onSubNavigationPropsDidUpdate,
		absoluteSizeChanged = absoluteSizeChanged,
		showingTopics = showingTopics,
		navigationFrameRef = navBarRef,
		NextSelectionUp = props.props.NextSelectionUp,
		NextSelectionDown = props.props.NextSelectionDown
	})
end

local v7 = RoactNavigation.withNavigation(extended)

local function mapStateToProps(p2, p3)
	return {
		externalNavigationRequest = p2.AvatarExperience.ExternalNavigationRequest or {}
	}
end

local function mapDispatchToProps(callback)
	return {
		setCategoryAndSubcategory = function(p2, p3, p4)
			callback(module6(p2, p3, p4))
		end,
		setSearchCategoryAndSubcategory = function(p2, p3)
			if not module4.getCatalogSearchSelectionStore().changeCategory(p2, p3) then
				module12("[SetSearchCategoryAndSubcategory] Failed to change to category: " .. tostring(p2) .. " and subcategory: " .. tostring(p3))
			end
		end,
		exit3DFullView = function(p2, p3)
			callback(module(p2, p3))
		end,
		applyDeepLinkCatalogFilters = function(p2)
			if fFlagAXFixPrefetchMarketplaceStartupCrash then
				callback(module10(p2))
			else
				callback(module9(p2))
			end
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v7)
