local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local module = require("@luauforge/bundled/fuM")
local useSlotBasedEditorContext = module.Context.useSlotBasedEditorContext
local screenLayout = module.Enums.ScreenLayout
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

require("@luauforge/bundled/dHK")

local module3 = require("@luauforge/bundled/dPj")
local module4 = require("@luauforge/bundled/dPl")
local module5 = require("@luauforge/bundled/dOj")
local module6 = require("@luauforge/deferred/gft")
local module7 = require("@luauforge/deferred/gSv")
local module8 = require("@luauforge/bundled/dMx")
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad

local module9 = require("@luauforge/bundled/dMt")
local module10 = require("@luauforge/bundled/glS")
local module11 = require("@luauforge/bundled/fvh")
local clearTryOns = require("@luauforge/bundled/dHL").Actions.ClearTryOns
local itemView = require("@luauforge/bundled/fuM").Enums.ItemView

local module12 = require("@luauforge/bundled/dNQ")
local module13 = require("@luauforge/bundled/dTM")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local module14 = require("@luauforge/deferred/gSy")

local module15 = require("@luauforge/bundled/dOc")

local v5 = {
	[module8.PageType.Animation] = "Feature.Avatar.Message.R15AnimationsPrompt",
	[module8.PageType.Emotes] = "Feature.Avatar.Message.R15EmotesPrompt",
	[module8.PageType.BodyStyle] = "Feature.Avatar.Message.R15StylesPrompt"
}

