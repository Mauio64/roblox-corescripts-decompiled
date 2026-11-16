local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module = require("@luauforge/deferred/gVY")

local module2 = require("@luauforge/deferred/gVP")
local module3 = require("@luauforge/bundled/eeH")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local module4 = require("@luauforge/deferred/gWa")

local module5 = require("@luauforge/deferred/gWc")
local module6 = require("@luauforge/deferred/gWd")
local module7 = require("@luauforge/bundled/fuD")

local module8 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module8.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module9 = require("@luauforge/bundled/goD")

local module10 = require("@luauforge/deferred/gmV")
local module11 = require("@luauforge/bundled/fuG")
local module12 = require("@luauforge/deferred/fvk")
local module13 = require("@luauforge/bundled/goB")
local module14 = require("@luauforge/bundled/dTt")
local module15 = require("@luauforge/deferred/gWe")
local module16 = require("@luauforge/deferred/gWl")
local module17 = require("@luauforge/bundled/fox")
local setCurrentToastMessage = require("@luauforge/bundled/dwC").Actions.SetCurrentToastMessage
local toastType = require("@luauforge/bundled/dwC").Enums.ToastType
local module18 = require("@luauforge/deferred/gVS")
local module19 = require("@luauforge/deferred/gVT")
local fFlagAvatarJointUpgradeInUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAvatarJointUpgradeInUA

local module20 = require("@luauforge/deferred/goU")

local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").flaggedMutedError

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module21 = require("@luauforge/bundled/dTu")
require("@luauforge/bundled/dHK")

local module22 = require("@luauforge/deferred/gWk")

local module23 = require("@luauforge/deferred/gWm")

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

local v5 = {
	toastMessage = "Feature.Avatar.Generic.Error",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Label.AccessoryCannotBeAdjustedWarning",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local function isAdjustmentScreenActive(p2)
	return p2.isVisible and p2.opaque.name == avatarScreen.AdjustAccessoryView
end

local v7 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.AdjustAccessoryViewReset
}

