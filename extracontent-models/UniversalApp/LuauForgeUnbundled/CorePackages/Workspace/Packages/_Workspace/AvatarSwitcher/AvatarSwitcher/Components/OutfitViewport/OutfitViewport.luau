local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceModel")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local bundleTypeIdStrings = AvatarExperienceModel.Constants.BundleTypeIdStrings
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceAnalytics").sendAXCounterV2

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/RoactUtils").ExternalEventConnection
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local module4 = require("@luauforge/bundled/dUd")
local useOutfitViewportInteractions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarSwitcher/Components/OutfitViewport/useOutfitViewportInteractions")

local color = Color3.fromRGB(218, 203, 173)

local function ItemViewport(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef("")
	local ref5 = React.useRef(0)
	local state, setState = React.useState(true)

	local v5 = not state
	local v6 = useOutfitViewportInteractions({
		setParentScrollingEnabled = props.setParentScrollingEnabled,
		defaultCameraDistanceRef = ref5
	})

	local v7 = React.useCallback(function(p2, p3, p4, p5)
		setState(true)

		if ref.current then
			ref.current:ClearAllChildren()
		end

		local guid = HttpService:GenerateGUID(false)
		ref4.current = guid

		local success, result = pcall(function()
			if p3 == itemTypeEnum.Asset and tonumber(p2) then
				return module4.getAssetModel((tonumber(p2)))
			end

			if p3 ~= itemTypeEnum.Bundle or not (p4 and p5) then
				return nil
			end

			if p4 == bundleTypeIdStrings.Shoes then
				return module4.getShoesModel(p5)
			end

			local v8 = p4 == bundleTypeIdStrings.DynamicHead
			return module4.getAvatarModel(p5, v8)
		end)

		if success and result then
			if ref4.current ~= guid then
				result:Destroy()
				return
			end

			local v8 = not ref2.current and 70 or ref2.current.MaxAxisFieldOfView
			ref5.current = module4.getCameraDistance(result, v8)
			result.Parent = ref.current
			setState(false)
		else
			if props.onLoadingFailed then
				props.onLoadingFailed()
			end

			sendAXCounterV2("ItemViewportLoadingFailed")

			if not _G.__TESTEZ_RUNNING_TEST__ then
				warn(`ItemViewport: failed to load 3D model for item {p2}`, result)
			end
		end
	end, { props.onLoadingFailed })

	React.useEffect(function()
		task.spawn(function()
			v7(props.itemId, props.itemType, props.bundleType, props.bundleItems)
		end)
	end, { props.itemId, props.itemType, props.bundleType, props.bundleItems, v7 })

	React.useLayoutEffect(function()
		if ref3.current then
			ref3.current.CurrentCamera = ref2.current
		end
	end, {})

	local createElement = React.createElement
	local v9 = {
		["Size"] = nil,
		["Size"] = nil,
		Size = props.size or UDim2.fromScale(1, 1),
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LightColor = color,
		LightDirection = Vector3.new(-1, -1, 2),
		BackgroundTransparency = 1,
		ref = ref3
	}

	local inputBegan = React.Event.InputBegan
	local v10 = if v5 then v6.onInputBegan else nil
	v9[inputBegan] = v10
	local mouseWheelForward = React.Event.MouseWheelForward
	local v11 = if v5 then v6.onMouseWheelForward else nil
	v9[mouseWheelForward] = v11
	local mouseWheelBackward = React.Event.MouseWheelBackward
	local v12 = if v5 then v6.onMouseWheelBackward else nil
	v9[mouseWheelBackward] = v12
	local mouseEnter = React.Event.MouseEnter
	local v13 = if v5 then v6.onMouseEnter else nil
	v9[mouseEnter] = v13
	local mouseLeave = React.Event.MouseLeave
	local v14 = if v5 then v6.onMouseLeave else nil
	v9[mouseLeave] = v14
	local v15 = {
		WorldModel = React.createElement("WorldModel", { ref = ref }),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			CFrame = v6.cameraCFrame,
			ref = ref2
		}),
		LoadingSpinner = 0,
		InputChangedConnection = 0,
		InputEndedConnection = 0,
		TouchPinchConnection = 0
	}

	local v16 = if state then React.createElement(loading, {
		Position = UDim2.fromScale(0.5, 0.5),
		size = iconSize.Large,
		AnchorPoint = Vector2.new(0.5, 0.5)
	}) else nil
	v15.LoadingSpinner = v16

	local v17 = if v5 then React.createElement(externalEventConnection, {
		event = UserInputService.InputChanged,
		callback = v6.onInputChanged
	}) else nil
	v15.InputChangedConnection = v17

	local v18 = if v5 then React.createElement(externalEventConnection, {
		event = UserInputService.InputEnded,
		callback = v6.onInputEnded
	}) else nil
	v15.InputEndedConnection = v18

	local v19 = if v5 then React.createElement(externalEventConnection, {
		event = UserInputService.TouchPinch,
		callback = v6.onTouchPinch
	}) else nil
	v15.TouchPinchConnection = v19
	return createElement("ViewportFrame", v9, v15)
end

return ItemViewport
