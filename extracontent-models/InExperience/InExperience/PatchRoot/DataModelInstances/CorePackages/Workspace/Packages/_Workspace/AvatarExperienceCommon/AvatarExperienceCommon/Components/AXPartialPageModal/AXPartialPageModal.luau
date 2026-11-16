local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local UIBlox = require(parent.UIBlox)
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local FillBehavior = Foundation.Enums.FillBehavior
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local wrapForReactPortal = require(script.Parent.Parent.Wrappers.wrapForReactPortal)
local useIsSpatial = Responsive.useIsSpatial

local useAXPartialPageModalFocusHandler = require(script.Parent.useAXPartialPageModalFocusHandler)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local defineFastFlag = game:DefineFastFlag("AXPartialPageModalDockedPadding", false)
local FFlagAXFixAvatarScreenVR = AvatarExperienceFlags.FFlagAXFixAvatarScreenVR
local FFlagAXPartialPageModalBackgroundShim = AvatarExperienceFlags.FFlagAXPartialPageModalBackgroundShim

local defineFastInt = game:DefineFastInt("AXCatalogPartialPageModalBottomInsetMultiplier", 25)

local function selectDeviceOrientation(p)
	return p.DeviceOrientation
end

local function fn(p)
	return p.ScreenSize
end

local function fn2(p)
	return p.GlobalGuiInset and p.GlobalGuiInset.bottom or 0
end

