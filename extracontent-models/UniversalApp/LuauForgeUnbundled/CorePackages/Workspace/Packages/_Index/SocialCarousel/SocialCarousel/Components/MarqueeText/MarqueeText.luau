local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")

local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local view = Foundation.View
local text = Foundation.Text

local MarqueeTextMotion = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/MarqueeText/MarqueeTextMotion")
local marqueePlayStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").MarqueePlayStatus

local function renderCopy(text2, fontStyle, p2, state)
	return React.createElement(text, {
		Text = text2,
		fontStyle = fontStyle,
		TextTruncate = Enum.TextTruncate.None,
		Size = UDim2.fromOffset(state, 0),
		Position = UDim2.fromOffset(p2, 0),
		tag = "auto-y text-align-x-left content-default"
	})
end

local function MarqueeText(props)
	local v5 = useTokens()
	local v6 = usePreferences()
	local fontStyle = props.fontStyle or v5.Typography.LabelSmall
	local v7 = if props.speed == nil then MarqueeTextMotion.DEFAULT_SPEED else props.speed
	local v8 = if props.maxLoops == nil then MarqueeTextMotion.DEFAULT_MAX_LOOPS else props.maxLoops
	local playStatus = props.playStatus or marqueePlayStatus.Playing
	local reducedMotion = if props.reducedMotion == nil then v6.reducedMotion else props.reducedMotion
	local v9 = props.direction

	if not v9 then
		local textDirectionFromLocale = MarqueeTextMotion.textDirectionFromLocale
		local LocalizationService = game:GetService("LocalizationService")
		v9 = textDirectionFromLocale(LocalizationService.RobloxLocaleId)
	end

	local heartbeat = props.heartbeat

	if not heartbeat then
		local RunService = game:GetService("RunService")
		heartbeat = RunService.Heartbeat
	end

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)

	local v10, v11 = React.useBinding(0)

	local ref = React.useRef(0)

	local ref2 = React.useRef(false)

	local travelDistance = MarqueeTextMotion.travelDistance(state, state2)
	local overflows = MarqueeTextMotion.overflows(state, state2)
	local v12

	if playStatus == marqueePlayStatus.Idle then
		v12 = false
	else
		v12 = not reducedMotion

		if v12 then
			v12 = travelDistance > 0 and (props.requiresOverflow ~= true or overflows)
		end
	end

	local v13 = v12 and not state3
	local v14 = v12 and state3 and props.holdForNextLoop == true

	local v15 = v13 and playStatus == marqueePlayStatus.Playing
	local v16 = v13 or v14
	local v17 = not v16 and overflows

	React.useEffect(function()
		ref.current = 0
		ref2.current = false
		v11(0)
		setState3(false)
	end, { props.text, v8, reducedMotion, props.runId })

	local v18 = React.useCallback(function(p2)
		if not v15 then
			return
		end

		local v19 = MarqueeTextMotion.advance(
			{ offset = v10:getValue(), loopsCompleted = ref.current, finished = false },
			travelDistance,
			v7,
			p2,
			v8
		)

		ref.current = v19.loopsCompleted

		if v19.finished then
			if ref2.current then
				return
			end

			ref2.current = true
			v11(0)
			setState3(true)

			if props.onFinished then
				props.onFinished()
			end
		else
			v11(v19.offset)
		end
	end, { v15, travelDistance, v7, v8, props.onFinished, v10 })

	React.useEffect(function()
		if not v15 then
			return function() end
		end

		local connection = heartbeat:Connect(v18)
		return function()
			connection:Disconnect()
		end
	end, { v15, heartbeat, v18 })

	local v19 = v9 == Enum.TextDirection.RightToLeft

	local mapped = v10:map(function(p2)
		if not v16 then
			return UDim2.fromOffset(0, 0)
		end

		local signedOffset = MarqueeTextMotion.signedOffset(p2, v9)

		if v19 then
			return UDim2.new(1, signedOffset, 0, 0)
		end

		return UDim2.fromOffset(signedOffset, 0)
	end)
	local v20

	if v16 then
		local v21 = travelDistance + state
		local createElement = React.createElement
		local v23 = {
			Size = UDim2.fromOffset(v21, 0),
			tag = "auto-y no-clip",
			AnchorPoint = 0,
			Position = 0
		}

		local v24 = if v19 then Vector2.new(1, 0) else Vector2.new(0, 0)
		v23.AnchorPoint = v24
		v23.Position = mapped
		v20 = createElement(view, v23, {
			Leading = renderCopy(props.text, fontStyle, not v19 and 0 or travelDistance, state),
			Trailing = renderCopy(props.text, fontStyle, v19 and 0 or travelDistance, state)
		})
	else
		local createElement = React.createElement
		local v22 = {
			Text = props.text,
			fontStyle = fontStyle,
			TextTruncate = 0,
			tag = 0,
			testId = "marquee-text"
		}

		local v23 = if v17 then Enum.TextTruncate.AtEnd else Enum.TextTruncate.None
		v22.TextTruncate = v23
		v22.tag = {
			["size-full-0 auto-y text-align-x-center text-truncate-end content-default"] = v17,
			["size-full-0 auto-y text-align-x-center content-default"] = not v17
		}
		v20 = createElement(text, v22)
	end

	return React.createElement(view, {
		tag = "size-full-0 auto-y clip",
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = function(p2)
			setState2(p2.AbsoluteSize.X)
		end
	}, {
		Measure = React.createElement(text, {
			Text = props.text,
			fontStyle = fontStyle,
			TextTransparency = 1,
			TextTruncate = Enum.TextTruncate.None,
			tag = "size-0 auto-x",
			onAbsoluteSizeChanged = function(p2)
				setState(p2.AbsoluteSize.X)
			end
		}),
		Content = v20
	})
end

return MarqueeText
