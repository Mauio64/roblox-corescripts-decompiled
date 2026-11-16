local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactOtter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local iconButton = Foundation.IconButton
local text = Foundation.Text
local button = Foundation.Button
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local v5 = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function isFullWidth(p2): boolean
	return p2 < 540
end

local function getAnchorPoint(screenSize)
	if screenSize.X < 540 then
		return Vector2.new(0.5, 1)
	end

	return Vector2.new(0, 0)
end

local function getSize(screenSize, width, height)
	if screenSize.X < 540 then
		return UDim2.new(0, screenSize.X, 0, height)
	end

	return UDim2.new(0, width, 0, screenSize.Y)
end

local function getPosition(screenSize, width)
	if screenSize.X < 540 then
		return UDim2.new(0.5, 0, 1, 0)
	end

	return UDim2.new(1, -width, 0, 0)
end

local function SideModal(props)
	local v6 = useTokens()
	local state, setState = React.useState(getAnchorPoint(props.screenSize))
	local state2, setState2 = React.useState(getSize(props.screenSize, props.width, props.height))
	local state3, setState3 = React.useState(getPosition(props.screenSize, props.width))
	local state4, setState4 = React.useState(true)
	local state5, setState5 = React.useState(false)

	local v7 = React.useMemo(function()
		if props.footerContent then
			return (props.footerContent())
		end

		return nil
	end, { props.footerContent })
	local v8 = v7 and 35 or 0
	local v9, v10 = ReactOtter.useAnimatedBinding(1, function()
		if not state4 then
			if state5 then
				if props.buttonProps then
					props.buttonProps.onActivated()
				end
			elseif props.onAbandon then
				props.onAbandon()
			end
		end
	end)

	local v11 = React.useMemo(function(): number
		if state4 then
			return 0
		end

		return 1
	end, { state4 })

	React.useEffect(function()
		if props.closeWithAnimation then
			setState4(false)
		end
	end, { props.closeWithAnimation })

	React.useEffect(function()
		v10(ReactOtter.spring(v11, v5))
	end, { v11 })

	React.useEffect(function()
		setState(getAnchorPoint(props.screenSize))
		setState2(getSize(props.screenSize, props.width, props.height))
		setState3(getPosition(props.screenSize, props.width))
	end, { props.screenSize })

	local v12 = React.useCallback(function()
		setState4(false)
	end, { setState4 })

	local v13 = React.useCallback(function()
		if
			props.buttonProps
			and props.buttonProps.validateState
			and not props.buttonProps.validateState()
		then
			return
		end

		setState5(true)
		setState4(false)
	end, { setState4, setState5, props.buttonProps })

	local createElement = React.createElement
	local v15 = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v9:map(function(p2)
			return p2 + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = v12
	}

	local createElement2 = React.createElement
	local v18 = {
		AnchorPoint = Vector2.new(1, 0),
		Position = v9:map(function(p2)
			if props.screenSize.X < 540 then
				return (UDim2.new(1, 0, 0, props.height * p2))
			end

			return (UDim2.new(1, props.width * p2, 0, 0))
		end),
		tag = "size-full"
	}

	local createElement3 = React.createElement

	local v22 = {
		IconRow = React.createElement(
			view,
			{
				Size = UDim2.new(1, 0, 0, 32),
				tag = "padding-left-medium",
				LayoutOrder = 0
			},
			{
				IconButton = React.createElement(iconButton, {
					icon = "icons/navigation/pushBack",
					size = iconSize.Medium,
					tag = "anchor-center-left position-center-left",
					onActivated = v12
				})
			}
		),
		TitleRow = React.createElement(
			view,
			{ Size = UDim2.new(1, 0, 0, 32), tag = "auto-xy", LayoutOrder = 1 },
			{
				Title = React.createElement(text, {
					fontStyle = v6.Typography.TitleLarge,
					textStyle = v6.Color.Content.Emphasis,
					Text = props.title,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 32),
					tag = "auto-xy"
				})
			}
		),
		Content = 0,
		ButtonRow = 0,
		BottomFrame = 0
	}

	local createElement4 = React.createElement

	local v25 = if props.buttonProps then UDim2.new(1, 0, 1, -116 - v8) else UDim2.new(1, 0, 1, -84 - v8)
	v22.Content = createElement4(
		view,
		{
			ClipsDescendants = true,
			Size = v25,
			tag = "padding-x-medium",
			LayoutOrder = 2
		},
		{
			MiddleContent = React.createElement(view, { tag = "size-full" }, props.children)
		}
	)

	v22.ButtonRow = props.buttonProps
		and React.createElement(
			view,
			{
				Size = UDim2.new(1, 0, 0, 32),
				tag = "padding-x-medium padding-bottom-medium",
				LayoutOrder = 3
			},
			{
				Button = React.createElement(button, {
					text = props.buttonProps.text,
					variant = buttonVariant.Emphasis,
					onActivated = v13,
					isDisabled = false,
					size = buttonSize.Small,
					fillBehavior = fillBehavior.Fill
				})
			}
		)

	local v26 = if props.footerContent then React.createElement(view, {
		Size = UDim2.new(1, 0, 0, 32),
		tag = "padding-x-medium padding-bottom-medium",
		LayoutOrder = 4,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}, { FooterContent = v7 }) else nil
	v22.BottomFrame = v26
	return createElement("TextButton", v15, {
		SideModalContainer = createElement2(view, v18, {
			SideModal = createElement3(
				view,
				{
					AnchorPoint = state,
					Position = state3,
					Size = state2,
					tag = "bg-surface-300 radius-medium col"
				},
				v22
			)
		})
	})
end

return SideModal