local function AXPartialPageModal(props)
	local v = useTokens()
	local v2 = useSelector(fn)
	local medium = v.Margin.Medium
	local udim = UDim.new(0, v.Margin.Medium)
	local ref = React.useRef(nil)
	local ref2

	if FFlagAXFixAvatarScreenVR then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local state, setState

	if FFlagAXFixAvatarScreenVR then
		state, setState = React.useState(Vector2.new(360, 700))
	else
		setState = nil
	end

	local v3 = useSelector(fn2)
	local v4

	if FFlagAXFixAvatarScreenVR then
		v4 = useIsSpatial()
	else
		v4 = nil
	end

	local v5 = useAXPartialPageModalFocusHandler(ref)

	if FFlagAXFixAvatarScreenVR then
		React.useLayoutEffect(function()
			if not v4 then
				return
			end

			local current = ref2.current

			if current == nil then
				return
			end

			local surfaceGui = current:FindFirstAncestorOfClass("SurfaceGui")

			if surfaceGui == nil then
				return
			end

			local function syncSize() -- 1 equivalent call inferred from this helper
				setState(surfaceGui.AbsoluteSize)
			end

			syncSize() -- inferred equivalent call
			local absoluteSizeChangedConnection = surfaceGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncSize)

			return function()
				absoluteSizeChangedConnection:Disconnect()
			end
		end, { v4, v5, setState })
	end

	if FFlagAXFixAvatarScreenVR then
		if not v4 then
			state = v2
		end
	else
		state = v2
	end

	if defineFastFlag then
		if state.X < 540 then
			udim = UDim.new(0, v.Margin.Large + v3 * defineFastInt / 100)
		end
	elseif useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait then
		udim = UDim.new(0, v.Margin.Large + v3 * defineFastInt / 100)
	end

	local position

	if props.position then
		position = props.position
	end

	local function fn3()
		local children = {}

		if props.buttonStackProps == nil then
			return {}
		end

		local buttons = props.buttonStackProps.buttons

		for i, _ in ipairs(buttons) do
			local props2 = buttons[i].props
			children[i] = React.createElement(View, {
				tag = "row gap-small wrap auto-y size-full-0 fill-x",
				key = props2.text or i
			}, React.createElement(Button, {
				text = props2.text,
				variant = props2.variant,
				onActivated = props2.onActivated,
				LayoutOrder = props2.layoutOrder or i,
				fillBehavior = FillBehavior.Fill,
				size = props2.size
			}))
		end

		return children
	end

	local function fn4()
		local children = {}

		if props.buttonStackProps == nil then
			return {}
		end

		local buttons = props.buttonStackProps.buttons

		for i, _ in ipairs(buttons) do
			local props2 = buttons[i].props
			children[i] = React.createElement(Button, {
				text = props2.text,
				key = props2.text or i,
				variant = props2.variant,
				width = UDim.new(1, 0),
				onActivated = props2.onActivated,
				LayoutOrder = props2.layoutOrder or i,
				fillBehavior = FillBehavior.Fill,
				size = props2.size
			})
		end

		return children
	end

	local visible = props.visible == nil or props.visible
	local v6

	if FFlagAXPartialPageModalBackgroundShim then
		local createElement = React.createElement
		local v7 = {
			isFullHeight = false,
			screenSize = state,
			position = position,
			anchorPoint = props.anchorPoint
		}

		local createElement2 = React.createElement
		local v8 = {
			tag = "auto-y col size-full-0 align-x-left padding-x-xxlarge padding-top-xxlarge radius-medium",
			Position = UDim2.new(0, 0, 0, medium),
			backgroundStyle = v.Color.Surface.Surface_100,
			padding = { bottom = udim },
			ref = 0,
			selectionGroup = 0
		}
		local ref3

		if v5 == nil then
			ref3 = ref
		end

		v8.ref = ref3
		v8.selectionGroup = v5 == nil
			and {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			}
			or nil

		local v9 = {
			Content = React.createElement(View, { tag = "auto-y size-full-0" }, props.children),
			Buttons = 0
		}
		local buttons = props.buttonStackProps

		if buttons then
			local createElement3 = React.createElement
			local v10 = {
				tag = {
					["col gap-medium auto-y size-full-0 fill-x"] = not props.buttonStackProps.rowLayout,
					["row gap-small auto-y size-full-0 fill-x"] = props.buttonStackProps.rowLayout
				}
			}
			local v11

			if props.buttonStackProps.rowLayout then
				v11 = fn4()
			else
				v11 = fn3()
			end

			buttons = createElement3(View, v10, v11)
		end

		v9.Buttons = buttons
		local element = createElement(ModalWindow, v7, {
			ContentContainer = createElement2(View, v8, v9)
		})

		if props.hasBackgroundShim == true then
			local createElement3 = React.createElement
			local v10 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 5,
				Visible = visible,
				ref = 0
			}
			local ref4

			if FFlagAXFixAvatarScreenVR then
				ref4 = ref2
			end

			v10.ref = ref4
			v6 = createElement3("Frame", v10, {
				Scrim = React.createElement("TextButton", {
					Text = "",
					AutoButtonColor = false,
					Selectable = false,
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color3.new(0, 0, 0),
					BackgroundTransparency = 0.45,
					BorderSizePixel = 0,
					ZIndex = 1,
					[React.Event.Activated] = props.onBackgroundPress
				}),
				SheetLayer = React.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						ZIndex = 2
					},
					{ PartialPageModal = element }
				)
			})
		else
			local createElement3 = React.createElement
			local onBackgroundPressesByActivated = {
				["Text"] = nil,
				Text = "",
				AutoButtonColor = false,
				Selectable = false,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[React.Event.Activated] = props.onBackgroundPress,
				ZIndex = 5,
				Visible = visible
			}
			local ref4

			if FFlagAXFixAvatarScreenVR then
				ref4 = ref2
			end

			onBackgroundPressesByActivated.ref = ref4
			v6 = createElement3("TextButton", onBackgroundPressesByActivated, {
				PartialPageModal = element
			})
		end
	else
		local createElement = React.createElement
		local onBackgroundPressesByActivated = {
			["Text"] = nil,
			Text = "",
			AutoButtonColor = false,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Event.Activated] = props.onBackgroundPress,
			ZIndex = 5,
			Visible = visible
		}
		local ref3

		if FFlagAXFixAvatarScreenVR then
			ref3 = ref2
		end

		onBackgroundPressesByActivated.ref = ref3

		local createElement2 = React.createElement
		local v7 = {
			isFullHeight = false,
			screenSize = state,
			position = position,
			anchorPoint = props.anchorPoint
		}

		local createElement3 = React.createElement
		local v8 = {
			tag = "auto-y col size-full-0 align-x-left padding-x-xxlarge padding-top-xxlarge radius-medium",
			Position = UDim2.new(0, 0, 0, medium),
			backgroundStyle = v.Color.Surface.Surface_100,
			padding = { bottom = udim },
			ref = 0,
			selectionGroup = 0
		}
		local ref4

		if v5 == nil then
			ref4 = ref
		end

		v8.ref = ref4
		v8.selectionGroup = v5 == nil
			and {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			}
			or nil

		local v9 = {
			Content = React.createElement(View, { tag = "auto-y size-full-0" }, props.children),
			Buttons = 0
		}
		local buttons = props.buttonStackProps

		if buttons then
			local createElement4 = React.createElement
			local v10 = {
				tag = {
					["col gap-medium auto-y size-full-0 fill-x"] = not props.buttonStackProps.rowLayout,
					["row gap-small auto-y size-full-0 fill-x"] = props.buttonStackProps.rowLayout
				}
			}
			local v11

			if props.buttonStackProps.rowLayout then
				v11 = fn4()
			else
				v11 = fn3()
			end

			buttons = createElement4(View, v10, v11)
		end

		v9.Buttons = buttons
		v6 = createElement("TextButton", onBackgroundPressesByActivated, {
			PartialPageModal = createElement2(ModalWindow, v7, {
				ContentContainer = createElement3(View, v8, v9)
			})
		})
	end

	if v5 == nil then
		return v6
	end

	return wrapForReactPortal(v6, v5, ref)
end

return AXPartialPageModal
