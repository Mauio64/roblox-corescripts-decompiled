local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local View = Foundation.View
local Text = Foundation.Text

local MarqueeTextMotion = require(script.Parent.MarqueeTextMotion)
local Enums = require(SocialCarousel.Common.Enums)
local MarqueePlayStatus = Enums.MarqueePlayStatus

local function renderCopy(text: string, fontStyle, p: number, state: number)
	return React.createElement(Text, {
		Text = text,
		fontStyle = fontStyle,
		TextTruncate = Enum.TextTruncate.None,
		Size = UDim2.fromOffset(state, 0),
		Position = UDim2.fromOffset(p, 0),
		tag = "auto-y text-align-x-left content-default"
	})
end

local function MarqueeText(props)
	local v = useTokens()
	local v2 = usePreferences()
	local fontStyle = props.fontStyle or v.Typography.LabelSmall
	local v3

	if props.speed == nil then
		v3 = MarqueeTextMotion.DEFAULT_SPEED
	else
		v3 = props.speed
	end

	local v4

	if props.maxLoops == nil then
		v4 = MarqueeTextMotion.DEFAULT_MAX_LOOPS
	else
		v4 = props.maxLoops
	end

	local playStatus = props.playStatus or MarqueePlayStatus.Playing
	local reducedMotion

	if props.reducedMotion == nil then
		reducedMotion = v2.reducedMotion
	else
		reducedMotion = props.reducedMotion
	end

	local v5 = props.direction

	if not v5 then
		local textDirectionFromLocale = MarqueeTextMotion.textDirectionFromLocale
		local LocalizationService = game:GetService("LocalizationService")
		v5 = textDirectionFromLocale(LocalizationService.RobloxLocaleId)
	end

	local heartbeat = props.heartbeat

	if not heartbeat then
		local RunService = game:GetService("RunService")
		heartbeat = RunService.Heartbeat
	end

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)

	local v6, v7 = React.useBinding(0)

	local ref = React.useRef(0)

	local ref2 = React.useRef(false)

	local travelDistance = MarqueeTextMotion.travelDistance(state, state2)
	local overflows = MarqueeTextMotion.overflows(state, state2)
	local v8

	if playStatus == MarqueePlayStatus.Idle then
		v8 = false
	else
		v8 = not reducedMotion

		if v8 then
			if travelDistance > 0 then
				v8 = props.requiresOverflow ~= true or overflows
			else
				v8 = false
			end
		end
	end

	local v9 = v8 and not state3
	local v10 = v8 and state3 and props.holdForNextLoop == true

	local v11 = v9 and playStatus == MarqueePlayStatus.Playing
	local v12 = v9 or v10
	local sizefull0autoytextalignxcentertexttruncateendcontentdefault = not v12 and overflows

	React.useEffect(function()
		ref.current = 0
		ref2.current = false
		v7(0)
		setState3(false)
	end, { props.text, v4, reducedMotion, props.runId })

	local v13 = React.useCallback(function(p: number)
		if not v11 then
			return
		end

		local v13 = MarqueeTextMotion.advance(
			{ offset = v6:getValue(), loopsCompleted = ref.current, finished = false },
			travelDistance,
			v3,
			p,
			v4
		)

		ref.current = v13.loopsCompleted

		if v13.finished then
			if ref2.current then
				return
			end

			ref2.current = true
			v7(0)
			setState3(true)

			if props.onFinished then
				props.onFinished()
			end
		else
			v7(v13.offset)
		end
	end, { v11, travelDistance, v3, v4, props.onFinished, v6 })

	React.useEffect(function()
		if not v11 then
			return function() end
		end

		local connection = heartbeat:Connect(v13)
		return function()
			connection:Disconnect()
		end
	end, { v11, heartbeat, v13 })

	local v14 = v5 == Enum.TextDirection.RightToLeft

	local mapped = v6:map(function(p: number)
		if not v12 then
			return UDim2.fromOffset(0, 0)
		end

		local signedOffset = MarqueeTextMotion.signedOffset(p, v5)

		if v14 then
			return UDim2.new(1, signedOffset, 0, 0)
		end

		return UDim2.fromOffset(signedOffset, 0)
	end)
	local content

	if v12 then
		local v15 = travelDistance + state
		local createElement = React.createElement
		local v16 = {
			Size = UDim2.fromOffset(v15, 0),
			tag = "auto-y no-clip",
			AnchorPoint = 0,
			Position = 0
		}
		local anchorPoint

		if v14 then
			anchorPoint = Vector2.new(1, 0)
		else
			anchorPoint = Vector2.new(0, 0)
		end

		v16.AnchorPoint = anchorPoint
		v16.Position = mapped
		content = createElement(View, v16, {
			Leading = renderCopy(props.text, fontStyle, not v14 and 0 or travelDistance, state),
			Trailing = renderCopy(props.text, fontStyle, v14 and 0 or travelDistance, state)
		})
	else
		local createElement = React.createElement
		local v15 = {
			Text = props.text,
			fontStyle = fontStyle,
			TextTruncate = 0,
			tag = 0,
			testId = "marquee-text"
		}
		local textTruncate

		if sizefull0autoytextalignxcentertexttruncateendcontentdefault then
			textTruncate = Enum.TextTruncate.AtEnd
		else
			textTruncate = Enum.TextTruncate.None
		end

		v15.TextTruncate = textTruncate
		v15.tag = {
			["size-full-0 auto-y text-align-x-center text-truncate-end content-default"] = sizefull0autoytextalignxcentertexttruncateendcontentdefault,
			["size-full-0 auto-y text-align-x-center content-default"] = not sizefull0autoytextalignxcentertexttruncateendcontentdefault
		}
		content = createElement(Text, v15)
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y clip",
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = function(p)
			setState2(p.AbsoluteSize.X)
		end
	}, {
		Measure = React.createElement(Text, {
			Text = props.text,
			fontStyle = fontStyle,
			TextTransparency = 1,
			TextTruncate = Enum.TextTruncate.None,
			tag = "size-0 auto-x",
			onAbsoluteSizeChanged = function(p)
				setState(p.AbsoluteSize.X)
			end
		}),
		Content = content
	})
end

return MarqueeText
