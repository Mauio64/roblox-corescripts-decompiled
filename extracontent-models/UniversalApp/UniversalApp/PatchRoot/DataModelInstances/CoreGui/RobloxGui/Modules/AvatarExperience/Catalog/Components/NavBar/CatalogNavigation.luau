local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMutedErrorLoggingForCategorySelection = AvatarExperienceFlags.FFlagAXMutedErrorLoggingForCategorySelection

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.Catalog.Thunks.SetCategoryAndSubcategory)
local NavigationFrame = require(Modules.AvatarExperience.Common.Components.NavBar.NavigationFrame)
local PillsNavigationFrame = require(Modules.AvatarExperience.Common.Components.NavBar.PillsNavigationFrame)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)
local NavigateToDeepLinkCatalogFilterThunk = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToDeepLinkCatalogFilterThunk)
local FFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash
local v20 = Roact.PureComponent:extend("CatalogNavigation")
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local v22 = game:DefineFastFlag("AXDisableCategoryPillsOnCatalogSearch", false)
local mutedError = require(Modules.LuaApp.mutedError)
local GetFFlagAXEnableCategoryPills = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableCategoryPills)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXLogNilCategoryAndSubcategorySelection = AvatarExperienceFlags.FFlagAXLogNilCategoryAndSubcategorySelection

v20.validateProps = t.strictInterface({
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
	categories = if not FFlagAXCatalogCategoriesSDUI then nil else t.optional(t.table),
	selectedCategoryId = t.string,
	selectedSubcategoryId = t.optional(t.string),
	externalNavigationRequest = t.table,
	setCategoryAndSubcategory = t.callback,
	setSearchCategoryAndSubcategory = t.callback,
	applyDeepLinkCatalogFilters = t.callback,
	exit3DFullView = t.callback,
	navigation = t.table
})

function v20.init(p1) -- line: 74
	-- upvalues: GetFFlagAXEnableCategoryPills (copy), FFlagAXLogNilCategoryAndSubcategorySelection (copy), mutedError (copy)
	function p1.selectCategory(p2) -- line: 75
		-- upvalues: p1 (copy)
		if p2 == p1.props.selectedCategoryIndex then
			return
		end

		local onCategoryOrSubcategoryChange = p1.props.onCategoryOrSubcategoryChange

		if onCategoryOrSubcategoryChange then
			onCategoryOrSubcategoryChange(p2, 0)
		end

		p1:setCategoryAndSubcategory(p2, nil)
	end
	function p1.selectSubcategory(_, p4) -- line: 89
		-- upvalues: p1 (copy)
		if p4 == p1.props.selectedSubcategoryIndex then
			return
		end

		local onCategoryOrSubcategoryChange = p1.props.onCategoryOrSubcategoryChange

		if onCategoryOrSubcategoryChange then
			onCategoryOrSubcategoryChange(p1.props.selectedCategoryIndex, p4)
		end

		p1:setCategoryAndSubcategory(nil, p4)
	end
	function p1.selectCategoryId(p5) -- line: 103
		-- upvalues: GetFFlagAXEnableCategoryPills (copy), p1 (copy), FFlagAXLogNilCategoryAndSubcategorySelection (copy), mutedError (copy)
		if not GetFFlagAXEnableCategoryPills() then
			if p5 == p1.props.selectedCategoryId and p1.props.selectedSubcategoryId == nil then
				return
			end
		elseif p5 == p1.props.selectedCategoryId then
			return
		end

		local onCategoryOrSubcategoryChangeById = p1.props.onCategoryOrSubcategoryChangeById

		if onCategoryOrSubcategoryChangeById then
			onCategoryOrSubcategoryChangeById(p5, nil)
		end

		if FFlagAXLogNilCategoryAndSubcategorySelection and p5 == nil then
			mutedError("CatalogNavigation:selectCategoryId called with nil categoryId", p5)
		end

		p1:setCategoryAndSubcategoryById(p5, nil)
	end
	function p1.selectSubcategoryId(_, p7) -- line: 127
		-- upvalues: p1 (copy), FFlagAXLogNilCategoryAndSubcategorySelection (copy), mutedError (copy)
		if p7 == p1.props.selectedSubcategoryId then
			return
		end

		local onCategoryOrSubcategoryChangeById = p1.props.onCategoryOrSubcategoryChangeById

		if onCategoryOrSubcategoryChangeById then
			onCategoryOrSubcategoryChangeById(p1.props.selectedCategoryId, p7)
		end

		if FFlagAXLogNilCategoryAndSubcategorySelection and p7 == nil then
			mutedError("CatalogNavigation:selectSubcategoryId called with nil subCategoryId", p7)
		end

		p1:setCategoryAndSubcategoryById(nil, p7)
	end
	function p1.onSubNavigationPropsDidUpdate(p8, p9) -- line: 144
		-- upvalues: p1 (copy)
		if p1.props.selectedCategoryId ~= p8.selectedCategoryId and p9.current then
			p9.current.CanvasPosition = Vector2.new()
		end
	end
