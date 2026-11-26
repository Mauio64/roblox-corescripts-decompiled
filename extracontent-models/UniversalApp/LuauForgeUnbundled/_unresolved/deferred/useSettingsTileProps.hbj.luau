local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
require(CorePackages.Packages.Foundation)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module3 = require("@luauforge/bundled/ehL")
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module4 = require("@luauforge/deferred/gNu")
local useAppFocusRoot = module3.useAppFocusRoot

local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled
local useFolderSettingsActions

if fFlagAXAvatarFoldersEnabled then
	useFolderSettingsActions = require("@luauforge/deferred/gNB").Hooks.useFolderSettingsActions
else
	useFolderSettingsActions = nil
end

local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local module5 = require("@luauforge/bundled/dPN")

local module6 = require("@luauforge/deferred/hbk")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local v5 = {
	[module5.OutfitTypes.Avatar] = {
		add = "Feature.Avatar.Label.Title.AddNewAvatar",
		manage = "Feature.Avatar.Label.Title.ManageAvatars",
		update = "Feature.Avatar.Label.Title.UpdateAvatar"
	},
	[module5.OutfitTypes.Makeup] = {
		add = "Feature.Avatar.Action.AddNewMakeupLook",
		manage = "Feature.Avatar.Action.ManageMakeupLooks",
		update = "Feature.Avatar.Action.UpdateExistingMakeupLook"
	}
}

local function useSettingsTileProps(data, p2)
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = Responsive.usePreferredInput()
	local v9 = ReactFocusNavigation.useFocusGuiObject()

	local state, setState = React.useState(false)

	local v10 = useSelector(function(p3)
		return p3.AvatarExperience.AvatarEditor.OutfitInfos
	end)

	local v12 = useSelector((React.useCallback(function(p3)
		return module6(p3, data.outfitType)
	end, { data.outfitType })))

	local v13 = React.useMemo(function()
		local v14 = v10[tostring(v12)]

		if v14 then
			return v14.name
		end

		return nil
	end, { v12, v10 })

	local v14 = {
		add = v5[data.outfitType].add,
		manage = v5[data.outfitType].manage,
		update = v5[data.outfitType].update
	}

	if fFlagAXAvatarFoldersEnabled then
		v14.renameFolder = "Feature.Avatar.Action.RenameSet"
		v14.deleteFolder = "Feature.Avatar.Action.DeleteSet"
	end

	local v15 = useLocalization(v14)

	local v16 = if fFlagAXAvatarFoldersEnabled then useFolderSettingsActions() else nil

	if not (fFlagAXAvatarFoldersEnabled and data.showFolders) then
		v16 = nil
	end

	local v17 = React.useCallback(function(p3)
		if v8 == Responsive.Input.Directional then
			v9(p3)
		end
	end, { v8, v9 })

	local v18 = React.useCallback(function()
		v17(p2.current)
	end, { v17, p2 })

	local v19 = React.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, { setState })

	local v20 = module4(v7, data.outfitType, v18, false)

	local v21 = React.useCallback(function(p3)
		return function()
			v7.navigate(avatarScreen.DuplicateOutfitDialog, {
				outfitType = data.outfitType,
				duplicateOutfitName = v13,
				saveAsNew = p3,
				onOverlayClosed = v18
			})
		end
	end, { v7, data.outfitType, v13, v18 })

	local function fn(p3)
		setState(false)

		if fFlagAXAvatarFoldersEnabled and v16 then
			if p3 == "renameFolder" then
				v6(navigateWithLock(function()
					v7.navigate(avatarScreen.RenameFolderDialog, {
						onSubmit = v16.renameFolder,
						currentName = v16.folderName,
						checkIsDuplicateFolderName = v16.checkIsDuplicateFolderName
					})
				end))
				return
			elseif p3 == "deleteFolder" then
				v6(navigateWithLock(function()
					v7.navigate(avatarScreen.DeleteFolderPrompt, {
						onDeleteFolder = v16.deleteFolder
					})
				end))
				return
			end
		end

		if p3 == "add" then
			if v12 then
				v6(navigateWithLock(v21(true)))
			else
				v20()
			end
		elseif p3 == "manage" then
			v6(navigateWithLock(function()
				v7.navigate(avatarScreen.ManageOutfitsPage, {
					outfitType = data.outfitType
				})
			end))
		elseif p3 == "update" then
			v6(navigateWithLock(function()
				v7.navigate(avatarScreen.UpdateOutfitPage, {
					outfitType = data.outfitType
				})
			end))
		end
	end

	local v24 = React.useCallback(fn, {
		v6,
		v7,
		v21,
		v20,
		setState,
		v12,
		data.outfitType,
		if fFlagAXAvatarFoldersEnabled then v16 else nil
	})

	local v25 = React.useCallback(function()
		setState(false)
	end, { setState })

	local ref = React.useRef(state)
	React.useEffect(function()
		local current = ref.current
		ref.current = state

		if current and not state then
			v17(p2.current)
		end
	end, { state, v17, p2 })

	local v29 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v25()
					object:cancel()
				end)
			}
		},
		isAutoFocusRoot = true,
		isFocusable = state
	})

	local function fn2()
		local v30 = {
			{ id = "add", text = v15.add },
			{ id = "update", text = v15.update },
			{ id = "manage", text = v15.manage }
		}

		if fFlagAXAvatarFoldersEnabled and v16 then
			return {
				{ items = v30 },
				{
					items = {
						{ id = "renameFolder", text = v15.renameFolder },
						{ id = "deleteFolder", text = v15.deleteFolder }
					}
				}
			}
		end

		return v30
	end

	local v32 = React.useMemo(fn2, { v15, if fFlagAXAvatarFoldersEnabled then v16 else nil })

	local v33 = {
		outfitType = data.outfitType,
		itemWidth = data.itemWidth,
		index = data.index,
		squareAspectRatio = data.squareAspectRatio,
		onTileActivated = 0,
		onMenuItemActivated = 0,
		onPressedOutside = 0,
		items = 0,
		isOpen = 0,
		menuRef = 0
	}

	if state then
		v19 = nil
	end

	v33.onTileActivated = v19
	v33.onMenuItemActivated = v24
	v33.onPressedOutside = v25
	v33.items = v32
	v33.isOpen = state
	v33.menuRef = v29
	return v33
end

return useSettingsTileProps
