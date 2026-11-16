local TweenService = game:GetService("TweenService")

local parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(parent.ExpChatShared)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local PresetCooldownContext = require(script.Parent.PresetCooldownContext)

local v = ExpChatShared.Flags.FIntPresetChatCooldownLuaMs / 1000

local function PresetMessageButton(props)
	local v2 = Foundation.Hooks.useTokens()
	local circle = v2.Radius.Circle
	local v3 = React.useContext(PresetCooldownContext)
	local isDisabled = not (v3 == nil) and v3.isCooldownActive
	local endsAt

	if v3 == nil then
		endsAt = nil
	else
		endsAt = v3.endsAt
	end

	local onActivated = React.useCallback(function()
		props.onActivated(props.presetId)
	end, { props.onActivated, props.presetId })

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		if state == nil and p and p.AbsoluteSize.X > 0 then
			setState(p.AbsoluteSize)
		end
	end, { state })

	React.useEffect(function()
		if endsAt == nil or state == nil then
			return
		end

		local current = ref.current

		if current == nil then
			return
		end

		local v4 = endsAt - os.clock()

		if v4 <= 0 then
			return
		end

		local v5 = math.clamp(v4 / v, 0, 1)
		current.Size = UDim2.fromOffset(state.X * v5, state.Y)
		local tween = TweenService:Create(current, TweenInfo.new(v4, Enum.EasingStyle.Linear), {
			Size = UDim2.fromOffset(0, state.Y)
		})

		tween:Play()
		return function()
			tween:Cancel()
			tween:Destroy()
		end
	end, { endsAt, state })

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		LayoutOrder = props.layoutOrder or 0,
		tag = "size-0-800 auto-x radius-circle clip",
		backgroundStyle = v2.Color.ActionStandard.Background,
		onActivated = onActivated,
		isDisabled = isDisabled,
		cursor = {
			radius = UDim.new(0, circle),
			offset = math.floor(v2.Stroke.Thicker) * 2,
			borderWidth = math.floor(v2.Stroke.Thicker)
		},
		ref = props.buttonRef
	}
	local cooldownClipFrame

	if isDisabled and endsAt ~= nil and state ~= nil then
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
				BackgroundColor3 = v2.Color.Shift.Shift_400.Color3,
				BackgroundTransparency = v2.Color.Shift.Shift_400.Transparency,
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
			textStyle = v2.Color.ActionStandard.Foreground,
			tag = "size-0-full auto-x text-label-medium",
			padding = {
				left = UDim.new(0, v2.Padding.Medium),
				right = UDim.new(0, v2.Padding.Medium)
			},
			ZIndex = 2
		})
	})
end

return React.memo(PresetMessageButton)
