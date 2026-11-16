local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local module = require("@luauforge/bundled/edB")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module2 = require("@luauforge/bundled/dOB")
local module3 = require("@luauforge/bundled/dOC")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local module4 = require("@luauforge/bundled/fuM")
local useSlotBasedEditorContext = module4.Context.useSlotBasedEditorContext
local constants = module4.Constants
local module5 = require("@luauforge/bundled/dNQ")
local buildSlots = module4.Utils.buildSlots
local buildBodySlotViewportProps = module4.Utils.buildBodySlotViewportProps
local avatarEditorSubcategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorSubcategories
local slotCircularGradientFrame = module4.Components.SlotCircularGradientFrame
local categories = module4.Enums.Categories
local clearAllButton = module4.Components.ClearAllButton
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local slotItemCardThumbnail = module4.Components.SlotItemCardThumbnail
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local module8 = require("@luauforge/bundled/geT")
local module9 = require("@luauforge/deferred/gST")
local module10 = require("@luauforge/bundled/eeH")
local module11 = require("@luauforge/deferred/gft")
local module12 = require("@luauforge/bundled/dOj")
local getAssetTypesByCategory = module4.Utils.getAssetTypesByCategory
local useSlotItemCardBreakpoints = module4.Hooks.useSlotItemCardBreakpoints

require("@luauforge/deferred/gSU")
require("@luauforge/deferred/gSY")
require("@luauforge/deferred/gTa")
local itemView = module4.Enums.ItemView
local navigationParams = module4.Enums.NavigationParams
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode

local module13 = require("@luauforge/deferred/goo")
local slotType = module4.Enums.SlotType

local module14 = require("@luauforge/deferred/giE")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local module15 = require("@luauforge/deferred/gTc")

local module16 = require("@luauforge/bundled/gfa")

local fFlagAXSlotBasedEditorCategoryTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotBasedEditorCategoryTooltip

local fFlagAXSlotsDesktopRedesign = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsDesktopRedesign
local fFlagAXMigrateSlotsSignals = AvatarExperienceFlags.FFlagAXMigrateSlotsSignals
local fFlagAXSlotsDisableScrollAwayOnLandscape = AvatarExperienceFlags.FFlagAXSlotsDisableScrollAwayOnLandscape
local defineFastFlag = game:DefineFastFlag("AXSlotCategoriesNilCheck", false)
local fFlagAXSlotEditorCategoryMenu = AvatarExperienceFlags.FFlagAXSlotEditorCategoryMenu

local function buildStringsToLocalize(items, nameTranslationKey)
	local stringsToLocalize = {}

	for k, item in items do
		if item.slotType == slotType.LayeredSlot then
			for i = 1, item.layerLimit do
				stringsToLocalize[item.nameTranslationKey .. "_" .. i] = {
					item.nameTranslationKey,
					layerIndex = i
				}
			end
		else
			stringsToLocalize[item.nameTranslationKey] = item.nameTranslationKey
		end
	end

	stringsToLocalize[nameTranslationKey] = nameTranslationKey
	return stringsToLocalize
end

local function getCategoryIndices(editorSubcategory)
	local v5 = module12()

	for k, v6 in v5 do
		if not v6.Subcategories then
			continue
		end

		for k2, subcategory in v6.Subcategories do
			if subcategory.NavigationKey == editorSubcategory then
				return k, k2, nil
			end

			if not (fFlagAXEditorSubcategoryFilters and subcategory.SubcategoryFilters) then
				continue
			end

			for k3, subcategoryFilter in subcategory.SubcategoryFilters do
				if subcategoryFilter.NavigationKey == editorSubcategory then
					return k, k2, k3
				end
			end
		end
	end

	return nil, nil, nil
end

local function shallowEqual(items, current): boolean
	if items == current then
		return true
	end

	if type(items) ~= "table" or type(current) ~= "table" then
		return false
	end

	for k, item in items do
		if current[k] ~= item then
			return false
		end
	end

	for k, item in current do
		if items[k] == nil then
			return false
		end
	end

	return true
end

