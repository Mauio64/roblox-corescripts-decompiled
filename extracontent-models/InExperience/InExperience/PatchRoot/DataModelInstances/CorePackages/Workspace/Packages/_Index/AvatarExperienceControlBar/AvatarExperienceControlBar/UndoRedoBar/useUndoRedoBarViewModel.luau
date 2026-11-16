local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local AvatarExperienceSave = require(parent.AvatarExperienceSave)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local SignalsReact = require(parent.SignalsReact)
local Navigation = require(parent.Navigation)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local Foundation = require(parent.Foundation)
local ToastRodux = require(parent.ToastRodux)
local tutils = require(parent.tutils)

local IconName = Foundation.Enums.IconName

local FFlagAXExtendUndoRedoTracking = AvatarExperienceFlags.FFlagAXExtendUndoRedoTracking

local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local ToastType = ToastRodux.Enums.ToastType

local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local useTokens = Foundation.Hooks.useTokens

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAvatarSaveContext = AvatarExperienceSave.Context.useAvatarSaveContext
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local ClearScreens = AvatarExperienceNavigation.Actions.ClearScreens

local MenuItemEnum = require(AvatarExperienceControlBar.Enums.MenuItemEnum)
local selectCharacterData

if FFlagAXResetAvatarButton then
	selectCharacterData = AvatarExperienceSave.Selectors.selectCharacterData
else
	selectCharacterData = nil
end

local AvatarExperienceRodux = require(parent.AvatarExperienceRodux)
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns

require(AvatarExperienceControlBar.ControlBarTypes)
local Constants = require(AvatarExperienceControlBar.Constants)

local v = FFlagAXResetAvatarButton
	and {
		toastMessage = "Feature.Avatar.Message.OutfitCleared",
		isLocalized = false,
		toastType = ToastType.SuccessConfirmation
	}
	or nil

local function useUndoRedoBarViewModel()
	local v2 = useNavigation()
	local v3 = useDispatch()
	local v4

	if FFlagAXMigrateBuilderIcons then
		v4 = useTokens()
	else
		v4 = nil
	end

	local v5 = useAvatarSaveContext()
	local getHistorySignal = v5.getHistorySignal
	local getCurrentHistoryIndexSignal = v5.getCurrentHistoryIndexSignal
	local v6

	if FFlagAXResetAvatarButton then
		v6 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	else
		v6 = nil
	end

	local v7

	if FFlagAXExtendUndoRedoTracking then
		v7 = useAvatarRoute()
	else
		v7 = nil
	end

	local v8 = SignalsReact.useSignalState(getHistorySignal)
	local v9 = SignalsReact.useSignalState(getCurrentHistoryIndexSignal)
	local v10

	if FFlagAXResetAvatarButton then
		v10 = SignalsReact.useSignalState(v6)
	else
		v10 = nil
	end

	local disabled = React.useMemo(function(): boolean
		local v11 = v9
		return not (v11 and v8) or v11 == 1
	end, { v9, v8 })

	local disabled2 = React.useMemo(function(): boolean
		local v11 = v9

		return not (v11 and v8) or v11 == #v8
	end, { v9, v8 })
	local disabled3

	if FFlagAXResetAvatarButton then
		disabled3 = React.useMemo(function(): boolean
			if v10 and v10.tryOn and v10.tryOn.OutfitTryOn and next(v10.tryOn.OutfitTryOn.TryOnItems) ~= nil then
				return false
			end

			if not (v10 and v10.equipped and v10.equipped.EquippedAssets) then
				return true
			end

			for k in v10.equipped.EquippedAssets do
				if table.find(Constants.AssetTypeStringsToKeep, k) == nil then
					return false
				end
			end

			return true
		end, { v10, v8 })
	else
		disabled3 = nil
	end

	local v11 = React.useCallback(function(isUndo: boolean)
		local v11 = v5 and v5.updateHistoryIndexAndGetCharacterData(v9 + (isUndo and -1 or 1))

		if v11 then
			local trackUndoRedoClick = SlotBasedEditorAnalytics.trackUndoRedoClick
			local v12

			if FFlagAXExtendUndoRedoTracking and v7 and v7.opaque then
				v12 = v7.opaque.name
			end

			trackUndoRedoClick(isUndo, v12)

			v3(CharacterHistoryStateChangeButtonActivated({
				isUndo = isUndo,
				equipped = v11.equipped,
				tryOn = v11.tryOn
			}))

			v2.dispatch(ClearScreens({ AvatarScreen.LookDetails }))
		end
	end, { v3, v5, v9, v2, v7, v8 })
	local v12

	if FFlagAXResetAvatarButton then
		v12 = React.useCallback(function()
			local v13 = v6(false)

			if v13 then
				if SlotBasedEditorAnalytics.trackAvatarRemoveAllClick and v7 and v7.opaque then
					SlotBasedEditorAnalytics.trackAvatarRemoveAllClick(v7.opaque.name)
				end

				local equippedAssets = {}

				for _, v14 in Constants.AssetTypeStringsToKeep do
					equippedAssets[v14] = v13.equipped.EquippedAssets[v14]
				end

				v13.equipped.EquippedAssets = equippedAssets

				v3(CharacterHistoryStateChangeButtonActivated(v13))

				v3(ClearTryOns())

				v3(SetCurrentToastMessage(v))
			end
		end, { v3 })
	else
		v12 = nil
	end

	if FFlagAXExtendUndoRedoTracking then
		React.useEffect(function()
			if SlotBasedEditorAnalytics.trackUndoHistoryCount and v7 and v7.opaque and v8 and #v8 then
				SlotBasedEditorAnalytics.trackUndoHistoryCount(v7.opaque.name, #v8)
			end
		end, { v8, v7 })
	end

	return {
		items = React.useMemo(function()
			if FFlagAXResetAvatarButton then
				return {
					{
						type = "icon",
						id = MenuItemEnum.Reset.Reset,
						icon = IconName.ArrowSpinClockwise,
						iconSize = v4.Size.Size_500,
						isActive = false,
						onActivated = function()
							v12()
						end,
						disabled = disabled3
					},
					{
						type = "icon",
						id = MenuItemEnum.Undo,
						icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or IconName.ArrowCurlToLeft,
						onActivated = function()
							v11(true)
						end,
						disabled = disabled,
						isActive = false
					},
					{
						type = "icon",
						id = MenuItemEnum.Redo,
						icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or IconName.ArrowCurlToRight,
						onActivated = function()
							v11(false)
						end,
						disabled = disabled2,
						isActive = false
					}
				}
			end

			return {
				{
					type = "icon",
					id = MenuItemEnum.Undo,
					icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or IconName.ArrowCurlToLeft,
					onActivated = function()
						v11(true)
					end,
					disabled = disabled,
					isActive = false
				},
				{
					type = "icon",
					id = MenuItemEnum.Redo,
					icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or IconName.ArrowCurlToRight,
					onActivated = function()
						v11(false)
					end,
					disabled = disabled2,
					isActive = false
				}
			}
		end, FFlagAXResetAvatarButton and { disabled, disabled2, disabled3, v11, v12 } or { disabled, disabled2, v11 })
	}
end

return useUndoRedoBarViewModel
