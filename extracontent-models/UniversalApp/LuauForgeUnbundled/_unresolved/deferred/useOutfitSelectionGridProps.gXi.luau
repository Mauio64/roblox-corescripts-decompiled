local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

require("@luauforge/bundled/dHK")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dMd")
local useAvatarEditorStores = require("@luauforge/bundled/fuM").Context.useAvatarEditorStores
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/bundled/dNQ")
local module5 = require("@luauforge/bundled/fvh")

local module6 = require("@luauforge/bundled/ggX")
local module7 = require("@luauforge/deferred/gOP")
local module8 = require("@luauforge/deferred/gnp")
local module9 = require("@luauforge/deferred/gnr")

local module10 = require("@luauforge/deferred/gOO")

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local fFlagAXRefetchInventoryOnUpdate = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate

local getInventoryOutfitType = AvatarExperienceCommon.Utils.getInventoryOutfitType
local getGrantedOutfitIds = AvatarExperienceCommon.Utils.getGrantedOutfitIds
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local module11 = require("@luauforge/bundled/dCh")
local module12 = require("@luauforge/bundled/dwB")
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local module13 = require("@luauforge/deferred/gXj")
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad

local defineFastInt = game:DefineFastInt("AXMaxOutfitSelectionCount", 10)

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled

require("@luauforge/deferred/gXm")

local function selectOutfitInfos(p2)
	return p2.AvatarExperience.AvatarEditor.OutfitInfos
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectHasMoreItemsForListKey(p2)
	return function(p3): boolean
		return not p3.AvatarExperience.AvatarEditor.PageFinished[p2]
	end
end

local function selectGrantedItems(p2)
	return p2.AvatarExperience.AvatarEditor.GrantedItems
end

local function selectOutfitIdsForListKey(p2)
	return function(p3)
		local result = {}

		for k, v5 in p3.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[p2] or {} do
			table.insert(result, (tostring(v5)))
		end

		return result
	end
end

local avatar = module3.OutfitTypes.Avatar

