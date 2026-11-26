local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local AvatarExperienceSave = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceSave")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceCommon")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/SignalsReact")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Navigation")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceNavigation")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceAnalytics")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/ToastRodux")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/tutils")

local iconName = Foundation.Enums.IconName

local fFlagAXExtendUndoRedoTracking = AvatarExperienceFlags.FFlagAXExtendUndoRedoTracking

local fFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local fFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

local slotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local toastType = ToastRodux.Enums.ToastType

local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local useTokens = Foundation.Hooks.useTokens

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/RoactUtils").Hooks.RoactRodux.useDispatch
local useAvatarSaveContext = AvatarExperienceSave.Context.useAvatarSaveContext
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local clearScreens = AvatarExperienceNavigation.Actions.ClearScreens

local MenuItemEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Enums/MenuItemEnum")

local selectCharacterData = if fFlagAXResetAvatarButton then AvatarExperienceSave.Selectors.selectCharacterData else nil
local clearTryOns = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceRodux").Actions.ClearTryOns

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Constants")

local v5 = fFlagAXResetAvatarButton
	and {
		toastMessage = "Feature.Avatar.Message.OutfitCleared",
		isLocalized = false,
		toastType = toastType.SuccessConfirmation
	}
	or nil

local function useUndoRedoBarViewModel()
	local v6 = useNavigation()
	local v7 = useDispatch()
	local v8 = if fFlagAXMigrateBuilderIcons then useTokens() else nil
	local v9 = useAvatarSaveContext()
	local getHistorySignal = v9.getHistorySignal
	local getCurrentHistoryIndexSignal = v9.getCurrentHistoryIndexSignal
	local v10

	if fFlagAXResetAvatarButton then
		v10 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	else
		v10 = nil
	end

	local v11 = if fFlagAXExtendUndoRedoTracking then useAvatarRoute() else nil
	local v12 = SignalsReact.useSignalState(getHistorySignal)
	local v13 = SignalsReact.useSignalState(getCurrentHistoryIndexSignal)

	local v14 = if fFlagAXResetAvatarButton then SignalsReact.useSignalState(v10) else nil

	local v15 = React.useMemo(function(): boolean
		local v16 = v13

		if v16 and v12 then
			return v16 == 1
		end

		return true
	end, { v13, v12 })

	local v16 = React.useMemo(function(): boolean
		local v17 = v13

		if v17 and v12 then
			return v17 == #v12
		end

		return true
	end, { v13, v12 })
	local v17

	if fFlagAXResetAvatarButton then
		v17 = React.useMemo(function(): boolean
			if
				v14
				and v14.tryOn
				and v14.tryOn.OutfitTryOn
				and next(v14.tryOn.OutfitTryOn.TryOnItems) ~= nil
			then
				return false
			end

			if not (v14 and v14.equipped and v14.equipped.EquippedAssets) then
				return true
			end

			for k in v14.equipped.EquippedAssets do
				if table.find(Constants.AssetTypeStringsToKeep, k) == nil then
					return false
				end
			end

			return true
		end, { v14, v12 })
	else
		v17 = nil
	end

	local v18 = React.useCallback(function(p2)
		local v19 = v9 and v9.updateHistoryIndexAndGetCharacterData(v13 + (p2 and -1 or 1))

		if v19 then
			local trackUndoRedoClick = slotBasedEditorAnalytics.trackUndoRedoClick

			local v20 = if fFlagAXExtendUndoRedoTracking and v11 and v11.opaque then v11.opaque.name else nil
			trackUndoRedoClick(p2, v20)

			v7(characterHistoryStateChangeButtonActivated({
				isUndo = p2,
				equipped = v19.equipped,
				tryOn = v19.tryOn
			}))

			v6.dispatch(clearScreens({ avatarScreen.LookDetails }))
		end
	end, { v7, v9, v13, v6, v11, v12 })
	local v19

	if fFlagAXResetAvatarButton then
		v19 = React.useCallback(function()
			local v20 = v10(false)

			if v20 then
				if slotBasedEditorAnalytics.trackAvatarRemoveAllClick and v11 and v11.opaque then
					slotBasedEditorAnalytics.trackAvatarRemoveAllClick(v11.opaque.name)
				end

				local v21 = {}

				for k, v22 in Constants.AssetTypeStringsToKeep do
					v21[v22] = v20.equipped.EquippedAssets[v22]
				end

				v20.equipped.EquippedAssets = v21

				v7(characterHistoryStateChangeButtonActivated(v20))

				v7(clearTryOns())

				v7(setCurrentToastMessage(v5))
			end
		end, { v7 })
	else
		v19 = nil
	end

	if fFlagAXExtendUndoRedoTracking then
		React.useEffect(function()
			if slotBasedEditorAnalytics.trackUndoHistoryCount and v11 and v11.opaque and v12 and #v12 then
				slotBasedEditorAnalytics.trackUndoHistoryCount(v11.opaque.name, #v12)
			end
		end, { v12, v11 })
	end

	return {
		items = React.useMemo(function()
			if fFlagAXResetAvatarButton then
				return {
					{
						type = "icon",
						id = MenuItemEnum.Reset.Reset,
						icon = iconName.ArrowSpinClockwise,
						iconSize = v8.Size.Size_500,
						isActive = false,
						onActivated = function()
							v19()
						end,
						disabled = v17
					},
					{
						type = "icon",
						id = MenuItemEnum.Undo,
						icon = not fFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or iconName.ArrowCurlToLeft,
						onActivated = function()
							v18(true)
						end,
						disabled = v15,
						isActive = false
					},
					{
						type = "icon",
						id = MenuItemEnum.Redo,
						icon = not fFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or iconName.ArrowCurlToRight,
						onActivated = function()
							v18(false)
						end,
						disabled = v16,
						isActive = false
					}
				}
			end

			return {
				{
					type = "icon",
					id = MenuItemEnum.Undo,
					icon = not fFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or iconName.ArrowCurlToLeft,
					onActivated = function()
						v18(true)
					end,
					disabled = v15,
					isActive = false
				},
				{
					type = "icon",
					id = MenuItemEnum.Redo,
					icon = not fFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or iconName.ArrowCurlToRight,
					onActivated = function()
						v18(false)
					end,
					disabled = v16,
					isActive = false
				}
			}
		end, fFlagAXResetAvatarButton and { v15, v16, v17, v18, v19 } or { v15, v16, v18 })
	}
end

return useUndoRedoBarViewModel
