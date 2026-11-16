local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
require(CorePackages.Packages.Foundation)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module3 = require("@luauforge/bundled/eeo")
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module4 = require("@luauforge/deferred/giO")
local useAppFocusRoot = module3.useAppFocusRoot

local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled
local useFolderSettingsActions

if fFlagAXAvatarFoldersEnabled then
	useFolderSettingsActions = require("@luauforge/deferred/giV").Hooks.useFolderSettingsActions
else
	useFolderSettingsActions = nil
end

local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local module5 = require("@luauforge/bundled/dMx")

local module6 = require("@luauforge/deferred/gPh")
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

	local v11 = useSelector((React.useCallback(function(p3)
		return module6(p3, data.outfitType)
	end, { data.outfitType })))

	local v12 = React.useMemo(function()
		local v13 = v10[tostring(v11)]

		if v13 then
			return v13.name
		end

		return nil
	end, { v11, v10 })

	local v13 = {
		add = v5[data.outfitType].add,
		manage = v5[data.outfitType].manage,
		update = v5[data.outfitType].update
	}

	if fFlagAXAvatarFoldersEnabled then
		v13.renameFolder = "Feature.Avatar.Action.RenameSet"
		v13.deleteFolder = "Feature.Avatar.Action.DeleteSet"
	end

	local v14 = useLocalization(v13)

	local v15 = if fFlagAXAvatarFoldersEnabled then useFolderSettingsActions() else nil

	if not (fFlagAXAvatarFoldersEnabled and data.showFolders) then
		v15 = nil
	end

	local v16 = React.useCallback(function(p3)
		if v8 == Responsive.Input.Directional then
			v9(p3)
		end
	end, { v8, v9 })

	local v17 = React.useCallback(function()
		v16(p2.current)
	end, { v16, p2 })

	local v18 = React.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, { setState })

	local v19 = module4(v7, data.outfitType, v17, false)

	local v20 = React.useCallback(function(p3)
		return function()
			v7.navigate(avatarScreen.DuplicateOutfitDialog, {
				outfitType = data.outfitType,
				duplicateOutfitName = v12,
				saveAsNew = p3,
				onOverlayClosed = v17
			})
		end
	end, { v7, data.outfitType, v12, v17 })

	local function fn(p3)
		setState(false)

		if fFlagAXAvatarFoldersEnabled and v15 then
			if p3 == "renameFolder" then
				v6(navigateWithLock(function()
					v7.navigate(avatarScreen.RenameFolderDialog, {
						onSubmit = v15.renameFolder,
						currentName = v15.folderName,
						checkIsDuplicateFolderName = v15.checkIsDuplicateFolderName
					})
				end))
				return
			elseif p3 == "deleteFolder" then
				v6(navigateWithLock(function()
					v7.navigate(avatarScreen.DeleteFolderPrompt, {
						onDeleteFolder = v15.deleteFolder
					})
				end))
				return
			end
		end

		if p3 == "add" then
			if v11 then
				v6(navigateWithLock(v20(true)))
			else
				v19()
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

	local v23 = React.useCallback(fn, {
		v6,
		v7,
		v20,
		v19,
		setState,
		v11,
		data.outfitType,
		if fFlagAXAvatarFoldersEnabled then v15 else nil
	})

	local v24 = React.useCallback(function()
		setState(false)
	end, { setState })

	local ref = React.useRef(state)
	React.useEffect(function()
		local current = ref.current
		ref.current = state

		if current and not state then
			v16(p2.current)
		end
	end, { state, v16, p2 })

	local v28 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v24()
					object:cancel()
				end)
			}
		},
		isAutoFocusRoot = true,
		isFocusable = state
	})

	local function fn2()
		local v29 = {
			{ id = "add", text = v14.add },
			{ id = "update", text = v14.update },
			{ id = "manage", text = v14.manage }
		}

		if fFlagAXAvatarFoldersEnabled and v15 then
			return {
				{ items = v29 },
				{
					items = {
						{ id = "renameFolder", text = v14.renameFolder },
						{ id = "deleteFolder", text = v14.deleteFolder }
					}
				}
			}
		end

		return v29
	end

	local v31 = React.useMemo(fn2, { v14, if fFlagAXAvatarFoldersEnabled then v15 else nil })

	local v32 = {
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
		v18 = nil
	end

	v32.onTileActivated = v18
	v32.onMenuItemActivated = v23
	v32.onPressedOutside = v24
	v32.items = v31
	v32.isOpen = state
	v32.menuRef = v28
	return v32
end

return useSettingsTileProps
