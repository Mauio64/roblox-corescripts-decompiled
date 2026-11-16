local TweenService = game:GetService("TweenService")

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(ChatUIPrimitives.UniversalMessage.Types)

local FFlagExpChatExpressionPillSelectableOnCooldown = require(ChatUIPrimitives.Flags.FFlagExpChatExpressionPillSelectableOnCooldown)

local function ExpressionPillView(props)
	local v = Foundation.Hooks.useTokens()
	local circle = v.Radius.Circle
	local cooldownEndsAt = props.cooldownEndsAt
	local cooldownDurationSeconds = props.cooldownDurationSeconds
	local v2

	if cooldownEndsAt == nil then
		v2 = false
	else
		v2 = os.clock() < cooldownEndsAt
	end

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		if state == nil and p and p.AbsoluteSize.X > 0 then
			setState(p.AbsoluteSize)
		end
	end, { state })

	local v3 = React.useCallback(function()
		props.onActivated(props.content)
	end, { props.onActivated, props.content })
	local onActivated

	if FFlagExpChatExpressionPillSelectableOnCooldown then
		onActivated = React.useCallback(function()
			if cooldownEndsAt ~= nil and cooldownEndsAt > os.clock() then
				return
			end

			v3()
		end, { cooldownEndsAt, v3 })
	else
		onActivated = v3
	end

	React.useEffect(function()
		if cooldownEndsAt == nil or state == nil then
			return
		end

		local current = ref.current

		if current == nil then
			return
		end

		local v4 = cooldownEndsAt - os.clock()

		if v4 <= 0 then
			return
		end

		local v5 = math.clamp(v4 / cooldownDurationSeconds, 0, 1)
		current.Size = UDim2.fromOffset(state.X * v5, state.Y)
		local tween = TweenService:Create(current, TweenInfo.new(v4, Enum.EasingStyle.Linear), {
			Size = UDim2.fromOffset(0, state.Y)
		})

		tween:Play()
		return function()
			tween:Cancel()
			tween:Destroy()
		end
	end, { cooldownEndsAt, state, cooldownDurationSeconds })

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		LayoutOrder = props.layoutOrder or 0,
		tag = "size-0-800 auto-x radius-circle clip",
		backgroundStyle = v.Color.ActionStandard.Background,
		onActivated = onActivated,
		isDisabled = not FFlagExpChatExpressionPillSelectableOnCooldown and v2,
		cursor = {
			radius = UDim.new(0, circle),
			offset = math.floor(v.Stroke.Thicker) * 2,
			borderWidth = math.floor(v.Stroke.Thicker)
		},
		ref = props.buttonRef
	}
	local cooldownClipFrame

	if v2 and cooldownEndsAt ~= nil and state ~= nil then
		cooldownClipFrame = React.createElement("Frame", {
			ref = ref,
			Size = UDim2.fromOffset(state.X, state.Y),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			ZIndex = 1
		}, {
			CooldownOverlay = React.createElement("Frame", {
				Size = UDim2.new(0, state.X, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v.Color.Shift.Shift_400.Color3,
				BackgroundTransparency = v.Color.Shift.Shift_400.Transparency,
				BorderSizePixel = 0
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, circle) })
			})
		})
	end

	return createElement(view, v4, {
		CooldownClipFrame = cooldownClipFrame,
		Text = React.createElement(Foundation.Text, {
			Text = props.text,
			textStyle = v.Color.ActionStandard.Foreground,
			tag = "size-0-full auto-x text-label-medium",
			padding = {
				left = UDim.new(0, v.Padding.Medium),
				right = UDim.new(0, v.Padding.Medium)
			},
			ZIndex = 2
		})
	})
end

return React.memo(ExpressionPillView)
