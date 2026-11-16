local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local v = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function isFullWidth(x: number): boolean -- 4 equivalent calls inferred from this helper
	return x < 540
end

local function getAnchorPoint(screenSize: Vector2)
	if isFullWidth(screenSize.X) then -- inferred equivalent call
		return Vector2.new(0.5, 1)
	end

	return Vector2.new(0, 0)
end

local function getSize(screenSize: Vector2, width: number, height: number)
	if isFullWidth(screenSize.X) then -- inferred equivalent call
		return UDim2.new(0, screenSize.X, 0, height)
	end

	return UDim2.new(0, width, 0, screenSize.Y)
end

local function getPosition(screenSize: Vector2, width: number)
	if isFullWidth(screenSize.X) then -- inferred equivalent call
		return UDim2.new(0.5, 0, 1, 0)
	end

	return UDim2.new(1, -width, 0, 0)
end

local function SideModal(props)
	local v2 = useTokens()
	local state, setState = React.useState(getAnchorPoint(props.screenSize))
	local state2, setState2 = React.useState(getSize(props.screenSize, props.width, props.height))
	local state3, setState3 = React.useState(getPosition(props.screenSize, props.width))
	local state4, setState4 = React.useState(true)
	local state5, setState5 = React.useState(false)

	local footerContent = React.useMemo(function()
		if props.footerContent then
			return (props.footerContent())
		end

		return nil
	end, { props.footerContent })
	local v3 = footerContent and 35 or 0
	local v4, v5 = ReactOtter.useAnimatedBinding(1, function()
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

	local v6 = React.useMemo(function(): number
		return if state4 then 0 else 1
	end, { state4 })

	React.useEffect(function()
		if props.closeWithAnimation then
			setState4(false)
		end
	end, { props.closeWithAnimation })

	React.useEffect(function()
		v5(ReactOtter.spring(v6, v))
	end, { v6 })

	React.useEffect(function()
		setState(getAnchorPoint(props.screenSize))
		setState2(getSize(props.screenSize, props.width, props.height))
		setState3(getPosition(props.screenSize, props.width))
	end, { props.screenSize })

	local onActivated = React.useCallback(function()
		setState4(false)
	end, { setState4 })

	local onActivated2 = React.useCallback(function()
		if props.buttonProps and props.buttonProps.validateState and not props.buttonProps.validateState() then
			return
		end

		setState5(true)
		setState4(false)
	end, { setState4, setState5, props.buttonProps })

	local createElement = React.createElement
	local v7 = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v4:map(function(p: number)
			return p + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = onActivated
	}

	local createElement2 = React.createElement
	local v8 = {
		AnchorPoint = Vector2.new(1, 0),
		Position = v4:map(function(p: number)
			if isFullWidth(props.screenSize.X) then -- inferred equivalent call
				return (UDim2.new(1, 0, 0, props.height * p))
			end

			return (UDim2.new(1, props.width * p, 0, 0))
		end),
		tag = "size-full"
	}

	local createElement3 = React.createElement

	local v9 = {
		IconRow = React.createElement(
			View,
			{ Size = UDim2.new(1, 0, 0, 32), tag = "padding-left-medium", LayoutOrder = 0 },
			{
				IconButton = React.createElement(IconButton, {
					icon = "icons/navigation/pushBack",
					size = IconSize.Medium,
					tag = "anchor-center-left position-center-left",
					onActivated = onActivated
				})
			}
		),
		TitleRow = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 32),
			tag = "auto-xy",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Text, {
				fontStyle = v2.Typography.TitleLarge,
				textStyle = v2.Color.Content.Emphasis,
				Text = props.title,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 32),
				tag = "auto-xy"
			})
		}),
		Content = 0,
		ButtonRow = 0,
		BottomFrame = 0
	}

	local createElement4 = React.createElement
	local size

	if props.buttonProps then
		size = UDim2.new(1, 0, 1, -116 - v3)
	else
		size = UDim2.new(1, 0, 1, -84 - v3)
	end

	v9.Content = createElement4(
		View,
		{ ClipsDescendants = true, Size = size, tag = "padding-x-medium", LayoutOrder = 2 },
		{
			MiddleContent = React.createElement(View, { tag = "size-full" }, props.children)
		}
	)

	v9.ButtonRow = props.buttonProps
		and React.createElement(
			View,
			{
				Size = UDim2.new(1, 0, 0, 32),
				tag = "padding-x-medium padding-bottom-medium",
				LayoutOrder = 3
			},
			{
				Button = React.createElement(Button, {
					text = props.buttonProps.text,
					variant = ButtonVariant.Emphasis,
					onActivated = onActivated2,
					isDisabled = false,
					size = ButtonSize.Small,
					fillBehavior = FillBehavior.Fill
				})
			}
		)
	local bottomFrame

	if props.footerContent then
		bottomFrame = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 32),
			tag = "padding-x-medium padding-bottom-medium",
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}, { FooterContent = footerContent })
	end

	v9.BottomFrame = bottomFrame
	return createElement("TextButton", v7, {
		SideModalContainer = createElement2(View, v8, {
			SideModal = createElement3(
				View,
				{
					AnchorPoint = state,
					Position = state3,
					Size = state2,
					tag = "bg-surface-300 radius-medium col"
				},
				v9
			)
		})
	})
end

return SideModal