local function useOutfitSelectionGridProps(data)
	local v5 = if data.outfitType == nil then avatar else data.outfitType

	local v6 = data.isEditable == nil or data.isEditable

	local v7 = React.useMemo(function()
		return module5.getOutfitSubtypeKey(v5, v6)
	end, { v5, v6 })

	local v8 = useFocusGuiObject()
	local v9

	if fFlagAXMigrateOutfitsToUserInventory then
		v9 = useAvatarEditorStores().categoryInventoryStores[v7]
	else
		v9 = nil
	end

	local v10

	if not fFlagAXMigrateOutfitsToUserInventory then
		v10 = React.useMemo(function()
			local v11 = v7
			return function(p2): boolean
				return not p2.AvatarExperience.AvatarEditor.PageFinished[v11]
			end
		end, { v7 })
	end

	local v11

	if not fFlagAXMigrateOutfitsToUserInventory then
		v11 = React.useMemo(function()
			local v12 = v7
			return function(p2)
				local result = {}

				for k, v13 in p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v12] or {} do
					table.insert(result, (tostring(v13)))
				end

				return result
			end
		end, { v7 })
	end

	local v12

	if fFlagAXMigrateOutfitsToUserInventory then
		v12 = not useSignalState(v9.getHasReachedLastPage)
	else
		v12 = useSelector(v10)
	end

	local v13 = if fFlagAXMigrateOutfitsToUserInventory then useSignalState(v9.getItems) else nil
	local v14

	if fFlagAXMigrateOutfitsToUserInventory and not fFlagAXRefetchInventoryOnUpdate then
		v14 = useSelector(selectGrantedItems)
	else
		v14 = nil
	end

	local v15

	if fFlagAXMigrateOutfitsToUserInventory and not fFlagAXRefetchInventoryOnUpdate then
		v15 = React.useMemo(function()
			return getGrantedOutfitIds(v14, v5, v6)
		end, { v14, v5, v6 })
	else
		v15 = nil
	end

	local v16

	if fFlagAXMigrateOutfitsToUserInventory then
		v16 = React.useMemo(function()
			local result = {}
			local set = {}

			if v15 then
				for k, v17 in v15 do
					local v18 = tostring(v17)

					if set[v18] then
						continue
					end

					set[v18] = true
					table.insert(result, v18)
				end
			end

			if not v13 then
				return result
			end

			for k, v17 in v13 do
				local itemId = tostring(v17.itemId)

				if set[itemId] then
					continue
				end

				set[itemId] = true
				table.insert(result, itemId)
			end

			return result
		end, { v13, v15 })
	else
		v16 = useSelector(v11)
	end

	local v17 = useSelector(selectOutfitInfos)
	local v18 = useSelector(selectScreenSize)
	local v19

	if fFlagAXAvatarFoldersEnabled then
		v19 = React.useMemo(function()
			if data.itemIdsFilter == nil then
				return v16
			end

			return data.itemIdsFilter(v16)
		end, { v16, data.itemIdsFilter })
	else
		v19 = v16
	end

	local v20 = useAppPolicy(function(p2)
		return p2.getCustomOutfitNames()
	end)

	local v21 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local v22 = if fFlagAXMigrateOutfitsToUserInventory then useNetworking() else nil
	local v23

	if fFlagAXMigrateOutfitsToUserInventory then
		v23 = React.useMemo(function()
			local inventoryOutfitType = getInventoryOutfitType(v5, v6)

			if inventoryOutfitType then
				return {
					SearchUuid = v7,
					InventoryOutfitTypes = { inventoryOutfitType }
				}
			end

			return nil
		end, { v7, v5, v6 })
	else
		v23 = nil
	end

	local v24 = useDispatch()

	local v25, v26 = module9((React.useCallback(function()
		if fFlagAXMigrateOutfitsToUserInventory then
			return v24(module7(v22, v23, nil, v9))
		end

		return v24(module6(v7, v6, nil, v5))
	end, { v24, v22, v23, v9, v7, v5, v6 })))
	local v27 = v25.status == module8.Pending

	if fFlagAXAvatarFoldersEnabled then
		local v28 = not (data.itemIdsFilter == nil) and #v19 == 0
		React.useEffect(function()
			if v28 and v12 and not v27 then
				v26()
			end
		end, { v28, v12, v27, v26 })
	end

	if fFlagAXRefetchInventoryOnUpdate then
		module10(v7, v9, v26)
	end

	local v28 = useLocalization({
		itemType = "Feature.Avatar.Label.Avatars",
		maxSelectionToast = {
			"Feature.Avatar.Toast.MaxOutfitsSelected",
			maxSelectCount = defineFastInt
		},
		loadMore = "Feature.Catalog.Action.LoadMore"
	})

	local v29 = useLocalization({
		noItemsLabel = {
			"Feature.Avatar.Label.NoItems",
			itemType = v28.itemType
		}
	})

	local v30 = {
		itemType = v28.itemType,
		noItemsLabel = v29.noItemsLabel,
		maxSelectionToast = v28.maxSelectionToast,
		loadMore = v28.loadMore
	}

	local v31 = useStyle()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(0)

	local ref4 = React.useRef(data.multiSelect)
	React.useEffect(function()
		if ref4.current == true and data.multiSelect == false then
			data.setSelectedOutfits({})
		end

		ref4.current = data.multiSelect
	end, { data.multiSelect, data.setSelectedOutfits })

	React.useEffect(function()
		local selectedOutfits = {}
		local flag = false

		for k, selectedOutfit in data.selectedOutfits do
			if Cryo.List.find(v19, selectedOutfit) then
				table.insert(selectedOutfits, selectedOutfit)
			else
				flag = true
			end
		end

		if flag then
			data.setSelectedOutfits(selectedOutfits)
		end
	end, { v19, data.selectedOutfits, data.setSelectedOutfits })

	local v32 = React.useCallback(function(list)
		if defineFastInt < #list then
			v24(module11({
				toastMessage = v30.maxSelectionToast,
				isLocalized = true,
				toastType = module12.InformationMessage
			}))
		else
			data.setSelectedOutfits(list)
		end
	end, { v24, data.setSelectedOutfits, v30.maxSelectionToast })

	local v33 = React.useCallback(function()
		if data.setCanScroll then
			local v34 = module4.ItemsGridTopPadding + module4.ItemsGridBottomPadding
			data.setCanScroll(ref3.current + v34 > ref2.current)
		end
	end, { data.setCanScroll })

	local v34 = React.useCallback(function(p2)
		ref2.current = p2.AbsoluteSize.Y
		v33()
	end, { v33 })

	local v35 = React.useCallback(function(p2)
		ref3.current = p2.AbsoluteContentSize.Y
		v33()
	end, { v33 })

	local v36 = React.useCallback(function()
		local v37 = wasLastInputGamepad()
		local v38 = if not (v12 and #v16 == 0) then v16 or nil else nil

		local shimmerCardsToDisplay = module3.ShimmerCardsToDisplay
		local v39 = (v38 and (#v38 or shimmerCardsToDisplay) or shimmerCardsToDisplay) > 0

		if v37 and v39 and v8 and ref.current then
			v8(ref.current)
		end

		v26()
	end, { v12, v16, v8, v26 })

	local v37 = React.useCallback(function(itemId)
		if typeof(itemId) == "table" then
			itemId = nil
		end

		return React.createElement(module13, {
			multiSelect = data.multiSelect ~= nil and data.multiSelect,
			itemId = itemId,
			outfitInfo = v17[tostring(itemId)],
			setSelectedOutfits = v32,
			selectedOutfits = data.selectedOutfits,
			onToggleOutfitCard = data.onToggleOutfitCard
		})
	end, {
		data.selectedOutfits,
		data.multiSelect,
		data.onToggleOutfitCard,
		data.setSelectedOutfits,
		v17,
		v32
	})

	return {
		goBack = data.goBack,
		pageOwner = data.pageOwner,
		forwardRef = data.forwardRef,
		showCustomOutfitNames = v20,
		enableContinuousLoad = v21,
		outfitIds = v19,
		screenSize = v18,
		hasMoreItems = v12,
		loadMoreItems = v26,
		isFetchingMore = v27,
		localized = v30,
		loadableGridViewRef = ref,
		stylePalette = v31,
		absoluteSizeChanged = v34,
		contentSizeChanged = v35,
		onLoadMoreButtonActivated = v36,
		renderItem = v37,
		bottomContentPadding = data.bottomContentPadding
	}
end

return useOutfitSelectionGridProps
