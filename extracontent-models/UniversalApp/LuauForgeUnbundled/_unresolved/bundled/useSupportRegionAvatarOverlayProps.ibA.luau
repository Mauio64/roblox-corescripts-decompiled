local module = require("@luauforge/bundled/ibe")
local module2 = require("@luauforge/bundled/ibB")
local module3 = require("@luauforge/bundled/ibC")
local module4 = require("@luauforge/bundled/ibj")
local useTokens = module4.Hooks.useTokens
local buttonVariant = module4.Enums.ButtonVariant
local module5 = require("@luauforge/bundled/ibi")
local usePreferredInput = module5.usePreferredInput
local module6 = require("@luauforge/bundled/ibp")
local useDispatch = module6.Hooks.RoactRodux.useDispatch
local useSelector = module6.Hooks.RoactRodux.useSelector
local useStore = module6.Hooks.RoactRodux.useStore
local useSignalState = require("@luauforge/bundled/ibD").useSignalState
local useLocalization = require("@luauforge/bundled/ibE").Hooks.useLocalization
local module7 = require("@luauforge/bundled/ibF")
local performFetch = module7.PerformFetch
local retrievalStatus = module7.Enum.RetrievalStatus

local centralOverlayType = require("@luauforge/bundled/ibG").CentralOverlayType

require("@luauforge/bundled/ibd")
local module8 = require("@luauforge/bundled/ibx")

local splitPaneStore = require("@luauforge/bundled/ibH").SplitPaneStore
local supportPaneMode = require("@luauforge/bundled/ibI").Enums.SupportPaneMode

local module9 = require("@luauforge/bundled/ibJ")
local getUseSelectorDeepEquals = module9.Utils.getUseSelectorDeepEquals
local getEquippedAvatarOutfitIdStore = module9.Stores.getEquippedAvatarOutfitIdStore
local useHydrateEquippedAvatarOutfitId = module9.Hooks.useHydrateEquippedAvatarOutfitId

local avatarScreen = require("@luauforge/bundled/ibv").Enums.AvatarScreen

local supportRegionAvatarOverlayAnalytics = require("@luauforge/bundled/ibw").Surfaces.SupportRegionAvatarOverlayAnalytics
local fFlagSplitPaneAvatarMetrics = require("@luauforge/bundled/iby").FFlagSplitPaneAvatarMetrics
local fFlagSplitPaneUnsavedDialogAlertStyle = require("@luauforge/bundled/iby").FFlagSplitPaneUnsavedDialogAlertStyle

require("@luauforge/bundled/ibh")

local outfitTypes = module9.Enums.OutfitTypes
local categories = require("@luauforge/bundled/ibK").Enums.Categories
local module10 = require("@luauforge/bundled/ibm")

local v5 = nil
local avatarsCategoryIndex = nil
local flag = false

local function resolveEditorCategoryIndices(p2)
	if flag then
		return
	end

	for k, v6 in p2.getAvatarEditorCategories() do
		if v6.Id == categories.All then
			v5 = k
		elseif v6.Name == p2.CharacterKey then
			avatarsCategoryIndex = k
		end
	end

	flag = true
end

local function getEditAvatarCategoryIndex(p2)
	resolveEditorCategoryIndices(p2)

	if v5 ~= nil then
		return v5
	end

	if avatarsCategoryIndex ~= nil then
		return avatarsCategoryIndex
	end

	error("All and Avatars categories are missing from the avatar editor")
end

local function getAvatarsCategoryIndex(p2)
	resolveEditorCategoryIndices(p2)

	if avatarsCategoryIndex ~= nil then
		return avatarsCategoryIndex
	end

	error("Avatars category is missing from the avatar editor")
end

local function selectStatusBarHeight(p2)
	return p2.TopBar.statusBarHeight
end

local function selectEquippedAssets(p2)
	return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
end

local function selectIsApplyingOutfit(p2)
	local avatarScene = p2.AvatarExperience.AvatarScene
	local isApplyingOutfit

	if avatarScene == nil or avatarScene.Character == nil then
		isApplyingOutfit = false
	else
		isApplyingOutfit = avatarScene.Character.WaitingOnLayeredClothingUpdates == true
	end

	return isApplyingOutfit
end

