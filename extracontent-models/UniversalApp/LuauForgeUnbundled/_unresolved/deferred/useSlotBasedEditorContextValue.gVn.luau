local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module2 = require("@luauforge/bundled/fuM")
local module3 = require("@luauforge/bundled/dMd")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module5 = require("@luauforge/deferred/gVm")

local module6 = require("@luauforge/deferred/gVo")
local fullView = AvatarExperienceCommon.Enums.FullView
local module7 = require("@luauforge/bundled/dOj")
local module8 = require("@luauforge/deferred/gft")
local module9 = require("@luauforge/deferred/gSy")
local module10 = require("@luauforge/bundled/gnZ")
local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module11 = require("@luauforge/bundled/geT")
local createSlotBasedEditorStore = module2.Stores.createSlotBasedEditorStore

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local module12 = require("@luauforge/bundled/eeH")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useStore

local module13 = require("@luauforge/deferred/fwp")
local createSortAndFiltersStore = module2.Stores.createSortAndFiltersStore

local screenLayout = module2.Enums.ScreenLayout
local itemView = module2.Enums.ItemView
local avatarEditorCategories = module3.Enums.AvatarEditorCategories
local navigationParams = module2.Enums.NavigationParams
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode

local module14 = require("@luauforge/bundled/dOb")

local module15 = require("@luauforge/deferred/gOR")
local module16 = require("@luauforge/deferred/gVp")

local fFlagAXAvatarEditorStoresContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarEditorStoresContext

local fFlagAXEditorEnableThumbnailLatencyStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorEnableThumbnailLatencyStore

local function getScreenLayout(p2)
	local isPortrait = p2.isPortrait
	local itemView2 = p2.itemView

	if not isPortrait then
		return screenLayout.LandscapeSplit
	end

	if itemView2 == itemView.Off then
		return screenLayout.PortraitSlots
	end

	return screenLayout.PortraitItems
end

local function useSlotBasedEditorContextValue()
	local v5 = useAvatarRoute()
	local v6 = useNavigation()
	local v7 = useDispatch()

	local v8 = useSelector(function(p2): boolean
		return p2.DeviceOrientation == deviceOrientationMode.Portrait
	end)

	local v9 = v6.getParam(navigationParams.itemView)
		or v8 and itemView.SlotItems
		or not v8 and itemView.Off

	local v10 = { isPortrait = v8, itemView = v9 }
	local isPortrait = v10.isPortrait
	local itemView2 = v10.itemView
	local v11

	if isPortrait then
		if itemView2 == itemView.Off then
			v11 = screenLayout.PortraitSlots
		else
			v11 = screenLayout.PortraitItems
		end
	else
		v11 = screenLayout.LandscapeSplit
	end

	local v12

	if module14() and not fFlagAXAvatarEditorStoresContext then
		v12 = React.useMemo(module5, {})
	end

	local v13

	if module15() and not fFlagAXAvatarEditorStoresContext then
		v13 = React.useMemo(createSortAndFiltersStore, {})
	end

	local v14

	if fFlagAXEditorEnableThumbnailLatencyStore and not fFlagAXAvatarEditorStoresContext then
		v14 = React.useMemo(module6, {})
	end

	local v15 = module12(avatarExperienceAnalyticsService)
	local v16 = module12(module11)
	local param = v6.getParam(navigationParams.fromScreen)
	local v17 = if module16 then v6.getParam(navigationParams.params) else nil

	local v18 = React.useCallback(function()
		local v19 = module7()

		for k, v20 in v19 do
			if v20.NavigationKey == avatarEditorCategories.All then
				v7(module8(v20.Category, nil, v16))
				break
			end
		end

		v7(module9(v15, v6.state.routeName))
	end, { v7, v15, v6.state.routeName, v16 })

	local v19 = React.useCallback(function()
		local v20 = v5.current.name == avatarScreen.LookDetails
		v6.navigate(avatarScreen.AvatarEditor, {
			[navigationParams.itemView] = itemView.Off
		})

		if v20 then
			v6.navigate(avatarScreen.LookDetails)
		end

		v18()

		if module16 and param == avatarScreen.CatalogSearch and param ~= v5.opaque.name then
			if v17 and v17.searchParams then
				v7(module13(v6, {
					searchKeyword = v17.searchParams.searchKeyword,
					isKeywordSuggestionEnabled = true
				}))
			end
		elseif param and param ~= v5.opaque.name then
			v6.navigate(param)
		end

		v7(module10(v15, v6.state.routeName, fullView.None))
	end, { v18, v6, param })

	local v20 = useStore()
	local v21 = {
		handleExitPortraitItems = v19,
		itemView = v9,
		signalStore = React.useMemo(function()
			return createSlotBasedEditorStore(v20)
		end, { v20 }),
		screenLayout = v11,
		categoryInventoryStores = 0,
		sortAndFiltersStore = 0,
		thumbnailLatencyStores = 0
	}

	if not module14() or fFlagAXAvatarEditorStoresContext then
		v12 = nil
	end

	v21.categoryInventoryStores = v12

	if not module15() or fFlagAXAvatarEditorStoresContext then
		v13 = nil
	end

	v21.sortAndFiltersStore = v13

	if not fFlagAXEditorEnableThumbnailLatencyStore or fFlagAXAvatarEditorStoresContext then
		v14 = nil
	end

	v21.thumbnailLatencyStores = v14
	return v21
end

return useSlotBasedEditorContextValue