end
function v20.setCategoryAndSubcategoryById(t1: {[any]: any}, s1: string?, s2: string?) -- line: 157
	local analytics = t1.props.analytics
	local axAnalytics = t1.props.axAnalytics
	local navigation = t1.props.navigation
	local backToTopSignal = t1.props.backToTopSignal

	if backToTopSignal and (s1 == nil or s1 == t1.props.selectedCategoryId) and (s2 == nil or s2 == t1.props.selectedSubcategoryId) then
		backToTopSignal:fire()
	end

	if t1.props.fromSearch and t1.props.setSearchCategoryAndSubcategory then
		t1.props.setSearchCategoryAndSubcategory(s1, s2)
	else
		t1.props.setCategoryAndSubcategory(s1, s2, analytics)
	end

	t1.props.exit3DFullView(axAnalytics, navigation.state.routeName)
end
function v20.processCatalogDeepLink(p10) -- line: 181
	-- upvalues: DeepLinkUtils (copy)
	local externalNavigationRequest = p10.props.externalNavigationRequest
	local v40 = externalNavigationRequest.params or {}

	if v40.keyword == nil and DeepLinkUtils.catalogDeepLinkExists(externalNavigationRequest) then
		local v41 = DeepLinkUtils.buildCatalogFilterFromDeepLinkParams(v40)

		p10.props.applyDeepLinkCatalogFilters(v41)
	end
end
function v20.didUpdate(p11) -- line: 191
	p11:processCatalogDeepLink()
end
function v20.didMount(p12) -- line: 195
	p12:processCatalogDeepLink()
