local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module = require("@luauforge/deferred/hif")

local module2 = require("@luauforge/deferred/hhW")
local module3 = require("@luauforge/bundled/eie")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local module4 = require("@luauforge/deferred/hih")

local module5 = require("@luauforge/deferred/hij")
local module6 = require("@luauforge/deferred/hik")
local module7 = require("@luauforge/bundled/fCe")

local module8 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module8.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module9 = require("@luauforge/bundled/gTh")

local module10 = require("@luauforge/deferred/gRz")
local module11 = require("@luauforge/bundled/fCh")
local module12 = require("@luauforge/deferred/fCL")
local module13 = require("@luauforge/bundled/gTf")
local module14 = require("@luauforge/bundled/dWO")
local module15 = require("@luauforge/deferred/hil")
local module16 = require("@luauforge/deferred/hiw")
local module17 = require("@luauforge/bundled/fvR")
local setCurrentToastMessage = require("@luauforge/bundled/dzF").Actions.SetCurrentToastMessage
local toastType = require("@luauforge/bundled/dzF").Enums.ToastType
local module18 = require("@luauforge/deferred/hhZ")
local module19 = require("@luauforge/deferred/hia")
local fFlagAvatarJointUpgradeInUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAvatarJointUpgradeInUA

local module20 = require("@luauforge/deferred/gTx")

local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").flaggedMutedError

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module21 = require("@luauforge/bundled/dWP")
require("@luauforge/bundled/dKT")

local module22 = require("@luauforge/deferred/hiv")

local module23 = require("@luauforge/deferred/hix")

local fFlagAXMigrateAdjustAccessoryViewToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateAdjustAccessoryViewToFocusNavigation

local fFlagAXUseSignalsForAdjustmentTypeSelected = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAdjustmentTypeSelected
local getAdjustmentTypeSelectedStore

if fFlagAXUseSignalsForAdjustmentTypeSelected then
	getAdjustmentTypeSelectedStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getAdjustmentTypeSelectedStore
else
	getAdjustmentTypeSelectedStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXUseSignalsForAvatarSettings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAvatarSettings

local v5 = if fFlagAXUseSignalsForAvatarSettings then require("@luauforge/deferred/hir") else nil

local v6 = if fFlagAXUseSignalsForAvatarSettings then require("@luauforge/deferred/hit") else nil

local v7 = {
	toastMessage = "Feature.Avatar.Generic.Error",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local v8 = {
	toastMessage = "Feature.Avatar.Label.AccessoryCannotBeAdjustedWarning",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local function isAdjustmentScreenActive(p2)
	return p2.isVisible and p2.opaque.name == avatarScreen.AdjustAccessoryView
end

local v9 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.AdjustAccessoryViewReset
}

local function useFocusNavigationBindings(p2, callback, p3)
	local v10 = ReactFocusNavigation.useEventMap(v9, p2)
	local v11 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					callback()
				end)
			},
			[focusNavigationEventNameEnum.AdjustAccessoryViewReset] = {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, { callback, p3 })
	return ReactFocusNavigation.useEventHandlerMap(v11, v10)
end

local function mapTokens(p2)
	return {
		smallIconSize = p2.Size.Size_400,
		buttonSize = p2.Size.Size_800,
		portraitPadding = p2.Size.Size_200,
		landscapePadding = p2.Size.Size_300,
		sidePadding = p2.Size.Size_300,
		cornerRadius = p2.Radius.Medium,
		panelMargin = p2.Size.Size_900
	}
end

local function selectAdjustmentTypeSelected(p2)
	return p2.AvatarExperience.AccessoryAdjustment.AdjustmentTypeSelected
end

local function selectTopBarHeight(p2)
	return p2.TopBar.topBarHeight
end

local function selectSelectedAccessory(p2)
	return p2.AvatarExperience.AccessoryAdjustment.SelectedAccessory
end

local function selectEquippedAssets(p2)
	return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
end