local function fn(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.category
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.subcategory
end

local function useSlotProps(p2)
	local v5 = useSlotBasedEditorContext()
	local v6 = useDispatch()
	local v7 = module10(module8)
	local v8 = module10(module9)
	local v9 = useTokens()
	local v10 = module10(module)
	local v11 = useNavigation()
	local v12 = useAvatarRoute()
	local ref = React.useRef(nil)
	local v13 = useSelector(function(p3): boolean
		return p3.DeviceOrientation == deviceOrientationMode.Portrait
	end)

	local v14 = useSelector(fn)
	local v15 = useSelector(fn2)

	local v16 = useSlotItemCardBreakpoints(ref.current and ref.current.AbsoluteSize)

	local v17 = useSelector(function(p3)
		if module15 then
			return p3.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
		end

		return p3.AvatarExperience.AvatarEditor.Character.EquippedAssets
	end)
	local v18

	if module16 then
		local v19 = useSelector(function(p3)
			return p3.AvatarExperience.AvatarEditor.Character.BodyColor3s
		end)

		v18 = React.useMemo(function()
			return Cryo.Dictionary.values(v19)
		end, { v19 })
	else
		v18 = useSelector(function(p3)
			return Cryo.Dictionary.values(p3.AvatarExperience.AvatarEditor.Character.BodyColor3s)
		end)
	end

	assert(v5 ~= nil, "useSlotProps must be used within a SlotBasedEditorContextProvider")
	local v19

	if fFlagAXMigrateSlotsSignals then
		v19 = SignalsReact.useSignalState(v5.signalStore.getSlotCategory)
	else
		v19 = v5.slotCategory
	end

	local setSlotCategory = if fFlagAXMigrateSlotsSignals then v5.signalStore.setSlotCategory else v5.setSlotCategory
	local v20

	if fFlagAXMigrateSlotsSignals then
		v20 = SignalsReact.useSignalState(v5.signalStore.getSlotIndex)
	else
		v20 = v5.slotIndex
	end

	local setSlotIndex = if fFlagAXMigrateSlotsSignals then v5.signalStore.setSlotIndex else v5.setSlotIndex
	local v21

	if fFlagAXMigrateSlotsSignals then
		v21 = SignalsReact.useSignalState(v5.signalStore.getSlots)
	elseif module16 then
		v21 = React.useMemo(function()
			return buildSlots(constants.SlotEditorCategories[v19].slots, v17)
		end, { v19, v17 })
	else
		v21 = buildSlots(constants.SlotEditorCategories[v19].slots, v17)
	end

	local nameTranslationKey = constants.SlotEditorCategories[v19].nameTranslationKey
	local v22

	if module16 then
		local v23 = useLocalization(buildStringsToLocalize(v21, nameTranslationKey))

		local ref2 = React.useRef(nil)
		v22 = React.useMemo(function()
			if ref2.current and shallowEqual(v23, ref2.current) then
				return ref2.current
			end

			ref2.current = v23
			return v23
		end, { v23 })
	else
		v22 = useLocalization(buildStringsToLocalize(v21, nameTranslationKey))
	end

	local v23 = module12()

	local v24 = React.useCallback(function(data)
		local v25 = nil
		local v26 = nil
		local v27 = nil

		if data.eligibleSubcategories ~= nil and (not defineFastFlag or v23[v14].Subcategories ~= nil) then
			if data.currentAssetType == nil then
				if table.find(data.eligibleSubcategories, v23[v14].Subcategories[v15].NavigationKey) then
					v25 = v14
					v26 = v15
				end
			else
				for k, subcategory in v23[v14].Subcategories do
					if
						table.find(data.eligibleSubcategories, subcategory.NavigationKey)
						and subcategory.AssetTypeIdStrings ~= nil
						and table.find(
							subcategory.AssetTypeIdStrings,
							(tostring(data.currentAssetType.Value))
						)
					then
						v25 = v14
						v26 = k
						v27 = nil
						break
					end
				end
			end
		end

		if v25 == nil then
			v25, v26, v27 = getCategoryIndices(data.editorSubcategory)
		end

		if v25 and v26 then
			if not fFlagAXEditorSubcategoryFilters then
				v27 = nil
			end

			v6(module11(v25, v26, v7, v27))
		end
	end, { v14, v15, v6, v7 })

	local useCallback = React.useCallback
	local function fn3(p3, p4)
		setSlotCategory(p3)
		setSlotIndex(1)
		v6(module11(p4.index + 1, 1, v7))
		v6(module3())
	end

	local v26 = if module16 and not fFlagAXSlotsDesktopRedesign then v13 else nil
	local v28 = useCallback(fn3, {
		setSlotCategory,
		setSlotIndex,
		v6,
		v26,
		if module16 then v7 else nil
	})

	local v29 = v23 and v23[v14]
	local v30 = v29 and v29.Subcategories and v29.Subcategories[v15]

	local hideFilter = v29 and v29.hideFilter
	local hideFilter2 = v30 and v30.hideFilter
	local v31 = hideFilter or hideFilter2

	local useMemo = React.useMemo
	local function fn4()
		local v32 = {
			navHeight = v16.navHeight,
			categories = table.clone(constants.SlotEditorCategories),
			onSlotCategorySelected = v28,
			enableSnapToSelectedItem = true,
			LayoutOrder = 2,
			slotCategory = v19
		}

		if fFlagAXSlotsDesktopRedesign then
			v32.categories[categories.All].hide = v13
		end

		v32.categories[categories.Avatars].hide = not (fFlagAXSlotsDesktopRedesign or v13)
		v32.categories[categories.Emotes].hide = not (fFlagAXSlotsDesktopRedesign or v13)

		if fFlagAXSlotEditorCategoryMenu then
			v32.showFilterButton = (fFlagAXSlotsDesktopRedesign or v13) and not v31
		end

		return v32
	end

	local v33 = if fFlagAXSlotEditorCategoryMenu then v31 else nil
	local v34 = if module16 then v16 else nil
	local v36 = useMemo(fn4, {
		v13,
		v19,
		v33,
		v34,
		if module16 then v28 else nil
	})
	local v37

	if fFlagAXSlotsDisableScrollAwayOnLandscape then
		v37 = not v13 or constants.SlotEditorCategories[v19].disableScrollAway
	else
		v37 = nil
	end

	local v38

	if fFlagAXSlotBasedEditorCategoryTooltip then
		local v39 = useSelector(function(p3)
			return p3.AvatarExperience.Common.FullView.AvatarEditor
		end)

		local function fn5()
			local v40 = tostring(v39) ~= "FullView.SceneFullView"
			local v41 = p2.slotSubNavigationFill == 1
				or p2.slotSubNavigationFill == nil
				or fFlagAXSlotsDisableScrollAwayOnLandscape and v37

			return v40 and v41
		end

		v38 = React.useMemo(fn5, {
			v39,
			p2.slotSubNavigationFill,
			if fFlagAXSlotsDisableScrollAwayOnLandscape then v37 else nil
		})
	else
		v38 = nil
	end

	React.useEffect(function()
		setSlotCategory(v23[v14].NavigationKey)

		if v23[v14].Subcategories ~= nil then
			if
				v20 ~= nil
				and v21[v20] ~= nil
				and v21[v20].eligibleSubcategories ~= nil
				and table.find(v21[v20].eligibleSubcategories, v23[v14].Subcategories[v15].NavigationKey)
			then
				return
			end

			for k, v39 in v21 do
				local v40

				if v39.eligibleSubcategories == nil then
					v40 = v39.editorSubcategory == v23[v14].Subcategories[v15].NavigationKey
				else
					v40 = table.find(v39.eligibleSubcategories, v23[v14].Subcategories[v15].NavigationKey)
				end

				if v40 then
					setSlotIndex(k)
					return
				end
			end
		end
	end, { v14, v15, setSlotIndex, setSlotCategory, v23, v21, v20 })

	local useMemo2 = React.useMemo
	local function fn5()
		local v39 = {
			slotCategory = v19,
			slotIndex = v20,
			index = constants.SlotEditorCategories[v19].index,
			slots = {},
			buttonPadding = v16.scrollingFramePadding.buttonPadding,
			contentPadding = v16.scrollingFramePadding.contentPadding,
			enableSnapToSelectedItem = v16.enableSnapToSelectedSlot,
			enableIntroScroll = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			slotSubNavigationFrameHeight = v16.slotCardTotalHeight,
			canShowTooltip = if fFlagAXSlotBasedEditorCategoryTooltip then v38 else nil
		}

		if v19 ~= categories.Body then
			v39.clearAllButton = {
				onActivated = function()
					if module14 then
						local function fn6()
							local assetTypesByCategory = getAssetTypesByCategory(v19, v21)

							if #assetTypesByCategory > 0 then
								v6(module2(assetTypesByCategory))
							end

							if constants.SlotEditorCategories[v19].resetSlotOnClearAll then
								setSlotIndex(1)
								v24(v21[1])
							end
						end

						v11.navigate(avatarScreen.SlotEditorClearAllConfirmationPrompt, {
							slotCategory = v19,
							clearAll = fn6
						})
					else
						local assetTypesByCategory = getAssetTypesByCategory(v19, v21)

						if #assetTypesByCategory > 0 then
							v6(module2(assetTypesByCategory))
						end
					end
				end,
				renderHeaderSlot = function()
					return React.createElement(clearAllButton)
				end,
				Size = v16.itemCardSize,
				text = v10:Format("Feature.Avatar.Action.Clear")
			}
		end

		for k, v41 in v21 do
			local slots = v39.slots
			local v42 = {
				renderHeaderSlot = function()
					if v41.editorSubcategory == avatarEditorSubcategories.PurchasedCharacters then
						return React.createElement(
							module13,
							buildBodySlotViewportProps(module5.DefaultBodyColor3, v17)
						)
					end

					if v41.editorSubcategory == avatarEditorSubcategories.Skin then
						return React.createElement(slotCircularGradientFrame, {
							Colors = v18
						})
					end

					if v41.editorSubcategory == avatarEditorSubcategories.Build then
						return React.createElement(slotItemCardThumbnail, {
							icon = v41.icon,
							iconFrameStyles = v16.slotItemCardThumbnailStyles.iconFrameStyles,
							ignoredUrl = true
						})
					end

					local v43 = false

					if table.find(v41.assetTypes, Enum.AvatarAssetType.Face) then
						local v44 = v17[tostring(Enum.AvatarAssetType.DynamicHead.Value)]
						v43 = v44 ~= nil and next(v44) and true or false
					end

					return React.createElement(slotItemCardThumbnail, {
						url = v41.thumbnailUrl,
						icon = v41.icon,
						enableThumbnailOverlay = v43,
						iconFrameStyles = v16.slotItemCardThumbnailStyles.iconFrameStyles
					})
				end,
				BackgroundTransparency = not v41.thumbnailUrl and v41.editorSubcategory ~= avatarEditorSubcategories.Skin and v41.editorSubcategory ~= avatarEditorSubcategories.Build and v41.editorSubcategory ~= avatarEditorSubcategories.PurchasedCharacters and 1 or nil,
				title = 0,
				Size = 0,
				isActive = 0,
				editorSubcategory = 0,
				slotType = 0,
				onActivated = 0,
				hide = 0
			}

			local v43 = if v41.slotType == slotType.LayeredSlot then v22[v41.nameTranslationKey .. "_" .. v41.layerIndex + 1] else v22[v41.nameTranslationKey]
			v42.title = v43

			v42.Size = v16.itemCardSize

			local v44 = if fFlagAXMigrateSlotsSignals then v20 else v5.slotIndex
			v42.isActive = k == v44

			v42.editorSubcategory = v41.editorSubcategory
			v42.slotType = v41.slotType or slotType.BaseSlot
			function v42.onActivated()
				v8.slotClick(v41)

				if v41.deselectable and k == v20 then
					setSlotIndex(1)
					v24(v21[1])
					v6(module3())
				else
					v24(v41)

					local v45 = v12.current.name == avatarScreen.LookDetails
					v11.navigate(avatarScreen.AvatarEditor, {
						[navigationParams.itemView] = itemView.SlotItems
					})

					if v45 then
						v11.navigate(avatarScreen.LookDetails)
					end

					if not v21[k].deselectable or k ~= v20 then
						setSlotIndex(k)
					end
				end
			end
			v42.hide = v41.hide
			table.insert(slots, v42)
		end

		return v39
	end

	local v40 = if module16 then v21 else nil
	local v41 = if module16 then v16 else nil
	local v42 = if module16 then v17 else nil
	local v43 = if module16 then v18 else nil
	local v44 = if module16 then v5 else nil
	local v45 = if module16 then v12 else nil
	local v46 = if module16 then setSlotIndex else nil
	local v49 = useMemo2(fn5, {
		v20,
		v19,
		v9,
		v22,
		v6,
		v8,
		v7,
		v11,
		v40,
		v41,
		v42,
		v43,
		v44,
		v45,
		v46,
		if module16 then v10 else nil,
		if fFlagAXSlotBasedEditorCategoryTooltip then v38 else nil,
		v23
	})

	local navHeight = v16.navHeight

	if #v49.slots > 0 then
		navHeight += v16.slotCardTotalHeight
	end

	local v50 = {
		slotNavigationProps = v36,
		slotSubNavigationProps = v49,
		ref = ref,
		navigationFrameHeight = navHeight,
		slotSubNavigationFill = fFlagAXSlotsDisableScrollAwayOnLandscape and p2.slotSubNavigationFill or 1,
		slotCardTotalHeight = v16.slotCardTotalHeight,
		navHeight = v16.navHeight,
		disableScrollAway = if fFlagAXSlotsDisableScrollAwayOnLandscape then v37 else nil,
		absoluteSizeChanged = 0,
		hideFilter = 0
	}

	local v52 = if fFlagAXSlotsDisableScrollAwayOnLandscape then p2.absoluteSizeChanged else nil
	v50.absoluteSizeChanged = v52
	v50.hideFilter = v31
	return v50
end

return useSlotProps
