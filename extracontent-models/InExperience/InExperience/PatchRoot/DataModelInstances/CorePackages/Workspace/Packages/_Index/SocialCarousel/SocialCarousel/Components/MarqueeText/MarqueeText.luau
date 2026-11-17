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

	local ref = React.useRef(props.initialOffset == nil and 0 or props.initialOffset)

	local v6, v7 = React.useBinding(ref.current)

	local ref2 = React.useRef(0)

	local ref3 = React.useRef(false)
	local ref4 = React.useRef(props.saveOffset)
	ref4.current = props.saveOffset

	local travelDistance = MarqueeTextMotion.travelDistance(state, state2)
	local overflows = MarqueeTextMotion.overflows(state, state2)
	local v8

	if playStatus == MarqueePlayStatus.Idle then
		v8 = false
	else
		v8 = not (reducedMotion or state3)

		if v8 then
			if travelDistance > 0 then
				v8 = overflows or props.marqueeShortTitlesEnabled == true
			else
				v8 = false
			end
		end
	end

	if props.holdForNextLoop == true then
		if state3 then
			if playStatus == MarqueePlayStatus.Idle then
				state3 = false
			else
				state3 = not reducedMotion

				if state3 then
					if travelDistance > 0 then
						state3 = overflows or props.marqueeShortTitlesEnabled == true
					else
						state3 = false
					end
				end
			end
		end
	else
		state3 = false
	end

	local v9 = v8 and playStatus == MarqueePlayStatus.Playing
	local v10 = v8 or state3
	local sizefull0autoytextalignxcentertexttruncateendcontentdefault = not v10 and overflows

	React.useEffect(function()
		local current = ref.current
		ref.current = 0
		ref2.current = 0
		ref3.current = false
		v7(current)
		setState3(false)
		local current2 = ref4.current

		if current2 ~= nil then
			current2(current)
		end
	end, { props.text, v4, reducedMotion, props.runId, ref4 })

	local v11 = React.useCallback(function(p: number)
		if not v9 then
			return
		end

		local v11 = MarqueeTextMotion.advance(
			{ offset = v6:getValue(), loopsCompleted = ref2.current, finished = false },
			travelDistance,
			v3,
			p,
			v4
		)

		ref2.current = v11.loopsCompleted

		if v11.finished then
			if ref3.current then
				return
			end

			ref3.current = true
			v7(0)
			setState3(true)

			if props.onFinished then
				props.onFinished()
			end
		else
			v7(v11.offset)
			local current = ref4.current

			if current ~= nil then
				current(v11.offset)
			end
		end
	end, { v9, travelDistance, v3, v4, props.onFinished, v6, ref4 })

	React.useEffect(function()
		if not v9 then
			return function() end
		end

		local connection = heartbeat:Connect(v11)
		return function()
			connection:Disconnect()
		end
	end, { v9, heartbeat, v11 })

	React.useEffect(function()
		return function()
			if ref3.current then
				return
			end

			local current = ref4.current

			if current ~= nil then
				current(v6:getValue())
			end
		end
	end, { v6, ref4 })

	local v12 = v5 == Enum.TextDirection.RightToLeft

	local mapped = v6:map(function(p: number)
		if not v10 then
			return UDim2.fromOffset(0, 0)
		end

		local signedOffset = MarqueeTextMotion.signedOffset(p, v5)

		if v12 then
			return UDim2.new(1, signedOffset, 0, 0)
		end

		return UDim2.fromOffset(signedOffset, 0)
	end)
	local content

	if v10 then
		local v13 = travelDistance + state
		local createElement = React.createElement
		local v14 = {
			Size = UDim2.fromOffset(v13, 0),
			tag = "auto-y no-clip",
			AnchorPoint = 0,
			Position = 0
		}
		local anchorPoint

		if v12 then
			anchorPoint = Vector2.new(1, 0)
		else
			anchorPoint = Vector2.new(0, 0)
		end

		v14.AnchorPoint = anchorPoint
		v14.Position = mapped
		content = createElement(View, v14, {
			Leading = renderCopy(props.text, fontStyle, not v12 and 0 or travelDistance, state),
			Trailing = renderCopy(props.text, fontStyle, v12 and 0 or travelDistance, state)
		})
	else
		local createElement = React.createElement
		local v13 = {
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

		v13.TextTruncate = textTruncate
		v13.tag = {
			["size-full-0 auto-y text-align-x-center text-truncate-end content-default"] = sizefull0autoytextalignxcentertexttruncateendcontentdefault,
			["size-full-0 auto-y text-align-x-center content-default"] = not sizefull0autoytextalignxcentertexttruncateendcontentdefault
		}
		content = createElement(Text, v13)
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
