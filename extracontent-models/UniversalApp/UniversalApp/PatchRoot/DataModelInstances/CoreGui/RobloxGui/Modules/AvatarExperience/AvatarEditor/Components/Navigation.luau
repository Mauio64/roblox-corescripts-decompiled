local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local ScreenLayout = AvatarExperienceSlotBasedEditor.Enums.ScreenLayout
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RemoveNewAssetNotification = require(Modules.AvatarExperience.Common.Actions.RemoveNewAssetNotification)
local RemoveNewOutfitNotification = require(Modules.AvatarExperience.Common.Actions.RemoveNewOutfitNotification)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local NavigationFrame = require(Modules.AvatarExperience.Common.Components.NavBar.NavigationFrame)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local NavigatedToDeepLinkAvatarEditor = require(Modules.AvatarExperience.AvatarEditor.Actions.NavigatedToDeepLinkAvatarEditor)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local ItemView = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.ItemView
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	[Constants.PageType.Animation] = "Feature.Avatar.Message.R15AnimationsPrompt",
	[Constants.PageType.Emotes] = "Feature.Avatar.Message.R15EmotesPrompt",
	[Constants.PageType.BodyStyle] = "Feature.Avatar.Message.R15StylesPrompt"
}

local function selectAvatarType(p1) -- line: 69
	return p1.AvatarExperience.AvatarEditor.Character.AvatarType
end
local function selectSelectedCategoryIndex(p2) -- line: 72
	return p2.AvatarExperience.AvatarEditor.Categories.category
end
local function selectSelectedSubcategoryIndex(p3) -- line: 75
	return p3.AvatarExperience.AvatarEditor.Categories.subcategory
end
local function selectNewItemNotifications(p4) -- line: 78
	return p4.AvatarExperience.AvatarEditor.NewItemNotifications
end
local function selectExternalNavigationRequest(p5) -- line: 81
	return p5.AvatarExperience.ExternalNavigationRequest or {}
