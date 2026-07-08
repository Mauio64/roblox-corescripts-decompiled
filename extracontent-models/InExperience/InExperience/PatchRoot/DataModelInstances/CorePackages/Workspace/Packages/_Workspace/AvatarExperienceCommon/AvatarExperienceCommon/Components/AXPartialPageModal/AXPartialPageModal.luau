local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local ModalWindow = require(Parent.UIBlox).App.Dialog.Modal.ModalWindow
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local FillBehavior = Foundation.Enums.FillBehavior
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local wrapForReactPortal = require(script.Parent.Parent.Wrappers.wrapForReactPortal)
local useIsSpatial = Responsive.useIsSpatial
local useAXPartialPageModalFocusHandler = require(script.Parent.useAXPartialPageModalFocusHandler)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local v15 = game:DefineFastFlag("AXPartialPageModalDockedPadding", false)
local FFlagAXFixAvatarScreenVR = AvatarExperienceFlags.FFlagAXFixAvatarScreenVR
local FFlagAXPartialPageModalBackgroundShim = AvatarExperienceFlags.FFlagAXPartialPageModalBackgroundShim
local v18 = game:DefineFastInt("AXCatalogPartialPageModalBottomInsetMultiplier", 25)

local function selectDeviceOrientation(p1) -- line: 35
	return p1.DeviceOrientation
end
local function v20(p2) -- line: 56
	return p2.ScreenSize
end
local function v21(p3) -- line: 60
	return p3.GlobalGuiInset and p3.GlobalGuiInset.bottom or 0