local function selectAvatarType(p2)
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local function selectSelectedCategoryIndex(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.category
end

local function selectSelectedSubcategoryIndex(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.subcategory
end

local function selectNewItemNotifications(p2)
	return p2.AvatarExperience.AvatarEditor.NewItemNotifications
end

local function selectExternalNavigationRequest(p2)
	return p2.AvatarExperience.ExternalNavigationRequest or {}
end

local function Navigation(props)
	local v6 = module5()
	local v7 = useDispatch()
	local v8 = useNavigation()

	local v9 = useSelector(selectAvatarType)
	local v10 = useSelector(selectSelectedCategoryIndex)
	local v11 = useSelector(selectSelectedSubcategoryIndex)
	local v12 = useSelector(selectNewItemNotifications)
	local v13 = useSelector(selectExternalNavigationRequest)

	local v14 = useSlotBasedEditorContext()
	local v15

	if v14 then
		v15 = v14.screenLayout == screenLayout.PortraitItems and v14.itemView == itemView.SlotItems
	else
		v15 = false
	end

	local v16 = React.useCallback(function()
		if v14 and v14.handleExitPortraitItems then
			v14.handleExitPortraitItems()
		end
	end, { v14 })

	local v17 = React.useCallback(function(p2, p3)
		local v18 = module5()

		if module15() then
			local v19 = v18[p2]

			if v19 then
				local v20 = if v19.Subcategories then v19.Subcategories[p3] else nil

				local notificationItemTypesForCategory = module11.getNotificationItemTypesForCategory(
					v20 or v19,
					v12
				)

				for k, v21 in notificationItemTypesForCategory do
					if v12[v21] then
						v7(module3(v21))
					end
				end
			end
		else
			local subcategories = v18[p2].Subcategories

			local assetTypeIdStrings = subcategories
				and subcategories[p3]
				and subcategories[p3].AssetTypeIdStrings
				or v18[p2].AssetTypeIdStrings

			if assetTypeIdStrings then
				for k, assetTypeIdString in assetTypeIdStrings do
					if v12[assetTypeIdString] then
						v7(module3(assetTypeIdString))
					end
				end
			elseif v12[module8.NewOutfitNotificationKey] then
				if
					subcategories
					and subcategories[p3]
					and subcategories[p3].SearchUuid == module12.PurchasedCharacterKey
				then
					v7(module4(module8.OutfitTypes.Avatar))
				end
			elseif
				v12[module8.NewDHOutfitNotificationKey]
				and subcategories
				and subcategories[p3]
				and subcategories[p3].Name == "Style"
			then
				v7(module4(module8.OutfitTypes.DynamicHead))
			end
		end
	end, { v12, v7 })

	local v18 = React.useCallback(function()
		logOnOverlayClosed("Navigation", (wasLastInputGamepad()))
	end, {})

	local v19 = React.useCallback(function(p2)
		local v20 = v5[p2]

		if v20 ~= nil then
			v8.navigate(avatarScreen.R15UpgradePrompt, {
				onOverlayClosed = v18,
				bodyTextKey = v20
			})
		end
	end, { v8, v18 })

	local v20 = React.useCallback(function(p2, p3)
		if props.backToTopSignal and (p2 == nil or p2 == v10) and (p3 == nil or p3 == v11) then
			props.backToTopSignal:fire()
		end

		v7(module6(p2, p3, props.analytics))

		v7(module14(props.axAnalytics, v8.state.routeName))
	end, {
		props.backToTopSignal,
		v10,
		v11,
		props.analytics,
		props.axAnalytics,
		v8.state.routeName,
		v7
	})

	local v21 = React.useCallback(function(p2)
		v17(p2, 1)
		v20(p2, nil)

		if v9 == module8.AvatarType.R6 then
			v19(module5()[p2].PageType)
		end
	end, { v17, v20, v9 })

	local v22 = React.useCallback(function(p2, p3)
		local selectedCategoryIndex = p2.selectedCategoryIndex
		local selectedSubcategoryIndex = p2.selectedSubcategoryIndex
		local v23 = v10 ~= selectedCategoryIndex
		local v24 = v11 ~= selectedSubcategoryIndex

		if (v23 or v24) and v23 and p3.current then
			p3.current.CanvasPosition = Vector2.new()
		end
	end, { v10, v11 })

	local v23 = React.useCallback(function(p2, p3)
		v17(p2, p3)

		if v9 == module8.AvatarType.R6 then
			local v24 = module5()[p2]

			local v25 = v24 and v24.Subcategories[p3]

			if v25 then
				v19(v25.PageType)
			end
		end

		v20(nil, p3)
	end, { v17, v9, v19, v20 })

	local v24 = React.useCallback(function()
		local params = v13.params or {}

		if module10.avatarEditorDeepLinkExists(v13) then
			v7(module9({ category = params.category, subcategory = params.subcategory }))
		end
	end, { v13, v7 })

	React.useEffect(function()
		local param = v8.getParam("avatarEditorCategory")

		if param then
			v21(param)
		end

		local param2 = v8.getParam("avatarEditorSubcategory")

		if param2 then
			v23(param, param2)
		end
	end, {})

	React.useEffect(function()
		v24()
	end)

	local v25 = usePrevious(v10)
	local v26 = usePrevious(v11)
	local ref = React.useRef(true)
	React.useLayoutEffect(function()
		if ref.current then
			ref.current = false
			return
		end

		local v27 = v10 ~= v25 or v11 ~= v26

		if module10.avatarEditorDeepLinkExists(v13) then
			v27 = false
		end

		if v27 then
			v7(clearTryOns())
			module13.closeFiltersAndItemDetails(v8)
		end
	end, { v10, v11, v13, v7, v8 })

	local name = useAvatarRoute().opaque.name
	local v27 = usePrevious(name)
	React.useEffect(function()
		local v28 = name == avatarScreen.AvatarEditor

		if name == v27 then
			v28 = false
		end

		if v28 then
			v17(v10, v11)
		end
	end, { name, v10, v11, v17 })

	local param = v8.getParam("avatarEditorCategory")
	local v28 = usePrevious(param)
	React.useEffect(function()
		if param and param ~= v28 then
			v21(param)
		end
	end, { param, v21 })

	local param2 = v8.getParam("avatarEditorSubcategory")
	local v29 = usePrevious(param2)
	React.useEffect(function()
		if param2 and param2 ~= v29 then
			v23(param, param2)
		end
	end, { param, param2, v23 })

	return React.createElement(module7, {
		layoutOrderMain = props.layoutOrderMain,
		navHeightMain = props.navHeightMain,
		layoutOrderSub = props.layoutOrderSub,
		navHeightSub = props.navHeightSub,
		categoryTable = v6,
		shouldUseCategoryId = false,
		selectedCategoryIndex = v10,
		selectCategory = v21,
		selectedSubcategoryIndex = v11,
		selectCategoryId = nil,
		selectedSubcategoryId = nil,
		selectSubcategoryId = nil,
		subcategoryTable = v6[v10].Subcategories,
		onSubNavigationPropsDidUpdate = v22,
		selectSubcategory = v23,
		absoluteSizeChanged = props.absoluteSizeChanged,
		replaceMainNavigationWithCloseableHeader = v15,
		onCloseableHeaderClosed = v16,
		navigationFrameRef = props.navBarRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	})
end

return React.memo(Navigation)