local function useFocusNavigationBindings(p2, callback, p3)
	local v8 = ReactFocusNavigation.useEventMap(v7, p2)
	local v9 = React.useMemo(function()
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
	return ReactFocusNavigation.useEventHandlerMap(v9, v8)
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
	local v8 = useDesignTokens(mapTokens)
	local v9 = useDispatch()
	local v10 = module()
	local v11 = module2()
	local value = v11.appliedDescriptionBinding:getValue()

	local v12 = useSelector(selectSelectedAccessory)

	assert(v12, "Assert selectedAccessory exists")
	local v13 = useSelector(selectEquippedAssets)
	local v14 = useSelector(selectTryOns)
	local v15 = module3(module18)
	local ref = React.useRef(false)

	local v16 = useSelector(module4)
	local v17 = useSelector(module5)

	local state, setState = React.useState(module12.getSliderValuesWithDefault(v13, v14, v12))

	local ref2 = React.useRef(module12.getSliderValuesWithDefault(v13, v14, v12))

	React.useEffect(function()
		ref2.current = state
	end, { state })

	local v18 = React.useCallback(function(p3, p4)
		setState((Cryo.Dictionary.join(ref2.current, { [p4] = p3 })))
	end, { ref2 })

	local v19 = React.useCallback(function(p3, p4)
		local joined = Cryo.Dictionary.join(ref2.current, { [p4] = p3 })

		local sliderInfoToVector3s, v20, v21 = module12.sliderInfoToVector3s(joined)
		v10.setAdjustments(sliderInfoToVector3s, v20, v21)
	end, { ref2 })

	local state2, setState2 = React.useState(false)
	local v20 = nil

	local state3, setState3 = React.useState(nil)
	React.useEffect(function()
		local value2 = v11.appliedDescriptionBinding:getValue()

		if value2 and v12 then
			v20 = module7.getSelectedAccessoryDescription(value2, v12)

			if v20 then
				local success, result = pcall(function()
					return v20:GetAppliedInstance()
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
	end, { value, v12 })
	local v21

	if fFlagAXUseSignalsForAdjustmentTypeSelected then
		v21 = useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected)
	else
		v21 = useSelector(selectAdjustmentTypeSelected)
	end

	local v22 = useSelector(selectTopBarHeight)

	local state4, setState4 = React.useState(nil)

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)

	local function fn()
		local sliderValuesWithDefault = module12.getSliderValuesWithDefault(v13, v14, v12)

		if module12.checkSliderValuesChanged(ref2.current, sliderValuesWithDefault) then
			p2.navigation.navigate(avatarScreen.AccessoryAdjustmentUnsavedPrompt, {
				exitCallback = function()
					local sliderInfoToVector3s, v23, v24 = module12.sliderInfoToVector3s(sliderValuesWithDefault)
					v10.setAdjustments(sliderInfoToVector3s, v23, v24)

					p2.navigation.pop()
				end
			})
		else
			p2.navigation.pop()
		end
	end

	local v23 = React.useCallback(fn, { v13, v14, v12, v10, p2.navigation })

	local function fn2()
		p2.navigation.navigate(avatarScreen.AccessoryAdjustmentResetPrompt, {
			resetCallback = function()
				v9(module19(v15.avatarRefineAccessoryResetConfirm))

				local sliderInfoToVector3s, v24, v25 = module12.sliderInfoToVector3s(module11.DefaultSliderValues)
				v10.setAdjustments(sliderInfoToVector3s, v24, v25)
				setState(module11.DefaultSliderValues)
			end
		})
	end

	local v24 = React.useCallback(fn2, { p2.navigation, v10, setState, v15 })

	local v25 = React.useMemo(function()
		return {
			Back = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, v23),
			OpenResetPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, v24, {
				key = "CommonUI.Messages.Action.Reset"
			})
		}
	end, { v23, v24 })

	local v26 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, v23, v24)))

	React.useEffect(function()
		setState4(InsertService:LoadLocalAsset("rbxasset://models/AccessoryAdjustment/Ring.rbxm"))
		return function()
			if fFlagAXUseSignalsForAdjustmentTypeSelected then
				getAdjustmentTypeSelectedStore(false).setAdjustmentType(module21.Position)
			else
				v9(module14(module21.Position))
			end

			if state4 then
				state4:Destroy()
			end

			if not ref.current then
				local sliderValuesWithDefault = module12.getSliderValuesWithDefault(v13, v14, v12)
				local sliderInfoToVector3s, v27, v28 = module12.sliderInfoToVector3s(sliderValuesWithDefault)
				v10.setAdjustments(sliderInfoToVector3s, v27, v28)
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
			v9(setCurrentToastMessage(p3))
			setState2(false)
			p2.navigation.pop()
		end

		if state3 then
			local handle = state3:FindFirstChild("Handle")

			if handle then
				local v27 = nil
				local v28 = nil
				local v29 = nil
				local weld = handle:FindFirstChildOfClass("Weld")
				local rigidConstraint

				if fFlagAvatarJointUpgradeInUA then
					rigidConstraint = handle:FindFirstChildOfClass("RigidConstraint")
				end

				if fFlagAvatarJointUpgradeInUA then
					if rigidConstraint then
						if rigidConstraint.Attachment0 then
							v27 = rigidConstraint.Attachment0:FindFirstAncestorWhichIsA("BasePart")
						end

						if rigidConstraint.Attachment1 then
							v28 = rigidConstraint.Attachment1:FindFirstAncestorWhichIsA("BasePart")
						end

						if rigidConstraint.Attachment1 then
							v29 = module7.getRecursiveAttachmentCFrame(rigidConstraint.Attachment1)
						end
					elseif weld then
						v27 = weld.Part0
						v28 = weld.Part1
						v29 = weld.C1
					end

					if not (v27 and v28 and v29) then
						v9(setCurrentToastMessage(v5))
						setState2(false)
						p2.navigation.pop()

						return
					end
				elseif not weld then
					v9(setCurrentToastMessage(v5))
					setState2(false)
					p2.navigation.pop()

					return
				end

				if handle:IsA("MeshPart") and handle.HasSkinnedMesh then
					v9(setCurrentToastMessage(v6))
					setState2(false)
					p2.navigation.pop()

					return
				else
					setState2(true)
					local largestAxisSize = module6.getLargestAxisSize(handle.Size)
					local folder = Instance.new("Folder")

					if v21 == module21.Position then
						module6.createPositionAxis(
							folder,
							v8.smallIconSize,
							largestAxisSize,
							v16.position,
							v17.position
						)

						module6.createBillboardRing(
							handle,
							folder,
							"rbxasset://textures/ui/AvatarExperience/SelectionRing.png",
							"Selection"
						)
					elseif v21 == module21.Rotation then
						assert(state4:IsA("MeshPart"), "Assert ringPart is a MeshPart")
						module6.createRotationAxis(folder, largestAxisSize, v8.smallIconSize, state4)
					elseif v21 == module21.Scale then
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
						v28 = weld.Part1
					end

					weld2.Part1 = v28

					local newCFrame = CFrame.new
					local v30 = if fFlagAvatarJointUpgradeInUA then v29.Position else weld.C1.Position
					weld2.C1 = newCFrame(v30)

					if v21 == module21.Position then
						module6.setPositionAdornee(folder, handle, anchor)
					elseif v21 == module21.Rotation then
						local part1 = weld2.Part1

						if not fFlagAvatarJointUpgradeInUA then
							v27 = weld.Part0
						end

						assert(part1, "Assert head not nil")
						assert(v27, "Accessory not nil")
						weld2.C1 = CFrame.new((part1.CFrame:Inverse() * v27.CFrame).Position)
						module6.setRotationAdornee(folder, anchor)
					elseif v21 == module21.Scale then
						module6.setScaleAdornee(folder, handle)
					end

					weld2.Parent = anchor
					local v31 = {}
					table.insert(v31, module6.setUpSizeConnection(handle, folder))
					table.insert(v31, module6.setUpCameraConnection(handle, folder))

					return function()
						if folder then
							folder:Destroy()
						end

						for k, connection in v31 do
							connection:Disconnect()
						end
					end
				end
			end
		end

		v9(setCurrentToastMessage(v5))
		setState2(false)
		p2.navigation.pop()
	end

	local navigation = p2.navigation

	local v28 = if module23 then p2.avatarRoute else nil
	useEffect(fn3, {
		v21,
		v12,
		state3,
		state4,
		v16,
		v17,
		navigation,
		v9,
		v28
	})

	local v29 = {
		TopBar = React.createElement(module17.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			transparentBackground = true,
			leftItem = module17.makeBackButton(v23),
			ref = ref4,
			NextSelectionDown = ref7,
			ZIndex = 1
		}),
		PageContainer = 0
	}

	local createElement = React.createElement
	local v31 = {
		Size = UDim2.new(1, 0, 1, -v22),
		Position = UDim2.fromOffset(0, v22),
		BackgroundTransparency = 1,
		ref = 0
	}

	if not fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
		v26 = nil
	end

	v31.ref = v26
	local v32 = {
		SceneInteractionFrame = React.createElement(module13),
		ResetButton = 0,
		ControlPanel = 0
	}

	local v33 = if not module22 then React.createElement(module16, {
		onResetButtonPressed = v24,
		NextSelectionLeft = ref4
	}) else nil
	v32.ResetButton = v33
	local v34

	if state2 then
		local createElement2 = React.createElement
		local v36 = {
			setSliderValuesCallback = v18,
			updateCharacterCallback = v19,
			onResetButtonPressed = if module22 then v24 else nil,
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

		v36.resetRef = ref6
		v36.applyButtonRef = ref5
		v36.sliderValues = state
		v36.isApplyingAdjustment = ref
		v34 = createElement2(module15, v36)
	end

	v32.ControlPanel = v34
	v29.PageContainer = createElement("Frame", v31, v32)

	local createElement2 = React.createElement
	local frame = focusable.Frame
	local v35 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		defaultChild = ref7,
		inputBindings = 0
	}

	if fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
		v25 = nil
	end

	v35.inputBindings = v25
	return createElement2(frame, v35, {
		SceneGamepadHandler = React.createElement(module20, nil, v29)
	})
end

return (module10((module9(AdjustAccessoryView))))
