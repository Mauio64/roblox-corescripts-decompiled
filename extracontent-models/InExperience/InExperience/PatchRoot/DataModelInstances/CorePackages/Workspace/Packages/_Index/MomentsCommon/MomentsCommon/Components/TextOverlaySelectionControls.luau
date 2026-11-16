local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local FFlagMomentsTextOverlayV2Redesign = require(MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local View = Foundation.View
local Icon = Foundation.Icon
local BuilderIcons

if FFlagMomentsTextOverlayV2Redesign then
	BuilderIcons = require(parent.BuilderIcons)
else
	BuilderIcons = nil
end

local useTextOverlayPreviewGestures = require(MomentsCommon.Hooks.useTextOverlayPreviewGestures)

local color = Color3.fromHex("FFFFFF")

local color2 = Color3.fromHex("121215")
local style = { Color3 = Color3.fromHex("FFFFFF"), Transparency = 0 }

local udim = UDim.new(1, 0)

local function createBorderCornerHandle(p: string, onResizeHandleInputBegan, flag: boolean)
	local v = p == "TL" or p == "BL"
	local v2 = p == "TL" or p == "TR"

	local element = React.createElement("Frame", {
		AnchorPoint = Vector2.new(v and 0 or 1, 0.5),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(14, 3),
		ZIndex = 10
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim })
	})

	local element2 = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, v2 and 0 or 1),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(3, 14),
		ZIndex = 10
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim })
	})

	local createElement = React.createElement
	local v3 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromOffset(24, 24),
		ZIndex = 10
	}
	local hitArea

	if flag then
		hitArea = React.createElement("ImageButton", {
			Active = true,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 11,
			[React.Event.MouseButton1Down] = onResizeHandleInputBegan
		})
	end

	return createElement("Frame", v3, {
		Horizontal = element,
		Vertical = element2,
		HitArea = hitArea
	})
end

local function createZeroSizeCornerChrome(p: string, handle, visible: boolean)
	local vector2, udim2

	if p == "TL" then
		vector2 = Vector2.new(0, 0)
		udim2 = UDim2.fromScale(0, 0)
	elseif p == "TR" then
		vector2 = Vector2.new(1, 0)
		udim2 = UDim2.fromScale(1, 0)
	elseif p == "BL" then
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
	}, { Handle = handle })
end

local function TextOverlaySelectionControls(props)
	local preferredInput = Responsive.usePreferredInput()
	local v = useTextOverlayPreviewGestures({
		enabled = true,
		selected = true,
		preferredInput = preferredInput,
		containerRef = props.containerRef,
		scale = props.scale,
		rotation = props.rotation,
		onScaleChanged = props.onScaleChanged,
		onRotationChanged = props.onRotationChanged
	})

	local v2 = preferredInput == Responsive.Input.Pointer
	local v3 = {
		HandleTL = createZeroSizeCornerChrome(
			"TL",
			createBorderCornerHandle("TL", v.onResizeHandleInputBegan, v2),
			props.visible
		),
		HandleTR = createZeroSizeCornerChrome(
			"TR",
			createBorderCornerHandle("TR", v.onResizeHandleInputBegan, v2),
			props.visible
		),
		HandleBL = createZeroSizeCornerChrome(
			"BL",
			createBorderCornerHandle("BL", v.onResizeHandleInputBegan, v2),
			props.visible
		),
		HandleBR = createZeroSizeCornerChrome(
			"BR",
			createBorderCornerHandle("BR", v.onResizeHandleInputBegan, v2),
			props.visible
		)
	}

	if v2 and props.onRotationChanged ~= nil then
		v3.RotateChrome = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -props.borderGap, 0, props.borderGap),
			Size = UDim2.fromOffset(0, 0),
			Visible = props.visible,
			ZIndex = 10
		}, {
			RotateHandle = React.createElement(View, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				backgroundStyle = { Color3 = color2, Transparency = 0 },
				Position = UDim2.fromOffset(0, -28),
				Size = UDim2.fromOffset(32, 32),
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				tag = "radius-circle",
				ZIndex = 10
			}, {
				Glyph = React.createElement(Icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					name = BuilderIcons.Icon.ArrowSpinClockwise,
					size = Foundation.Enums.IconSize.Small,
					style = style
				}),
				HitArea = React.createElement("ImageButton", {
					Active = true,
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 11,
					[React.Event.MouseButton1Down] = v.onRotateHandleInputBegan
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, v3)
end

return TextOverlaySelectionControls