local function selectTryOns(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function AdjustAccessoryView(p2)
	local v10 = useDesignTokens(mapTokens)
	local v11 = useDispatch()
	local v12 = module()
	local v13 = module2()
	local value = v13.appliedDescriptionBinding:getValue()

	local v14 = useSelector(selectSelectedAccessory)

	assert(v14, "Assert selectedAccessory exists")
	local v15 = useSelector(selectEquippedAssets)
	local v16 = useSelector(selectTryOns)
	local v17 = module3(module18)
	local ref = React.useRef(false)

	local v18 = if fFlagAXUseSignalsForAvatarSettings then v5() else useSelector(module4)

	local v19 = if fFlagAXUseSignalsForAvatarSettings then v6() else useSelector(module5)

	local state, setState = React.useState(module12.getSliderValuesWithDefault(v15, v16, v14))

	local ref2 = React.useRef(module12.getSliderValuesWithDefault(v15, v16, v14))

	React.useEffect(function()
		ref2.current = state
	end, { state })

	local v20 = React.useCallback(function(p3, p4)
		setState((Cryo.Dictionary.join(ref2.current, { [p4] = p3 })))
	end, { ref2 })

	local v21 = React.useCallback(function(p3, p4)
		local joined = Cryo.Dictionary.join(ref2.current, { [p4] = p3 })

		local sliderInfoToVector3s, v22, v23 = module12.sliderInfoToVector3s(joined)
		v12.setAdjustments(sliderInfoToVector3s, v22, v23)
	end, { ref2 })

	local state2, setState2 = React.useState(false)
	local v22 = nil

	local state3, setState3 = React.useState(nil)
	React.useEffect(function()
		local value2 = v13.appliedDescriptionBinding:getValue()

		if value2 and v14 then
			v22 = module7.getSelectedAccessoryDescription(value2, v14)

			if v22 then
				local success, result = pcall(function()
					return v22:GetAppliedInstance()
				end)

				if success then
					setState3(result)
				else
					flaggedMutedError(
						"AdjustAccessoryView",
						"AdjustAccessoryView accessoryDescription:GetAppliedInstance error: " .. tostring(result)
					)
				end
			end
		end
	end, { value, v14 })
	local v23

	if fFlagAXUseSignalsForAdjustmentTypeSelected then
		v23 = useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected)
	else
		v23 = useSelector(selectAdjustmentTypeSelected)
	end

	local v24 = useSelector(selectTopBarHeight)

	local state4, setState4 = React.useState(nil)

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)

	local function fn()
		local sliderValuesWithDefault = module12.getSliderValuesWithDefault(v15, v16, v14)

		if module12.checkSliderValuesChanged(ref2.current, sliderValuesWithDefault) then
			p2.navigation.navigate(avatarScreen.AccessoryAdjustmentUnsavedPrompt, {
				exitCallback = function()
					local sliderInfoToVector3s, v25, v26 = module12.sliderInfoToVector3s(sliderValuesWithDefault)
					v12.setAdjustments(sliderInfoToVector3s, v25, v26)

					p2.navigation.pop()
				end
			})
		else
			p2.navigation.pop()
		end
	end

	local v25 = React.useCallback(fn, { v15, v16, v14, v12, p2.navigation })

	local function fn2()
		p2.navigation.navigate(avatarScreen.AccessoryAdjustmentResetPrompt, {
			resetCallback = function()
				v11(module19(v17.avatarRefineAccessoryResetConfirm))

				local sliderInfoToVector3s, v26, v27 = module12.sliderInfoToVector3s(module11.DefaultSliderValues)
				v12.setAdjustments(sliderInfoToVector3s, v26, v27)
				setState(module11.DefaultSliderValues)
			end
		})
	end

	local v26 = React.useCallback(fn2, { p2.navigation, v12, setState, v17 })

	local v27 = React.useMemo(function()
		return {
			Back = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, v25),
			OpenResetPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, v26, {
				key = "CommonUI.Messages.Action.Reset"
			})
		}
	end, { v25, v26 })

	local v29 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, v25, v26)))

	React.useEffect(function()
		setState4(module6.loadRingPart())
		return function()
			if fFlagAXUseSignalsForAdjustmentTypeSelected then
				getAdjustmentTypeSelectedStore(false).setAdjustmentType(module21.Position)
			else
				v11(module14(module21.Position))
			end

			if state4 then
				state4:Destroy()
			end

			if not ref.current then
				local sliderValuesWithDefault = module12.getSliderValuesWithDefault(v15, v16, v14)
				local sliderInfoToVector3s, v30, v31 = module12.sliderInfoToVector3s(sliderValuesWithDefault)
				v12.setAdjustments(sliderInfoToVector3s, v30, v31)
			end
		end
	end, {})

	local useEffect = React.useEffect
	local function fn3()
		if module23 then
			local avatarRoute = p2.avatarRoute

			if not avatarRoute.isVisible or avatarRoute.opaque.name ~= avatarScreen.AdjustAccessoryView then
				return
			end
		end

		if not state4 then
			return
		end

		local function exitWithToast(p3)
			v11(setCurrentToastMessage(p3))
			setState2(false)
			p2.navigation.pop()
		end

		if state3 then
			local handle = state3:FindFirstChild("Handle")

			if handle then
				local v30 = nil
				local v31 = nil
				local v32 = nil
				local weld = handle:FindFirstChildOfClass("Weld")
				local rigidConstraint

				if fFlagAvatarJointUpgradeInUA then
					rigidConstraint = handle:FindFirstChildOfClass("RigidConstraint")
				end

				if fFlagAvatarJointUpgradeInUA then
					if rigidConstraint then
						if rigidConstraint.Attachment0 then
							v30 = rigidConstraint.Attachment0:FindFirstAncestorWhichIsA("BasePart")
						end

						if rigidConstraint.Attachment1 then
							v31 = rigidConstraint.Attachment1:FindFirstAncestorWhichIsA("BasePart")
						end

						if rigidConstraint.Attachment1 then
							v32 = module7.getRecursiveAttachmentCFrame(rigidConstraint.Attachment1)
						end
					elseif weld then
						v30 = weld.Part0
						v31 = weld.Part1
						v32 = weld.C1
					end

					if not (v30 and v31 and v32) then
						v11(setCurrentToastMessage(v7))
						setState2(false)
						p2.navigation.pop()

						return
					end
				elseif not weld then
					v11(setCurrentToastMessage(v7))
					setState2(false)
					p2.navigation.pop()

					return
				end

				if handle:IsA("MeshPart") and handle.HasSkinnedMesh then
					v11(setCurrentToastMessage(v8))
					setState2(false)
					p2.navigation.pop()

					return
				else
					setState2(true)
					local largestAxisSize = module6.getLargestAxisSize(handle.Size)
					local folder = Instance.new("Folder")

					if v23 == module21.Position then
						module6.createPositionAxis(
							folder,
							v10.smallIconSize,
							largestAxisSize,
							v18.position,
							v19.position
						)

						module6.createBillboardRing(
							handle,
							folder,
							"rbxasset://textures/ui/AvatarExperience/SelectionRing.png",
							"Selection"
						)
					elseif v23 == module21.Rotation then
						assert(state4:IsA("MeshPart"), "Assert ringPart is a MeshPart")
						module6.createRotationAxis(folder, largestAxisSize, v10.smallIconSize, state4)
					elseif v23 == module21.Scale then
						module6.createBillboardRing(
							handle,
							folder,
							"rbxasset://textures/ui/AvatarExperience/GlowRing.png",
							"Scale"
						)
						module6.createSelectionDot(
							folder,
							"rbxasset://textures/ui/AvatarExperience/CenterPoint.png",
							"SelectionDot"
						)
					end

					folder.Parent = workspace
					local anchor = Instance.new("Part")
					anchor.Transparency = 1
					anchor.Name = "Anchor"
					anchor.Parent = folder
					local weld2 = Instance.new("Weld")
					weld2.Part0 = anchor

					if not fFlagAvatarJointUpgradeInUA then
						v31 = weld.Part1
					end

					weld2.Part1 = v31

					local newCFrame = CFrame.new
					local v33 = if fFlagAvatarJointUpgradeInUA then v32.Position else weld.C1.Position
					weld2.C1 = newCFrame(v33)

					if v23 == module21.Position then
						module6.setPositionAdornee(folder, handle, anchor)
					elseif v23 == module21.Rotation then
						local part1 = weld2.Part1

						if not fFlagAvatarJointUpgradeInUA then
							v30 = weld.Part0
						end

						assert(part1, "Assert head not nil")
						assert(v30, "Accessory not nil")
						weld2.C1 = CFrame.new((part1.CFrame:Inverse() * v30.CFrame).Position)
						module6.setRotationAdornee(folder, anchor)
					elseif v23 == module21.Scale then
						module6.setScaleAdornee(folder, handle)
					end

					weld2.Parent = anchor
					local v34 = {}
					table.insert(v34, module6.setUpSizeConnection(handle, folder))
					table.insert(v34, module6.setUpCameraConnection(handle, folder))

					return function()
						if folder then
							folder:Destroy()
						end

						for k, connection in v34 do
							connection:Disconnect()
						end
					end
				end
			end
		end

		v11(setCurrentToastMessage(v7))
		setState2(false)
		p2.navigation.pop()
	end

	local navigation = p2.navigation

	local v31 = if module23 then p2.avatarRoute else nil
	useEffect(fn3, {
		v23,
		v14,
		state3,
		state4,
		v18,
		v19,
		navigation,
		v11,
		v31
	})

	local v32 = {
		TopBar = React.createElement(module17.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			transparentBackground = true,
			leftItem = module17.makeBackButton(v25),
			ref = ref4,
			NextSelectionDown = ref7,
			ZIndex = 1
		}),
		PageContainer = 0
	}

	local createElement = React.createElement
	local v34 = {
		Size = UDim2.new(1, 0, 1, -v24),
		Position = UDim2.fromOffset(0, v24),
		BackgroundTransparency = 1,
		ref = 0
	}

	if not fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
		v29 = nil
	end

	v34.ref = v29
	local v35 = {
		SceneInteractionFrame = React.createElement(module13),
		ResetButton = 0,
		ControlPanel = 0
	}

	local v36 = if not module22 then React.createElement(module16, {
		onResetButtonPressed = v26,
		NextSelectionLeft = ref4
	}) else nil
	v35.ResetButton = v36
	local v37

	if state2 then
		local createElement2 = React.createElement
		local v39 = {
			setSliderValuesCallback = v20,
			updateCharacterCallback = v21,
			onResetButtonPressed = if module22 then v26 else nil,
			adjustmentTypeFrameRef = ref7,
			sliderFrameRef = ref3,
			topBarRef = ref4,
			resetRef = nil,
			applyButtonRef = nil,
			sliderValues = nil,
			isApplyingAdjustment = nil
		}

		if module22 then
			ref6 = nil
		end

		v39.resetRef = ref6
		v39.applyButtonRef = ref5
		v39.sliderValues = state
		v39.isApplyingAdjustment = ref
		v37 = createElement2(module15, v39)
	end

	v35.ControlPanel = v37
	v32.PageContainer = createElement("Frame", v34, v35)

	local createElement2 = React.createElement
	local frame = focusable.Frame
	local v38 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		defaultChild = ref7,
		inputBindings = 0
	}

	if fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
		v27 = nil
	end

	v38.inputBindings = v27
	return createElement2(frame, v38, {
		SceneGamepadHandler = React.createElement(module20, nil, v32)
	})
end

return (module10((module9(AdjustAccessoryView))))
