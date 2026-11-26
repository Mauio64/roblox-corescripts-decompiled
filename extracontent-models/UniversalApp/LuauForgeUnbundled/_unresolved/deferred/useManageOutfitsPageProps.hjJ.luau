local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local canGoBack = require("@game/CorePackages/Workspace/Packages/Navigation").canGoBack
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/dXh")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local module4 = require("@luauforge/bundled/ehL")
require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = module4.FocusNavigationEventNameEnum
local useFocusNavigableSurfaceRegistryConnection = module4.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum

local module5 = require("@luauforge/deferred/hjF")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local useFocusOnMountEffect = AvatarExperienceCommon.Hooks.useFocusOnMountEffect

require("@luauforge/deferred/hjI")

local module7 = require("@luauforge/bundled/dPN")

local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled
local useFolderItemIdsFilter

if fFlagAXAvatarFoldersEnabled then
	useFolderItemIdsFilter = require("@luauforge/deferred/gNB").Hooks.useFolderItemIdsFilter
else
	useFolderItemIdsFilter = nil
end

local function useManageOutfitsPageProps()
	local v5 = useNavigation()
	local v6 = useDispatch()
	local state, setState = React.useState({})

	local v7 = {
		title = "Feature.Avatar.Heading.Manage",
		selectAction = "Feature.Avatar.Action.Select",
		cancelAction = "Feature.Avatar.Action.Cancel",
		deleteButtonText = "Feature.Avatar.Action.Delete",
		selectedLabelText = {
			"Feature.Avatar.Label.CountSelected",
			itemCount = #state
		}
	}

	if fFlagAXAvatarFoldersEnabled then
		v7.removeFromFolderAction = "Feature.Avatar.Action.RemoveFromSet"
		v7.deleteAvatarsAction = "Feature.Avatar.Action.DeleteAvatars"
	end

	local v8 = useLocalization(v7)

	local v9 = v5.getParam("outfitType")

	if not v9 then
		v9 = module7.OutfitTypes.Avatar
		mutedError("outfitType is required")
	end

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)

	local v10 = React.useCallback(function()
		if canGoBack(v5) then
			v5.goBack()
		end
	end, { v5 })

	local v11 = React.useCallback(function()
		setState({})
	end, {})
	local v12

	if not fFlagAXAvatarFoldersEnabled then
		v12 = React.useCallback(function()
			v5.navigate(avatarScreen.BulkDeleteOutfitDialog, {
				outfitIds = state,
				onOverlayClosed = function()
					if state2 then
						setState2(false)
						setState({})
					end
				end
			})
		end, { v5, state, state2 })
	end

	local v13 = React.useCallback(function(p2, p3)
		if p2 and p3 then
			local v14 = { outfitId = p3, onPeekViewClosed = v11, onClose = v11 }

			v6(navigateWithLock(function()
				module2.closeFiltersAndItemDetails(v5)
				module2.closeTryOnManager(v5)
				v5.navigate(avatarScreen.OutfitDetails, v14)
			end))
		else
			module2.closeFiltersAndItemDetails(v5)
		end
	end, { v6, v5, v11 })

	local v14 = React.useCallback(function()
		setState2(function(p2): boolean
			return not p2
		end)

		module2.closeFiltersAndItemDetails(v5)
	end, { v5 })
	local itemIdsFilter, v15, v16

	if fFlagAXAvatarFoldersEnabled then
		local v17 = useFolderItemIdsFilter()
		local v18 = v9 == module7.OutfitTypes.Avatar

		local selectedFolderId = if v18 then v17.selectedFolderId else nil

		if selectedFolderId ~= nil then
			itemIdsFilter = v17.itemIdsFilter
		end

		local v19 = React.useCallback(function()
			if state2 then
				setState2(false)
				setState({})
			end
		end, { state2 })

		local state3, setState3 = React.useState(false)

		v12 = React.useCallback(function()
			if selectedFolderId == nil then
				v5.navigate(avatarScreen.BulkDeleteOutfitDialog, {
					outfitIds = state,
					onOverlayClosed = v19
				})
			else
				setState3(true)
			end
		end, { v5, state, selectedFolderId, v19 })

		local v20 = React.useCallback(function(p2)
			setState3(false)

			if p2 == "removeFromFolder" then
				v5.navigate(avatarScreen.RemoveFromFolderDialog, {
					outfitIds = state,
					folderId = selectedFolderId,
					onOverlayClosed = v19
				})
			elseif p2 == "deleteAvatars" then
				v5.navigate(avatarScreen.BulkDeleteOutfitDialog, {
					outfitIds = state,
					onOverlayClosed = v19
				})
			end
		end, { v5, state, selectedFolderId, v19 })

		local v21 = React.useCallback(function()
			setState3(false)
		end, {})

		local v22 = React.useMemo(function()
			return {
				{ id = "removeFromFolder", text = v8.removeFromFolderAction },
				{ id = "deleteAvatars", text = v8.deleteAvatarsAction }
			}
		end, { v8.removeFromFolderAction, v8.deleteAvatarsAction })

		v15 = React.useCallback(function()
			v5.navigate(avatarScreen.SelectFolderMenu, { outfitIds = state })
		end, { v5, state })

		if not v18 then
			v15 = nil
		end

		if selectedFolderId ~= nil then
			v16 = {
				isOpen = state3,
				items = v22,
				onItemActivated = v20,
				onPressedOutside = v21
			}
		end
	end

	local v17 = useAppPolicy(function(p2)
		return p2.getCustomOutfitNames()
	end)

	local ref2 = React.useRef(nil)

	local state3, setState3 = React.useState(nil)

	local v18 = not state2 and v17 and #state == 1

	local v19 = React.useCallback(function()
		setState2(true)
		module2.closeFiltersAndItemDetails(v5)
	end, { v5 })

	local v20 = React.useCallback(function()
		setState2(false)
		module2.closeFiltersAndItemDetails(v5)
	end, { v5 })

	local v21 = React.useCallback(function()
		if state and state[1] then
			v5.navigate(avatarScreen.RenameOutfitDialog, {
				outfitId = state[1],
				onOverlayClosed = function() end
			})
		else
			mutedError("Tried to rename an outfit with no outfit selected", state)
		end
	end, { v5, state })

	local v22 = React.useMemo(function()
		local v23 = {
			[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
		}
		local buttonL3 = Enum.KeyCode.ButtonL3
		local v24 = if state2 then focusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect else focusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect
		v23[buttonL3] = v24

		v23[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.ManageOutfitsDelete
		v23[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.ManageOutfitsRename
		return v23
	end, { state2 })

	if state2 then
		v19 = nil
	end

	if not state2 then
		v20 = nil
	end

	local v25 = if #state > 0 then v12 else nil

	if not v18 then
		v21 = nil
	end

	local v26 = module5(ref2, v22, {
		onGoBack = v10,
		onToggleMultiselect = v19,
		onCancelMultiselect = v20,
		onDelete = v25,
		onRename = v21
	})

	local v27 = React.useCallback(function(current)
		ref2.current = current
		setState3(current)

		if typeof(v26) == "function" then
			v26(current)
		elseif v26 ~= nil then
			v26.current = current
		end
	end, { v26 })

	useFocusNavigableSurfaceRegistryConnection(state3, focusNavigableSurfaceIdentifierEnum.SubRouterView)
	useFocusOnMountEffect(ref2)

	if not fFlagAXAvatarFoldersEnabled then
		itemIdsFilter = nil
	end

	local v29 = {
		title = v8.title,
		selectActionText = 0,
		deleteButtonText = 0,
		selectedLabelText = 0
	}
	local v30 = if state2 then v8.cancelAction else v8.selectAction
	v29.selectActionText = v30
	v29.deleteButtonText = v8.deleteButtonText
	v29.selectedLabelText = v8.selectedLabelText
	local v28 = {
		outfitType = v9,
		itemIdsFilter = itemIdsFilter,
		localized = v29,
		onBackActivated = v10,
		onSelectActivated = v14,
		selectedOutfits = state,
		setSelectedOutfits = setState,
		onToggleOutfitCard = v13,
		multiSelect = state2,
		gridRef = ref,
		onDeleteActivated = v12,
		focusNavigationRef = v27,
		onAddToFolderActivated = nil,
		trashMenu = nil
	}

	if not fFlagAXAvatarFoldersEnabled then
		v15 = nil
	end

	v28.onAddToFolderActivated = v15

	if not fFlagAXAvatarFoldersEnabled then
		v16 = nil
	end

	v28.trashMenu = v16
	return v28
end

return useManageOutfitsPageProps