end
function v20.render(p13) -- line: 199
	-- upvalues: GetCatalogCategoriesFromStore (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogUtils (copy), GetFFlagAXEnableCategoryPills (copy), v22 (copy), Roact (copy), PillsNavigationFrame (copy), NavigationFrame (copy)
	local layoutOrderMain = p13.props.layoutOrderMain
	local layoutOrderSub = p13.props.layoutOrderSub
	local navHeightMain = p13.props.navHeightMain
	local navHeightSub = p13.props.navHeightSub
	local selectedCategoryIndex = p13.props.selectedCategoryIndex
	local selectedSubcategoryIndex = p13.props.selectedSubcategoryIndex
	local selectedCategoryId = p13.props.selectedCategoryId
	local selectedSubcategoryId = p13.props.selectedSubcategoryId
	local absoluteSizeChanged = p13.props.absoluteSizeChanged
	local showingTopics = p13.props.showingTopics
	local selectCategory = p13.selectCategory
	local selectSubcategory = p13.selectSubcategory
	local selectCategoryId = p13.selectCategoryId
	local selectSubcategoryId = p13.selectSubcategoryId
	local v59 = GetCatalogCategoriesFromStore()

	if FFlagAXCatalogCategoriesSDUI then
		v59 = p13.props.categories
	end

	local Subcategories = CatalogUtils.getCategoryId(selectedCategoryId).Subcategories
	local navBarRef = p13.props.navBarRef

	if GetFFlagAXEnableCategoryPills() and (not v22 or not p13.props.fromSearch) then
		return Roact.createElement(PillsNavigationFrame, {
			layoutOrderMain = layoutOrderMain,
			navHeightMain = navHeightMain,
			categoryTable = v59,
			selectedCategoryId = selectedCategoryId,
			selectCategoryId = selectCategoryId,
			selectedSubcategoryId = selectedSubcategoryId,
			selectSubcategoryId = selectSubcategoryId,
			absoluteSizeChanged = absoluteSizeChanged,
			showingTopics = showingTopics,
			navigationFrameRef = navBarRef,
			NextSelectionUp = p13.props.NextSelectionUp,
			NextSelectionDown = p13.props.NextSelectionDown
		})
	end

	return Roact.createElement(NavigationFrame, {
		shouldUseCategoryId = true,
		layoutOrderMain = layoutOrderMain,
		navHeightMain = navHeightMain,
		layoutOrderSub = layoutOrderSub,
		navHeightSub = navHeightSub,
		categoryTable = v59,
		selectedCategoryIndex = selectedCategoryIndex,
		selectCategory = selectCategory,
		selectedSubcategoryIndex = selectedSubcategoryIndex,
		selectSubcategory = selectSubcategory,
		selectedCategoryId = selectedCategoryId,
		selectCategoryId = selectCategoryId,
		selectedSubcategoryId = selectedSubcategoryId,
		selectSubcategoryId = selectSubcategoryId,
		subcategoryTable = Subcategories,
		onSubNavigationPropsDidUpdate = p13.onSubNavigationPropsDidUpdate,
		absoluteSizeChanged = absoluteSizeChanged,
		showingTopics = showingTopics,
		navigationFrameRef = navBarRef,
		NextSelectionUp = p13.props.NextSelectionUp,
		NextSelectionDown = p13.props.NextSelectionDown
	})
end

local v27 = RoactNavigation.withNavigation(v20)

local function mapStateToProps(p14, _) -- line: 290
	return {
		externalNavigationRequest = p14.AvatarExperience.ExternalNavigationRequest or {}
	}
end
local function mapDispatchToProps(p16: ((...any) -> ...any)) -- line: 298
	-- upvalues: SetCategoryAndSubcategory (copy), GetCatalogCategoriesStore (copy), FFlagAXMutedErrorLoggingForCategorySelection (copy), mutedError (copy), Exit3DFullView (copy), FFlagAXFixPrefetchMarketplaceStartupCrash (copy), NavigateToDeepLinkCatalogFilterThunk (copy), NavigatedToDeepLinkCatalogFilter (copy)
	return {
		setCategoryAndSubcategory = function(p17, p18, p19) -- line: 300
			-- upvalues: p16 (copy), SetCategoryAndSubcategory (copy)
			p16(SetCategoryAndSubcategory(p17, p18, p19))
		end,
		setSearchCategoryAndSubcategory = function(p20, p21) -- line: 304
			-- upvalues: GetCatalogCategoriesStore (copy), FFlagAXMutedErrorLoggingForCategorySelection (copy), mutedError (copy)
			if not GetCatalogCategoriesStore.getCatalogSearchSelectionStore().changeCategory(p20, p21) then
				if FFlagAXMutedErrorLoggingForCategorySelection then
					mutedError("[SetSearchCategoryAndSubcategory] Failed to change to category: " .. tostring(p20) .. " and subcategory: " .. tostring(p21))

					return
				end

				mutedError("Failed to select subcategory in SetSearchCategoryAndSubcategory thunk")
			end
		end,
		exit3DFullView = function(p22, p23) -- line: 321
			-- upvalues: p16 (copy), Exit3DFullView (copy)
			p16(Exit3DFullView(p22, p23))
		end,
		applyDeepLinkCatalogFilters = function(p24) -- line: 324
			-- upvalues: FFlagAXFixPrefetchMarketplaceStartupCrash (copy), p16 (copy), NavigateToDeepLinkCatalogFilterThunk (copy), NavigatedToDeepLinkCatalogFilter (copy)
			if FFlagAXFixPrefetchMarketplaceStartupCrash then
				p16(NavigateToDeepLinkCatalogFilterThunk(p24))

				return
			end

			p16(NavigatedToDeepLinkCatalogFilter(p24))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v27)
