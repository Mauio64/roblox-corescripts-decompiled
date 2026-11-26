local FFlagMomentsTextOverlayV2Redesign = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayV2Redesign")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Responsive")
local view = Foundation.View
local icon = Foundation.Icon

local v5 = if FFlagMomentsTextOverlayV2Redesign then require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/BuilderIcons") else nil

local useTextOverlayPreviewGestures = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useTextOverlayPreviewGestures")

local color = Color3.fromHex("FFFFFF")

local color2 = Color3.fromHex("121215")
local v6 = { Color3 = Color3.fromHex("FFFFFF"), Transparency = 0 }

local udim = UDim.new(1, 0)

local function createBorderCornerHandle(p2, onResizeHandleInputBegan, p3)
	local v7 = p2 == "TL" or p2 == "BL"
	local v8 = p2 == "TL" or p2 == "TR"

	local element = React.createElement("Frame", {
		AnchorPoint = Vector2.new(v7 and 0 or 1, 0.5),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(14, 3),
		ZIndex = 10
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim })
	})

	local element2 = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, v8 and 0 or 1),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(3, 14),
		ZIndex = 10
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim })
	})

	local createElement = React.createElement
	local v10 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromOffset(24, 24),
		ZIndex = 10
	}
	local v12

	if p3 then
		v12 = React.createElement("ImageButton", {
			Active = true,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 11,
			[React.Event.MouseButton1Down] = onResizeHandleInputBegan
		})
	end

	return createElement("Frame", v10, {
		Horizontal = element,
		Vertical = element2,
		HitArea = v12
	})
end

local function createZeroSizeCornerChrome(p2, p3, visible)
	local vector2, udim2

	if p2 == "TL" then
		vector2 = Vector2.new(0, 0)
		udim2 = UDim2.fromScale(0, 0)
	elseif p2 == "TR" then
		vector2 = Vector2.new(1, 0)
		udim2 = UDim2.fromScale(1, 0)
	elseif p2 == "BL" then
		vector2 = Vector2.new(0, 1)
		udim2 = UDim2.fromScale(0, 1)
	else
		vector2 = Vector2.new(1, 1)
		udim2 = UDim2.fromScale(1, 1)
	end

	return React.createElement("Frame", {
		AnchorPoint = vector2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = udim2,
		Size = UDim2.fromOffset(0, 0),
		Visible = visible,
		ZIndex = 10
	}, { Handle = p3 })
end

local function TextOverlaySelectionControls(props)
	local v7 = Responsive.usePreferredInput()
	local v8 = useTextOverlayPreviewGestures({
		enabled = true,
		selected = true,
		preferredInput = v7,
		containerRef = props.containerRef,
		scale = props.scale,
		rotation = props.rotation,
		onScaleChanged = props.onScaleChanged,
		onRotationChanged = props.onRotationChanged
	})

	local v9 = v7 == Responsive.Input.Pointer
	local v10 = {
		HandleTL = createZeroSizeCornerChrome(
			"TL",
			createBorderCornerHandle("TL", v8.onResizeHandleInputBegan, v9),
			props.visible
		),
		HandleTR = createZeroSizeCornerChrome(
			"TR",
			createBorderCornerHandle("TR", v8.onResizeHandleInputBegan, v9),
			props.visible
		),
		HandleBL = createZeroSizeCornerChrome(
			"BL",
			createBorderCornerHandle("BL", v8.onResizeHandleInputBegan, v9),
			props.visible
		),
		HandleBR = createZeroSizeCornerChrome(
			"BR",
			createBorderCornerHandle("BR", v8.onResizeHandleInputBegan, v9),
			props.visible
		)
	}

	if v9 and props.onRotationChanged ~= nil then
		v10.RotateChrome = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -props.borderGap, 0, props.borderGap),
			Size = UDim2.fromOffset(0, 0),
			Visible = props.visible,
			ZIndex = 10
		}, {
			RotateHandle = React.createElement(view, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				backgroundStyle = { Color3 = color2, Transparency = 0 },
				Position = UDim2.fromOffset(0, -28),
				Size = UDim2.fromOffset(32, 32),
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				tag = "radius-circle",
				ZIndex = 10
			}, {
				Glyph = React.createElement(icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					name = v5.Icon.ArrowSpinClockwise,
					size = Foundation.Enums.IconSize.Small,
					style = v6
				}),
				HitArea = React.createElement("ImageButton", {
					Active = true,
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 11,
					[React.Event.MouseButton1Down] = v8.onRotateHandleInputBegan
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, v10)
end

return TextOverlaySelectionControls