local function useSupportRegionAvatarOverlayProps()
	local v6 = module8()
	local v7 = useDispatch()
	local v8 = useStore()
	useHydrateEquippedAvatarOutfitId()

	local v9 = module.useCallback(function(p2)
		local ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		return ownedItemIdsBySubtype and ownedItemIdsBySubtype[v6.EditableCharacterKey] or {}
	end, { v6.EditableCharacterKey })
	local v10 = module.useCallback(function(p2): boolean
		local pageFinished = p2.AvatarExperience.AvatarEditor.PageFinished
		return pageFinished ~= nil and pageFinished[v6.EditableCharacterKey] == true
	end, { v6.EditableCharacterKey })

	module.useEffect(function()
		supportRegionAvatarOverlayAnalytics.logPageView()
	end, {})

	local v11 = useLocalization({
		unsavedChangesDialogTitle = "Feature.SplitPane.UnsavedChangesDialogTitle",
		unsavedChangesDialogBody = "Feature.SplitPane.UnsavedChangesDialogBody",
		unsavedChangesDialogPrimaryCTA = "Feature.SplitPane.UnsavedChangesDialogPrimaryCTA",
		unsavedChangesDialogSecondaryCTA = "Feature.SplitPane.UnsavedChangesDialogSecondaryCTA",
		editAvatarButtonText = "Feature.SplitPane.EditAvatarButtonText",
		noAdditionalAvatarsDialogTitle = "Feature.SplitPane.NoAdditionalAvatarsDialogTitle",
		noAdditionalAvatarsDialogBody = "Feature.SplitPane.NoAdditionalAvatarsDialogBody",
		noAdditionalAvatarsDialogPrimaryCTA = "Feature.SplitPane.NoAdditionalAvatarsDialogPrimaryCTA",
		nextAvatar = "Feature.SplitPane.Label.NextAvatar",
		previousAvatar = "Feature.SplitPane.Label.PreviousAvatar",
		rotate = "Feature.SplitPane.Label.Rotate"
	})

	local v12 = useTokens()
	local v13 = usePreferredInput()

	local v14 = v13 == module5.Input.Directional

	local v15 = module.useCallback(function(p2)
		splitPaneStore.getStore().setSupportPaneEntryTarget(p2)
	end, {})

	local v16 = v13 == module5.Input.Pointer
	local state, setState = module.useState(false)

	local v17 = module.useCallback(function()
		setState(true)
	end, {})

	local v18 = module.useCallback(function()
		setState(false)
	end, {})

	local v19, v20 = module3.useAnimatedBinding(module10.getEditAvatarTransparency(false, v16))

	module.useEffect(function()
		v20(module3.ease(module10.getEditAvatarTransparency(state, v16), {
			duration = v12.Time.Time_200,
			easingStyle = v12.Ease.StandardOut
		}))
	end, { state, v16, v12 })

	local v21 = module.useMemo(function()
		return v19:map(module10.isEditAvatarVisible)
	end, { v19 })

	local equippedAvatarOutfitIdStore = getEquippedAvatarOutfitIdStore(false)
	local v22 = useSignalState(equippedAvatarOutfitIdStore.getLastEquippedAvatarOutfitId)

	local v23 = useSelector(selectStatusBarHeight)
	local v24 = useSelector(v9, getUseSelectorDeepEquals())
	local v25 = useSelector(v10)
	local v26 = useSelector(selectEquippedAssets)
	local v28 = useSelector((module.useCallback(function(p2)
		return performFetch.GetStatus(p2, v6.OutfitsKey .. v6.EditableCharacterKey)
	end, { v6.OutfitsKey, v6.EditableCharacterKey })))

	local v29 = useSelector(selectIsApplyingOutfit)
	local state2, setState2 = module.useState(false)
	local ref = module.useRef(state2)
	ref.current = state2
	local ref2 = module.useRef(false)

	local state3, setState3 = module.useState(0)

	local v30 = v24[1]
	local v32 = useSelector((module.useCallback(function(p2)
		if v30 == nil then
			return nil
		end

		return p2.AvatarExperience.AvatarEditor.OutfitInfos[tostring(v30)]
	end, { v30 })))

	local v33 = not (v25 or #v24 >= 25)
	module.useEffect(function()
		if v33 then
			v7(v6.GetOutfits(
				v6.EditableCharacterKey,
				true,
				v6.EditableCharacterKey,
				outfitTypes.Avatar,
				nil
			))
		end
	end, { v7, v6, v33 })

	module.useEffect(function()
		if v22 == nil or v28 == retrievalStatus.Done and #v24 == 0 or (v26 == nil or next(v26) == nil) then
			return
		end

		if #v24 == 0 then
			return
		end

		if v22 ~= "" then
			local v34 = module2.List.find(v24, v22)

			if v34 ~= nil then
				setState3(v34)
				return
			end
		end

		local v34 = v24[1]

		if v32 == nil then
			v7(v6.GetOutfit((tostring(v34))))
			return
		end

		if not v6.isWearingOutfit(v8:getState(), v32) then
			setState3(0)

			return
		end

		setState3(1)
		equippedAvatarOutfitIdStore.setLastEquippedAvatarOutfitId((tostring(v34)))
	end, {
		v22,
		v24,
		v26,
		v32,
		v8,
		v7,
		equippedAvatarOutfitIdStore,
		v28,
		v6
	})

	local v34 = module.useCallback(function()
		local navigateIntoAvatarExperience = v6.NavigateIntoAvatarExperience
		local avatarEditor = avatarScreen.AvatarEditor
		resolveEditorCategoryIndices(v6)
		local v37

		if v5 == nil then
			if avatarsCategoryIndex == nil then
				error("All and Avatars categories are missing from the avatar editor")
			else
				v37 = avatarsCategoryIndex
			end
		else
			v37 = v5
		end

		v7(navigateIntoAvatarExperience(avatarEditor, { category = v37 }))
	end, { v7, v6 })

	local v35 = module.useCallback(function()
		local navigateIntoAvatarExperience = v6.NavigateIntoAvatarExperience
		local avatarEditor = avatarScreen.AvatarEditor
		resolveEditorCategoryIndices(v6)
		local v38

		if avatarsCategoryIndex == nil then
			error("Avatars category is missing from the avatar editor")
		else
			v38 = avatarsCategoryIndex
		end

		v7(navigateIntoAvatarExperience(avatarEditor, { category = v38 }))
	end, { v7, v6 })

	local v36 = module.useCallback(function()
		supportRegionAvatarOverlayAnalytics.logEditAvatarClick()
		v34()
	end, { v34 })

	local v37 = module.useCallback(function(callback)
		local setCentralOverlay = v6.SetCentralOverlay
		local confirmationDialog = centralOverlayType.ConfirmationDialog
		local v39 = {
			title = v11.unsavedChangesDialogTitle,
			body = v11.unsavedChangesDialogBody,
			confirmButtonText = v11.unsavedChangesDialogPrimaryCTA,
			cancelButtonText = v11.unsavedChangesDialogSecondaryCTA,
			cancelButtonVariant = 0,
			hasBackdrop = false,
			onConfirm = 0,
			onCancel = 0,
			onClose = 0
		}

		local v40 = if fFlagSplitPaneUnsavedDialogAlertStyle then buttonVariant.Alert else nil
		v39.cancelButtonVariant = v40

		function v39.onConfirm()
			supportRegionAvatarOverlayAnalytics.logUnsavedDialogClick("save")
			v7(v6.CloseCentralOverlay())
			v35()
		end
		function v39.onCancel()
			supportRegionAvatarOverlayAnalytics.logUnsavedDialogClick("switch_anyway")
			v7(v6.CloseCentralOverlay())
			callback()
		end
		function v39.onClose()
			supportRegionAvatarOverlayAnalytics.logUnsavedDialogClick("close")
			v7(v6.CloseCentralOverlay())
		end

		v7(setCentralOverlay(confirmationDialog, v39))

		if fFlagSplitPaneAvatarMetrics then
			supportRegionAvatarOverlayAnalytics.logDialogShown(supportRegionAvatarOverlayAnalytics.Dialog.UnsavedChanges)
		end
	end, {
		v7,
		v11.unsavedChangesDialogBody,
		v11.unsavedChangesDialogPrimaryCTA,
		v11.unsavedChangesDialogSecondaryCTA,
		v11.unsavedChangesDialogTitle,
		v35,
		v6
	})

	local v38 = module.useCallback(function()
		v7(v6.SetCentralOverlay(centralOverlayType.ConfirmationDialog, {
			title = v11.noAdditionalAvatarsDialogTitle,
			body = v11.noAdditionalAvatarsDialogBody,
			confirmButtonText = v11.noAdditionalAvatarsDialogPrimaryCTA,
			hasBackdrop = false,
			onConfirm = function()
				supportRegionAvatarOverlayAnalytics.logNoAdditionalAvatarsDialogClick("create_avatar")
				v7(v6.CloseCentralOverlay())
				v35()
			end,
			onCancel = function()
				supportRegionAvatarOverlayAnalytics.logNoAdditionalAvatarsDialogClick("cancel")
				v7(v6.CloseCentralOverlay())
			end
		}))

		if fFlagSplitPaneAvatarMetrics then
			supportRegionAvatarOverlayAnalytics.logDialogShown(supportRegionAvatarOverlayAnalytics.Dialog.NoAdditionalAvatars)
		end
	end, {
		v7,
		v11.noAdditionalAvatarsDialogBody,
		v11.noAdditionalAvatarsDialogPrimaryCTA,
		v11.noAdditionalAvatarsDialogTitle,
		v35,
		v6
	})

	local v39 = module.useCallback(function(p2, p3)
		if ref.current then
			return
		end

		local state4 = v8:getState()
		local outfitInfos = state4.AvatarExperience.AvatarEditor.OutfitInfos
		local outfitInfoAtIndex, v40 = module10.getOutfitInfoAtIndex(v24, outfitInfos, p2)
		supportRegionAvatarOverlayAnalytics.logChevronClick(p3, outfitInfoAtIndex ~= nil)

		if outfitInfoAtIndex == nil then
			if v40 ~= nil then
				v7(v6.GetOutfit(v40))
			end
		else
			local function performSwitch()
				ref.current = true
				setState2(true)

				v7(v6.EquipOutfit({ outfitInfo = outfitInfoAtIndex }))

				setState3(p2)
			end

			local outfitInfoAtIndex2, v41 = module10.getOutfitInfoAtIndex(v24, outfitInfos, state3)

			if outfitInfoAtIndex2 == nil and v41 ~= nil then
				v7(v6.GetOutfit(v41))
				return
			end

			if outfitInfoAtIndex2 == nil or not v6.isWearingOutfit(state4, outfitInfoAtIndex2) then
				v37(performSwitch)
				return
			end

			ref.current = true
			setState2(true)

			v7(v6.EquipOutfit({ outfitInfo = outfitInfoAtIndex }))

			setState3(p2)
		end
	end, { v24, state3, v8, v7, v37, v6 })

	module.useEffect(function()
		if not state2 then
			ref2.current = false
		elseif v29 then
			ref2.current = true
		elseif ref2.current then
			setState2(false)
		end
	end, { state2, v29 })

	module.useEffect(function()
		if not state2 then
			return
		end

		local thread = task.delay(3, function()
			setState2(false)
		end)
		return function()
			task.cancel(thread)
		end
	end, { state2 })

	local v40 = module.useCallback(function()
		splitPaneStore.getStore().toggleSupportPaneMode(supportPaneMode.Collapsed)
	end, {})

	local previousOutfit = module10.hasPreviousOutfit(state3, #v24)

	local v41 = module.useMemo(function()
		local v42 = {}

		table.insert(v42, { keyCode = Enum.KeyCode.ButtonR2, label = v11.nextAvatar })

		if previousOutfit then
			table.insert(v42, {
				keyCode = Enum.KeyCode.ButtonL2,
				label = v11.previousAvatar
			})
		end

		table.insert(v42, { keyCode = Enum.KeyCode.Thumbstick2, label = v11.rotate })

		return v42
	end, { previousOutfit, v11.nextAvatar, v11.previousAvatar, v11.rotate })

	local nextOutfit = module10.hasNextOutfit(state3, #v24)

	local v42 = (v25 or #v24 >= 25 or v28 == retrievalStatus.Done) and not nextOutfit

	local v43 = module.useCallback(function()
		v39(state3 - 1, "previous")
	end, { v39, state3 })

	local v44 = module.useCallback(function()
		if v42 then
			v38()
		else
			v39(state3 + 1, "next")
		end
	end, { v39, state3, v42, v38 })

	return {
		topInset = v23,
		showSwitchOutfitControls = not v14,
		showEditAvatar = not v14,
		showShortcutCluster = v14,
		showCollapseButton = not v14,
		showTopEditAvatar = v14,
		showLeftChevron = module10.shouldShowLeftChevron(state3),
		showRightChevron = module10.shouldShowRightChevron(state3, 25),
		onCollapseActivated = v40,
		onLeftChevronActivated = v43,
		onRightChevronActivated = v44,
		onEditAvatarActivated = v36,
		onOverlayMouseEnter = v17,
		onOverlayMouseLeave = v18,
		editAvatarTransparency = v19,
		isEditAvatarVisible = v21,
		editAvatarButtonText = v11.editAvatarButtonText,
		hasNextOutfit = nextOutfit,
		hasNoAdditionalAvatars = v42,
		isSwitchingOutfit = state2,
		shortcuts = v41,
		setEntryTarget = v15
	}
end

return useSupportRegionAvatarOverlayProps