end
local function AXPartialPageModal(t1: {[any]: any}) -- line: 64
	-- upvalues: useTokens (copy), useSelector (copy), v20 (copy), React (copy), FFlagAXFixAvatarScreenVR (copy), v21 (copy), useIsSpatial (copy), useAXPartialPageModalFocusHandler (copy), v15 (copy), v18 (copy), selectDeviceOrientation (copy), Responsive (copy), View (copy), Button (copy), FillBehavior (copy), FFlagAXPartialPageModalBackgroundShim (copy), ModalWindow (copy), wrapForReactPortal (copy)
	local v27 = useTokens()
	local v28 = useSelector(v20)
	local Medium = v27.Margin.Medium
	local uDim = UDim.new(0, v27.Margin.Medium)
	local v31 = React.useRef(nil)
	local v32 = if not FFlagAXFixAvatarScreenVR then nil else React.useRef(nil)
	local v33 = nil
	local u34 = nil

	if FFlagAXFixAvatarScreenVR then
		local v35

		v33, v35 = React.useState(Vector2.new(360, 700))
		u34 = v35
	end

	local v36 = useSelector(v21)
	local v37 = if not FFlagAXFixAvatarScreenVR then nil else useIsSpatial()
	local v38 = useAXPartialPageModalFocusHandler(v31)

	if FFlagAXFixAvatarScreenVR then
		React.useLayoutEffect(function() -- line: 84
			-- upvalues: v37 (copy), v32 (copy), u34 (ref)
			if not v37 then
				return
			end

			local current = v32.current

			if current == nil then
				return
			end

			local SurfaceGui = current:FindFirstAncestorOfClass("SurfaceGui")

			if SurfaceGui == nil then
				return
			end

			local function syncSize() -- line: 98
				-- upvalues: u34 (ref), SurfaceGui (copy)
				u34(SurfaceGui.AbsoluteSize)
			end

			u34(SurfaceGui.AbsoluteSize)

			local connection = SurfaceGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncSize)

			return function() -- line: 104
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {
			v37,
			v38,
			u34
		})
	end

	local v39 = if not FFlagAXFixAvatarScreenVR or not v37 then v28 else v33

	if v15 then
		if v39.X < 540 then
			uDim = UDim.new(0, v27.Margin.Large + v36 * v18 / 100)
		end
	elseif useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait then
		uDim = UDim.new(0, v27.Margin.Large + v36 * v18 / 100)
	end

	local position = nil

	if t1.position then
		position = t1.position
	end

	local function v41() -- line: 134
		-- upvalues: t1 (copy), React (copy), View (copy), Button (copy), FillBehavior (copy)
		local t2 = {}

		if t1.buttonStackProps == nil then
			return {}
		end

		local buttons = t1.buttonStackProps.buttons

		for i, _ in ipairs(buttons) do
			local props = buttons[i].props

			t2[i] = React.createElement(View, {
				tag = "row gap-small wrap auto-y size-full-0 fill-x",
				key = props.text or i
			}, React.createElement(Button, {
				text = props.text,
				variant = props.variant,
				onActivated = props.onActivated,
				LayoutOrder = props.layoutOrder or i,
				fillBehavior = FillBehavior.Fill,
				size = props.size
			}))
		end

		return t2
	end
	local function v42() -- line: 164
		-- upvalues: t1 (copy), React (copy), Button (copy), FillBehavior (copy)
		local t3 = {}

		if t1.buttonStackProps == nil then
			return {}
		end

		local buttons = t1.buttonStackProps.buttons

		for i, _ in ipairs(buttons) do
			local props = buttons[i].props

			t3[i] = React.createElement(Button, {
				text = props.text,
				key = props.text or i,
				variant = props.variant,
				width = UDim.new(1, 0),
				onActivated = props.onActivated,
				LayoutOrder = props.layoutOrder or i,
				fillBehavior = FillBehavior.Fill,
				size = props.size
			})
		end

		return t3
	end

	local v43 = t1.visible == nil or t1.visible
	local v45

	if FFlagAXPartialPageModalBackgroundShim then
		local v44 = React.createElement(ModalWindow, {
			isFullHeight = false,
			screenSize = v39,
			position = position,
			anchorPoint = t1.anchorPoint
		}, {
			ContentContainer = React.createElement(View, {
				tag = "auto-y col size-full-0 align-x-left padding-x-xxlarge padding-top-xxlarge radius-medium",
				Position = UDim2.new(0, 0, 0, Medium),
				backgroundStyle = v27.Color.Surface.Surface_100,
				padding = {
					bottom = uDim
				},
				ref = if v38 ~= nil then nil else v31,
				selectionGroup = if v38 ~= nil then nil else {
					SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
					SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
					SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
					SelectionBehaviorRight = Enum.SelectionBehavior.Stop
				}
			}, {
				Content = React.createElement(View, {
					tag = "auto-y size-full-0"
				}, t1.children),
				Buttons = t1.buttonStackProps and React.createElement(View, {
					tag = {
						["col gap-medium auto-y size-full-0 fill-x"] = not t1.buttonStackProps.rowLayout,
						["row gap-small auto-y size-full-0 fill-x"] = t1.buttonStackProps.rowLayout
					}
				}, if not t1.buttonStackProps.rowLayout then v41() else v42())
			})
		})

		v45 = if t1.hasBackgroundShim ~= true then React.createElement("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Event.Activated] = t1.onBackgroundPress,
			ZIndex = 5,
			Visible = v43,
			ref = if not FFlagAXFixAvatarScreenVR then nil else v32
		}, {
			PartialPageModal = v44
		}) else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 5,
			Size = UDim2.fromScale(1, 1),
			Visible = v43,
			ref = if not FFlagAXFixAvatarScreenVR then nil else v32
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
				[React.Event.Activated] = t1.onBackgroundPress
			}),
			SheetLayer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				PartialPageModal = v44
			})
		})
	else
		v45 = React.createElement("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Event.Activated] = t1.onBackgroundPress,
			ZIndex = 5,
			Visible = v43,
			ref = if not FFlagAXFixAvatarScreenVR then nil else v32
		}, {
			PartialPageModal = React.createElement(ModalWindow, {
				isFullHeight = false,
				screenSize = v39,
				position = position,
				anchorPoint = t1.anchorPoint
			}, {
				ContentContainer = React.createElement(View, {
					tag = "auto-y col size-full-0 align-x-left padding-x-xxlarge padding-top-xxlarge radius-medium",
					Position = UDim2.new(0, 0, 0, Medium),
					backgroundStyle = v27.Color.Surface.Surface_100,
					padding = {
						bottom = uDim
					},
					ref = if v38 ~= nil then nil else v31,
					selectionGroup = if v38 ~= nil then nil else {
						SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
						SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
						SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
						SelectionBehaviorRight = Enum.SelectionBehavior.Stop
					}
				}, {
					Content = React.createElement(View, {
						tag = "auto-y size-full-0"
					}, t1.children),
					Buttons = t1.buttonStackProps and React.createElement(View, {
						tag = {
							["col gap-medium auto-y size-full-0 fill-x"] = not t1.buttonStackProps.rowLayout,
							["row gap-small auto-y size-full-0 fill-x"] = t1.buttonStackProps.rowLayout
						}
					}, if not t1.buttonStackProps.rowLayout then v41() else v42())
				})
			})
		})
	end

	if v38 ~= nil then
		return wrapForReactPortal(v45, v38, v31)
	end

	return v45
end

return AXPartialPageModal
