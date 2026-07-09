local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local AvatarExperienceSave = require(AvatarExperienceControlBarParent.AvatarExperienceSave)
local AvatarExperienceCommon = require(AvatarExperienceControlBarParent.AvatarExperienceCommon)
local SignalsReact = require(AvatarExperienceControlBarParent.SignalsReact)
local Navigation = require(AvatarExperienceControlBarParent.Navigation)
local AvatarExperienceNavigation = require(AvatarExperienceControlBarParent.AvatarExperienceNavigation)
local AvatarExperienceAnalytics = require(AvatarExperienceControlBarParent.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(AvatarExperienceControlBarParent.AvatarExperienceFlags)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local ToastRodux = require(AvatarExperienceControlBarParent.ToastRodux)
local tutils = require(AvatarExperienceControlBarParent.tutils)
local IconName = Foundation.Enums.IconName
local FFlagAXExtendUndoRedoTracking = AvatarExperienceFlags.FFlagAXExtendUndoRedoTracking
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local ToastType = ToastRodux.Enums.ToastType
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local useTokens = Foundation.Hooks.useTokens
local useDispatch = require(AvatarExperienceControlBarParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAvatarSaveContext = AvatarExperienceSave.Context.useAvatarSaveContext
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local ClearScreens = AvatarExperienceNavigation.Actions.ClearScreens
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local MenuItemEnum = require(AvatarExperienceControlBar.Enums.MenuItemEnum)
local v33 = if not FFlagAXResetAvatarButton then nil else AvatarExperienceSave.Selectors.selectCharacterData
local ClearTryOns = require(AvatarExperienceControlBarParent.AvatarExperienceRodux).Actions.ClearTryOns

require(AvatarExperienceControlBar.ControlBarTypes)

local Constants = require(AvatarExperienceControlBar.Constants)
local v36 = if not FFlagAXResetAvatarButton then nil else {
	toastMessage = "Feature.Avatar.Message.OutfitCleared",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local function useUndoRedoBarViewModel() -- line: 61
	-- upvalues: useNavigation (copy), useDispatch (copy), FFlagAXMigrateBuilderIcons (copy), useTokens (copy), useAvatarSaveContext (copy), FFlagAXResetAvatarButton (copy), useSelectorSignal (copy), v33 (copy), tutils (copy), FFlagAXExtendUndoRedoTracking (copy), useAvatarRoute (copy), SignalsReact (copy), React (copy), FFlagDynamicHeadsMigration (copy), Constants (copy), SlotBasedEditorAnalytics (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy), ClearScreens (copy), ClearTryOns (copy), SetCurrentToastMessage (copy), v36 (copy), MenuItemEnum (copy), IconName (copy)
	local v38 = useNavigation()
	local v39 = useDispatch()
	local v40 = if not FFlagAXMigrateBuilderIcons then nil else useTokens()
	local v41 = useAvatarSaveContext()
	local getHistorySignal = v41.getHistorySignal
	local getCurrentHistoryIndexSignal = v41.getCurrentHistoryIndexSignal
	local v44 = if not FFlagAXResetAvatarButton then nil else useSelectorSignal(v33, tutils.deepEqual)
	local v45 = if not FFlagAXExtendUndoRedoTracking then nil else useAvatarRoute()
	local v46 = SignalsReact.useSignalState(getHistorySignal)
	local v47 = SignalsReact.useSignalState(getCurrentHistoryIndexSignal)
	local v48 = if not FFlagAXResetAvatarButton then nil else SignalsReact.useSignalState(v44)
	local v49 = React.useMemo(function() -- line: 86
		-- upvalues: v47 (copy), v46 (copy)
		local v54 = v47

		if v54 and v46 then
			return v54 == 1
		end

		return true
	end, {
		v47,
		v46
	})
	local v50 = React.useMemo(function() -- line: 94
		-- upvalues: v47 (copy), v46 (copy)
		local v55 = v47

		if v55 and v46 then
			return v55 == #v46
		end

		return true
	end, {
		v47,
		v46
	})
	local v51 = if not FFlagAXResetAvatarButton then nil else React.useMemo(function() -- line: 103
		-- upvalues: FFlagDynamicHeadsMigration (copy), v48 (copy), Constants (copy)
		if FFlagDynamicHeadsMigration then
			if v48 and v48.tryOn and v48.tryOn.OutfitTryOn and next(v48.tryOn.OutfitTryOn.TryOnItems) ~= nil then
				return false
			end

			if not v48 or not v48.equipped or not v48.equipped.EquippedAssets then
				return true
			end

			for v56 in v48.equipped.EquippedAssets do
				if table.find(Constants.AssetTypeStringsToKeep, v56) == nil then
					return false
				end
			end

			return true
		end

		if next(v48.tryOn.OutfitTryOn.TryOnItems) ~= nil then
			return false
		end

		for v57 in v48.equipped.EquippedAssets do
			if table.find(Constants.AssetTypeStringsToKeep, v57) == nil then
				return false
			end
		end

		return true
	end, {
		v48,
		v46
	})
	local v52 = React.useCallback(function(b1: boolean) -- line: 142
		-- upvalues: v41 (copy), v47 (copy), SlotBasedEditorAnalytics (copy), FFlagAXExtendUndoRedoTracking (copy), v45 (copy), v39 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagAXMISEnableMultiShopping (copy), v38 (copy), AvatarScreen (copy), ClearScreens (copy)
		if v41 then
			local v59 = v41.updateHistoryIndexAndGetCharacterData(v47 + (not b1 and 1 or -1))

			if v59 then
				SlotBasedEditorAnalytics.trackUndoRedoClick(b1, if not FFlagAXExtendUndoRedoTracking or (not v45 or not v45.opaque) then nil else v45.opaque.name)
				v39(CharacterHistoryStateChangeButtonActivated({
					isUndo = b1,
					equipped = v59.equipped,
					tryOn = v59.tryOn
				}))

				if v59.tryOn.OutfitTryOn and v59.tryOn.OutfitTryOn.LookId ~= nil and v59.tryOn.OutfitTryOn.LookId ~= "" and not FFlagAXMISEnableMultiShopping then
					v38.navigate(AvatarScreen.LookDetails)

					return
				end

				v38.dispatch(ClearScreens({ AvatarScreen.LookDetails }))
			end
		end
	end, {
		v39,
		v41,
		v47,
		v38,
		v45,
		v46
	})
	local v53 = if not FFlagAXResetAvatarButton then nil else React.useCallback(function() -- line: 179
		-- upvalues: v44 (copy), SlotBasedEditorAnalytics (copy), v45 (copy), Constants (copy), v39 (copy), CharacterHistoryStateChangeButtonActivated (copy), ClearTryOns (copy), SetCurrentToastMessage (copy), v36 (copy)
		local v60 = v44(false)

		if v60 then
			if SlotBasedEditorAnalytics.trackAvatarRemoveAllClick and v45 and v45.opaque then
				SlotBasedEditorAnalytics.trackAvatarRemoveAllClick(v45.opaque.name)
			end

			local t1 = {}

			for _, v63 in Constants.AssetTypeStringsToKeep do
				t1[v63] = v60.equipped.EquippedAssets[v63]
			end

			v60.equipped.EquippedAssets = t1
			v39(CharacterHistoryStateChangeButtonActivated(v60))
			v39(ClearTryOns())
			v39(SetCurrentToastMessage(v36))
		end
	end, { v39 })

	if FFlagAXExtendUndoRedoTracking then
		React.useEffect(function() -- line: 209
			-- upvalues: SlotBasedEditorAnalytics (copy), v45 (copy), v46 (copy)
			if SlotBasedEditorAnalytics.trackUndoHistoryCount and (v45 and v45.opaque and v46 and #v46) then
				SlotBasedEditorAnalytics.trackUndoHistoryCount(v45.opaque.name, #v46)
			end
		end, {
			v46,
			v45
		})
	end

	return {
		items = React.useMemo(function() -- line: 224
			-- upvalues: FFlagAXResetAvatarButton (copy), MenuItemEnum (copy), IconName (copy), v40 (copy), v53 (copy), v51 (copy), FFlagAXMigrateBuilderIcons (copy), v52 (copy), v49 (copy), v50 (copy)
			if FFlagAXResetAvatarButton then
				return {
					{
						type = "icon",
						isActive = false,
						id = MenuItemEnum.Reset.Reset,
						icon = IconName.ArrowSpinClockwise,
						iconSize = v40.Size.Size_500,
						onActivated = function() -- line: 233
							-- upvalues: v53 (copy)
							v53()
						end,
						disabled = v51
					},
					{
						type = "icon",
						isActive = false,
						id = MenuItemEnum.Undo,
						icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or IconName.ArrowCurlToLeft,
						onActivated = function() -- line: 244
							-- upvalues: v52 (copy)
							v52(true)
						end,
						disabled = v49
					},
					{
						type = "icon",
						isActive = false,
						id = MenuItemEnum.Redo,
						icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or IconName.ArrowCurlToRight,
						onActivated = function() -- line: 256
							-- upvalues: v52 (copy)
							v52(false)
						end,
						disabled = v50
					}
				}
			end

			return {
				{
					type = "icon",
					isActive = false,
					id = MenuItemEnum.Undo,
					icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or IconName.ArrowCurlToLeft,
					onActivated = function() -- line: 271
						-- upvalues: v52 (copy)
						v52(true)
					end,
					disabled = v49
				},
				{
					type = "icon",
					isActive = false,
					id = MenuItemEnum.Redo,
					icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or IconName.ArrowCurlToRight,
					onActivated = function() -- line: 283
						-- upvalues: v52 (copy)
						v52(false)
					end,
					disabled = v50
				}
			}
		end, if not FFlagAXResetAvatarButton then {
			v49,
			v50,
			v52
		} else {
			v49,
			v50,
			v51,
			v52,
			v53
		})
	}
end

return useUndoRedoBarViewModel