end
local function Navigation(t2: {[any]: any}) -- line: 85
	-- upvalues: GetAvatarEditorCategories (copy), useDispatch (copy), useNavigation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useSelector (copy), selectAvatarType (copy), selectSelectedCategoryIndex (copy), selectSelectedSubcategoryIndex (copy), selectNewItemNotifications (copy), selectExternalNavigationRequest (copy), useSlotBasedEditorContext (copy), ScreenLayout (copy), ItemView (copy), React (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), RemoveNewAssetNotification (copy), Constants (copy), Constants2 (copy), RemoveNewOutfitNotification (copy), wasLastInputGamepad (copy), logOnOverlayClosed (copy), t1 (copy), AvatarScreen (copy), SetCategoryAndSubcategory (copy), Exit3DFullView (copy), DeepLinkUtils (copy), NavigatedToDeepLinkAvatarEditor (copy), usePrevious (copy), ClearTryOns (copy), NavigationUtils (copy), useAvatarRoute (copy), NavigationFrame (copy)
	local v46 = GetAvatarEditorCategories()
	local v47 = useDispatch()
	local v48 = useNavigation()
	local v49 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
	local v50 = useSelector(selectAvatarType)
	local v51 = useSelector(selectSelectedCategoryIndex)
	local v52 = useSelector(selectSelectedSubcategoryIndex)
	local v53 = useSelector(selectNewItemNotifications)
	local v54 = useSelector(selectExternalNavigationRequest)
	local v55 = useSlotBasedEditorContext()
	local v56 = false

	if v55 then
		v56 = v55.screenLayout == ScreenLayout.PortraitItems and v55.itemView == ItemView.SlotItems
	end

	local v57 = React.useCallback(function() -- line: 108
		-- upvalues: v55 (copy)
		if v55 and v55.handleExitPortraitItems then
			v55.handleExitPortraitItems()
		end
	end, { v55 })
	local v58 = React.useCallback(function(p6, p7) -- line: 114
		-- upvalues: GetAvatarEditorCategories (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), v53 (copy), v47 (copy), RemoveNewAssetNotification (copy), Constants (copy), Constants2 (copy), RemoveNewOutfitNotification (copy)
		local v77 = GetAvatarEditorCategories()

		if GetFFlagAXEnableSlotBasedEditor() then
			local v78 = v77[p6]

			if v78 then
				local v79 = if not v78.Subcategories then nil else v78.Subcategories[p7]

				for _, v81 in (Utils.getNotificationItemTypesForCategory(v79 or v78, v53)) do
					if v53[v81] then
						v47(RemoveNewAssetNotification(v81))
					end
				end
			end

			return
		end

		local Subcategories = v77[p6].Subcategories
		local v83 = Subcategories and (not not Subcategories[p7] and Subcategories[p7].AssetTypeIdStrings) or v77[p6].AssetTypeIdStrings

		if v83 then
			for _, v85 in v83 do
				if v53[v85] then
					v47(RemoveNewAssetNotification(v85))
				end
			end

			return
		end

		if v53[Constants.NewOutfitNotificationKey] then
			if Subcategories and Subcategories[p7] and Subcategories[p7].SearchUuid == Constants2.PurchasedCharacterKey then
				v47(RemoveNewOutfitNotification(Constants.OutfitTypes.Avatar))

				return
			end
		elseif v53[Constants.NewDHOutfitNotificationKey] and Subcategories and Subcategories[p7] and Subcategories[p7].Name == "Style" then
			v47(RemoveNewOutfitNotification(Constants.OutfitTypes.DynamicHead))
		end
	end, {
		v53,
		v47
	})
	local v59 = React.useCallback(function() -- line: 166
		-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v49 (copy)
		local v86 = wasLastInputGamepad()

		logOnOverlayClosed("Navigation", v86)

		if not FFlagAXMigrateAXToGlobalAutofocus and v86 then
			v49.captureFocus()
		end
	end, { if not FFlagAXMigrateAXToGlobalAutofocus then v49 else nil })
	local v60 = React.useCallback(function(p8) -- line: 175
		-- upvalues: t1 (copy), v48 (copy), AvatarScreen (copy), v59 (copy)
		local v88 = t1[p8]

		if v88 ~= nil then
			v48.navigate(AvatarScreen.R15UpgradePrompt, {
				onOverlayClosed = v59,
				bodyTextKey = v88
			})
		end
	end, {
		v48,
		v59
	})
	local v61 = React.useCallback(function(n1: number?, n2: number?) -- line: 193
		-- upvalues: t2 (copy), v51 (copy), v52 (copy), v47 (copy), SetCategoryAndSubcategory (copy), Exit3DFullView (copy), v48 (copy)
		if t2.backToTopSignal and (n1 == nil or n1 == v51) and (n2 == nil or n2 == v52) then
			t2.backToTopSignal:fire()
		end

		v47(SetCategoryAndSubcategory(n1, n2, t2.analytics))
		v47(Exit3DFullView(t2.axAnalytics, v48.state.routeName))
	end, {
		t2.backToTopSignal,
		v51,
		v52,
		t2.analytics,
		t2.axAnalytics,
		v48.state.routeName,
		v47
	})
	local v62 = React.useCallback(function(p9) -- line: 217
		-- upvalues: v58 (copy), v61 (copy), v50 (copy), Constants (copy), GetAvatarEditorCategories (copy), v60 (copy)
		v58(p9, 1)
		v61(p9, nil)

		if v50 == Constants.AvatarType.R6 then
			local v92 = GetAvatarEditorCategories()[p9]

			v60(v92.PageType)
		end
	end, {
		v58,
		v61,
		v50
	})
	local v63 = React.useCallback(function(p10, p11) -- line: 232
		-- upvalues: v51 (copy), v52 (copy)
		local selectedCategoryIndex = p10.selectedCategoryIndex
		local selectedSubcategoryIndex = p10.selectedSubcategoryIndex
		local v97 = selectedCategoryIndex ~= v51
		local v98 = selectedSubcategoryIndex ~= v52

		if not v97 and not v98 then
			return
		end

		if v97 and p11.current then
			p11.current.CanvasPosition = Vector2.new()
		end
	end, {
		v51,
		v52
	})
	local v64 = React.useCallback(function(p12, p13) -- line: 249
		-- upvalues: v58 (copy), v50 (copy), Constants (copy), GetAvatarEditorCategories (copy), v60 (copy), v61 (copy)
		v58(p12, p13)

		if v50 == Constants.AvatarType.R6 then
			local v101 = GetAvatarEditorCategories()[p12]

			if v101 then
				local v102 = v101.Subcategories[p13]

				if v102 then
					v60(v102.PageType)
				end
			end
		end

		v61(nil, p13)
	end, {
		v58,
		v50,
		v60,
		v61
	})
	local v65 = React.useCallback(function() -- line: 269
		-- upvalues: v54 (copy), DeepLinkUtils (copy), v47 (copy), NavigatedToDeepLinkAvatarEditor (copy)
		local v103 = v54.params or {}

		if DeepLinkUtils.avatarEditorDeepLinkExists(v54) then
			v47(NavigatedToDeepLinkAvatarEditor({
				category = v103.category,
				subcategory = v103.subcategory
			}))
		end
	end, {
		v54,
		v47
	})

	React.useEffect(function() -- line: 279
		-- upvalues: v48 (copy), v62 (copy), v64 (copy)
		local v104 = v48.getParam("avatarEditorCategory")

		if v104 then
			v62(v104)
		end

		local v105 = v48.getParam("avatarEditorSubcategory")

		if v105 then
			v64(v104, v105)
		end
	end, {})
	React.useEffect(function() -- line: 291
		-- upvalues: v65 (copy)
		v65()
	end)

	local v66 = usePrevious(v51)
	local v67 = usePrevious(v52)
	local v68 = React.useRef(true)

	React.useLayoutEffect(function() -- line: 299
		-- upvalues: v68 (copy), v51 (copy), v66 (copy), v52 (copy), v67 (copy), DeepLinkUtils (copy), v54 (copy), v47 (copy), ClearTryOns (copy), NavigationUtils (copy), v48 (copy)
		if v68.current then
			v68.current = false

			return
		end

		local v106 = v51 ~= v66 or v52 ~= v67

		if DeepLinkUtils.avatarEditorDeepLinkExists(v54) then
			v106 = false
		end

		if v106 then
			v47(ClearTryOns())
			NavigationUtils.closeFiltersAndItemDetails(v48)
		end
	end, {
		v51,
		v52,
		v54,
		v47,
		v48
	})

	local name = useAvatarRoute().opaque.name
	local v70 = usePrevious(name)

	React.useEffect(function() -- line: 329
		-- upvalues: name (copy), AvatarScreen (copy), v70 (copy), v58 (copy), v51 (copy), v52 (copy)
		local v107 = name == AvatarScreen.AvatarEditor

		if name ~= v70 and v107 then
			v58(v51, v52)
		end
	end, {
		name,
		v51,
		v52,
		v58
	})

	local v71 = v48.getParam("avatarEditorCategory")
	local v72 = usePrevious(v71)

	React.useEffect(function() -- line: 343
		-- upvalues: v71 (copy), v72 (copy), v62 (copy)
		if v71 and v71 ~= v72 then
			v62(v71)
		end
	end, {
		v71,
		v62
	})

	local v73 = v48.getParam("avatarEditorSubcategory")
	local v74 = usePrevious(v73)

	React.useEffect(function() -- line: 351
		-- upvalues: v73 (copy), v74 (copy), v64 (copy), v71 (copy)
		if v73 and v73 ~= v74 then
			v64(v71, v73)
		end
	end, {
		v71,
		v73,
		v64
	})

	return React.createElement(NavigationFrame, {
		shouldUseCategoryId = false,
		selectCategoryId = nil,
		selectedSubcategoryId = nil,
		selectSubcategoryId = nil,
		layoutOrderMain = t2.layoutOrderMain,
		navHeightMain = t2.navHeightMain,
		layoutOrderSub = t2.layoutOrderSub,
		navHeightSub = t2.navHeightSub,
		categoryTable = v46,
		selectedCategoryIndex = v51,
		selectCategory = v62,
		selectedSubcategoryIndex = v52,
		subcategoryTable = v46[v51].Subcategories,
		onSubNavigationPropsDidUpdate = v63,
		selectSubcategory = v64,
		absoluteSizeChanged = t2.absoluteSizeChanged,
		replaceMainNavigationWithCloseableHeader = v56,
		onCloseableHeaderClosed = v57,
		navigationFrameRef = t2.navBarRef,
		NextSelectionUp = t2.NextSelectionUp,
		NextSelectionDown = t2.NextSelectionDown
	})
end

return React.memo(Navigation)
