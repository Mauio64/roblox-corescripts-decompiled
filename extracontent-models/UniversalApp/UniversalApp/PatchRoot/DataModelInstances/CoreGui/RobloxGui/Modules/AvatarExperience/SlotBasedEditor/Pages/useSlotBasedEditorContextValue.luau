local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local createInventoryStoresFromCategories = require(Modules.AvatarExperience.SlotBasedEditor.Utils.createInventoryStoresFromCategories)
local FullView = AvatarExperienceCommon.Enums.FullView
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local createSlotBasedEditorStore = AvatarExperienceSlotBasedEditor.Stores.createSlotBasedEditorStore
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useStore = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useStore
local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local createSortAndFiltersStore = AvatarExperienceSlotBasedEditor.Stores.createSortAndFiltersStore
local ScreenLayout = AvatarExperienceSlotBasedEditor.Enums.ScreenLayout
local ItemView = AvatarExperienceSlotBasedEditor.Enums.ItemView
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local NavigationParams = AvatarExperienceSlotBasedEditor.Enums.NavigationParams
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local FFlagAXFixCatalogSearchRedirect = require(Modules.AvatarExperience.Flags.FFlagAXFixCatalogSearchRedirect)
local FFlagAXAvatarEditorStoresContext = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarEditorStoresContext

local function getScreenLayout(t1: {[any]: any}) -- line: 50
	-- upvalues: ItemView (copy), ScreenLayout (copy)
	local isPortrait = t1.isPortrait
	local itemView = t1.itemView

	if isPortrait then
		if itemView ~= ItemView.Off then
			return ScreenLayout.PortraitItems
		end

		return ScreenLayout.PortraitSlots
	end

	return ScreenLayout.LandscapeSplit
end
local function useSlotBasedEditorContextValue() -- line: 69
	-- upvalues: useAvatarRoute (copy), useNavigation (copy), useDispatch (copy), useSelector (copy), DeviceOrientationMode (copy), NavigationParams (copy), ItemView (copy), ScreenLayout (copy), GetFFlagAXEnableNewInventoryItemsList (copy), React (copy), createInventoryStoresFromCategories (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), createSortAndFiltersStore (copy), useRoactService (copy), Analytics (copy), Analytics2 (copy), FFlagAXFixCatalogSearchRedirect (copy), GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), SetCategoryAndSubcategory (copy), Exit3DFullView (copy), AvatarScreen (copy), NavigateToSearch (copy), SetFullView (copy), FullView (copy), useStore (copy), createSlotBasedEditorStore (copy), FFlagAXAvatarEditorStoresContext (copy)
	local v39 = useAvatarRoute()
	local v40 = useNavigation()
	local v41 = useDispatch()
	local v42 = useSelector(function(p1) -- line: 74
		-- upvalues: DeviceOrientationMode (copy)
		return p1.DeviceOrientation == DeviceOrientationMode.Portrait
	end)
	local v43 = v40.getParam(NavigationParams.itemView) or (v42 and ItemView.SlotItems or not v42 and ItemView.Off)
	local t2 = {
		isPortrait = v42,
		itemView = v43
	}
	local isPortrait = t2.isPortrait
	local itemView = t2.itemView
	local v47 = if not isPortrait then ScreenLayout.LandscapeSplit else if itemView == ItemView.Off then ScreenLayout.PortraitSlots else ScreenLayout.PortraitItems
	local v48 = if not GetFFlagAXEnableNewInventoryItemsList() then nil else React.useMemo(createInventoryStoresFromCategories, {})
	local v49 = if not GetFFlagAXEnableInventorySortsAndFilters() then nil else React.useMemo(createSortAndFiltersStore, {})
	local v50 = useRoactService(Analytics)
	local v51 = useRoactService(Analytics2)
	local v52 = v40.getParam(NavigationParams.fromScreen)
	local v53 = if not FFlagAXFixCatalogSearchRedirect then nil else v40.getParam(NavigationParams.params)
	local v54 = React.useCallback(function() -- line: 99
		-- upvalues: GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), v41 (copy), SetCategoryAndSubcategory (copy), v51 (copy), Exit3DFullView (copy), v50 (copy), v40 (copy)
		for _, v60 in (GetAvatarEditorCategories()) do
			if v60.NavigationKey == AvatarEditorCategories.All then
				v41(SetCategoryAndSubcategory(v60.Category, nil, v51))

				break
			end
		end

		v41(Exit3DFullView(v50, v40.state.routeName))
	end, {
		v41,
		v50,
		v40.state.routeName,
		v51
	})
	local v55 = React.useCallback(function() -- line: 111
		-- upvalues: v39 (copy), AvatarScreen (copy), v40 (copy), NavigationParams (copy), ItemView (copy), v54 (copy), FFlagAXFixCatalogSearchRedirect (copy), v52 (copy), v53 (copy), v41 (copy), NavigateToSearch (copy), SetFullView (copy), v50 (copy), FullView (copy)
		local v61 = v39.current.name == AvatarScreen.LookDetails

		v40.navigate(AvatarScreen.AvatarEditor, {
			[NavigationParams.itemView] = ItemView.Off
		})

		if v61 then
			v40.navigate(AvatarScreen.LookDetails)
		end

		v54()

		if FFlagAXFixCatalogSearchRedirect and v52 == AvatarScreen.CatalogSearch and v52 ~= v39.opaque.name then
			if v53 and v53.searchParams then
				local t3 = {
					isKeywordSuggestionEnabled = true,
					searchKeyword = v53.searchParams.searchKeyword
				}

				v41(NavigateToSearch(v40, t3))
			end
		elseif v52 and v52 ~= v39.opaque.name then
			v40.navigate(v52)
		end

		v41(SetFullView(v50, v40.state.routeName, FullView.None))
	end, {
		v54,
		v40,
		v52
	})
	local v56 = useStore()
	local v57 = React.useMemo(function() -- line: 143
		-- upvalues: createSlotBasedEditorStore (copy), v56 (copy)
		return createSlotBasedEditorStore(v56)
	end, { v56 })

	return {
		handleExitPortraitItems = v55,
		itemView = v43,
		signalStore = v57,
		screenLayout = v47,
		categoryInventoryStores = if not GetFFlagAXEnableNewInventoryItemsList() or FFlagAXAvatarEditorStoresContext then nil else v48,
		sortAndFiltersStore = if not GetFFlagAXEnableInventorySortsAndFilters() or FFlagAXAvatarEditorStoresContext then nil else v49
	}
end

return useSlotBasedEditorContextValue
