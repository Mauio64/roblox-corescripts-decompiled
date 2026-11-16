local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive")
local modalWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UIBlox").App.Dialog.Modal.ModalWindow
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local button = Foundation.Button
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local fillBehavior = Foundation.Enums.FillBehavior
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactUtils").Hooks.RoactRodux.useSelector
local wrapForReactPortal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Wrappers/wrapForReactPortal")
local useIsSpatial = Responsive.useIsSpatial

local useAXPartialPageModalFocusHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AXPartialPageModal/useAXPartialPageModalFocusHandler")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local defineFastFlag = game:DefineFastFlag("AXPartialPageModalDockedPadding", false)
local fFlagAXFixAvatarScreenVR = AvatarExperienceFlags.FFlagAXFixAvatarScreenVR
local fFlagAXPartialPageModalBackgroundShim = AvatarExperienceFlags.FFlagAXPartialPageModalBackgroundShim

local defineFastInt = game:DefineFastInt("AXCatalogPartialPageModalBottomInsetMultiplier", 25)

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function fn(p2)
	return p2.ScreenSize
end

local function fn2(p2)
	return p2.GlobalGuiInset and p2.GlobalGuiInset.bottom or 0
end

local function AXPartialPageModal(props)
	local v5 = useTokens()
	local v6 = useSelector(fn)
	local medium = v5.Margin.Medium
	local udim = UDim.new(0, v5.Margin.Medium)
	local ref = React.useRef(nil)
	local ref2 = if fFlagAXFixAvatarScreenVR then React.useRef(nil) else nil
	local state, setState

	if fFlagAXFixAvatarScreenVR then
		state, setState = React.useState(Vector2.new(360, 700))
	else
		setState = nil
	end

	local v7 = useSelector(fn2)

	local v8 = if fFlagAXFixAvatarScreenVR then useIsSpatial() else nil

	local v9 = useAXPartialPageModalFocusHandler(ref)

	if fFlagAXFixAvatarScreenVR then
		React.useLayoutEffect(function()
			if not v8 then
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

			local function syncSize()
				setState(surfaceGui.AbsoluteSize)
			end

			setState(surfaceGui.AbsoluteSize)

			local absoluteSizeChangedConnection = surfaceGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncSize)

			return function()
				absoluteSizeChangedConnection:Disconnect()
			end
		end, { v8, v9, setState })
	end

	if fFlagAXFixAvatarScreenVR then
		if not v8 then
			state = v6
		end
	else
		state = v6
	end

	if defineFastFlag then
		if state.X < 540 then
			udim = UDim.new(0, v5.Margin.Large + v7 * defineFastInt / 100)
		end
	elseif useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait then
		udim = UDim.new(0, v5.Margin.Large + v7 * defineFastInt / 100)
	end

	local position = if props.position then props.position else nil

	local function fn3()
		local children = {}

		if props.buttonStackProps == nil then
			return {}
		end

		local buttons = props.buttonStackProps.buttons

		for i, button2 in ipairs(buttons) do
			local props2 = buttons[i].props
			children[i] = React.createElement(view, {
				tag = "row gap-small wrap auto-y size-full-0 fill-x",
				key = props2.text or i
			}, React.createElement(button, {
				text = props2.text,
				variant = props2.variant,
				onActivated = props2.onActivated,
				LayoutOrder = props2.layoutOrder or i,
				fillBehavior = fillBehavior.Fill,
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

		for i, button2 in ipairs(buttons) do
			local props2 = buttons[i].props
			children[i] = React.createElement(button, {
				text = props2.text,
				key = props2.text or i,
				variant = props2.variant,
				width = UDim.new(1, 0),
				onActivated = props2.onActivated,
				LayoutOrder = props2.layoutOrder or i,
				fillBehavior = fillBehavior.Fill,
				size = props2.size
			})
		end

		return children
	end

	local v10 = props.visible == nil or props.visible
	local v11

	if fFlagAXPartialPageModalBackgroundShim then
		local createElement = React.createElement
		local v13 = {
			isFullHeight = false,
			screenSize = state,
			position = position,
			anchorPoint = props.anchorPoint
		}

		local createElement2 = React.createElement
		local v16 = {
			tag = "auto-y col size-full-0 align-x-left padding-x-xxlarge padding-top-xxlarge radius-medium",
			Position = UDim2.new(0, 0, 0, medium),
			backgroundStyle = v5.Color.Surface.Surface_100,
			padding = { bottom = udim },
			ref = 0,
			selectionGroup = 0
		}

		local v17 = if v9 == nil then ref else nil
		v16.ref = v17
		v16.selectionGroup = v9 == nil
			and {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			}
			or nil

		local v18 = {
			Content = React.createElement(view, { tag = "auto-y size-full-0" }, props.children),
			Buttons = 0
		}
		local v19 = props.buttonStackProps

		if v19 then
			local createElement3 = React.createElement
			local v21 = {
				tag = {
					["col gap-medium auto-y size-full-0 fill-x"] = not props.buttonStackProps.rowLayout,
					["row gap-small auto-y size-full-0 fill-x"] = props.buttonStackProps.rowLayout
				}
			}

			local v22 = if props.buttonStackProps.rowLayout then fn4() else fn3()
			v19 = createElement3(view, v21, v22)
		end

		v18.Buttons = v19
		local element = createElement(modalWindow, v13, {
			ContentContainer = createElement2(view, v16, v18)
		})

		if props.hasBackgroundShim == true then
			v11 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 5,
				Visible = v10,
				ref = if fFlagAXFixAvatarScreenVR then ref2 else nil
			}, {
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
			v11 = React.createElement("TextButton", {
				Text = "",
				AutoButtonColor = false,
				Selectable = false,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[React.Event.Activated] = props.onBackgroundPress,
				ZIndex = 5,
				Visible = v10,
				ref = if fFlagAXFixAvatarScreenVR then ref2 else nil
			}, { PartialPageModal = element })
		end
	else
		local createElement = React.createElement
		local onBackgroundPressesByActivated = {
			Text = "",
			AutoButtonColor = false,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Event.Activated] = props.onBackgroundPress,
			ZIndex = 5,
			Visible = v10,
			ref = if fFlagAXFixAvatarScreenVR then ref2 else nil
		}

		local createElement2 = React.createElement
		local v16 = {
			isFullHeight = false,
			screenSize = state,
			position = position,
			anchorPoint = props.anchorPoint
		}

		local createElement3 = React.createElement
		local v19 = {
			tag = "auto-y col size-full-0 align-x-left padding-x-xxlarge padding-top-xxlarge radius-medium",
			Position = UDim2.new(0, 0, 0, medium),
			backgroundStyle = v5.Color.Surface.Surface_100,
			padding = { bottom = udim },
			ref = 0,
			selectionGroup = 0
		}

		local v20 = if v9 == nil then ref else nil
		v19.ref = v20
		v19.selectionGroup = v9 == nil
			and {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			}
			or nil

		local v21 = {
			Content = React.createElement(view, { tag = "auto-y size-full-0" }, props.children),
			Buttons = 0
		}
		local v22 = props.buttonStackProps

		if v22 then
			local createElement4 = React.createElement
			local v24 = {
				tag = {
					["col gap-medium auto-y size-full-0 fill-x"] = not props.buttonStackProps.rowLayout,
					["row gap-small auto-y size-full-0 fill-x"] = props.buttonStackProps.rowLayout
				}
			}

			local v25 = if props.buttonStackProps.rowLayout then fn4() else fn3()
			v22 = createElement4(view, v24, v25)
		end

		v21.Buttons = v22
		v11 = createElement("TextButton", onBackgroundPressesByActivated, {
			PartialPageModal = createElement2(modalWindow, v16, {
				ContentContainer = createElement3(view, v19, v21)
			})
		})
	end

	if v9 == nil then
		return v11
	end

	return wrapForReactPortal(v11, v9, ref)
end

return AXPartialPageModal
