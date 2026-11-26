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

	local ref = React.useRef(props.initialOffset == nil and 0 or props.initialOffset)

	local v10, v11 = React.useBinding(ref.current)

	local ref2 = React.useRef(0)

	local ref3 = React.useRef(false)
	local ref4 = React.useRef(props.saveOffset)
	ref4.current = props.saveOffset

	local travelDistance = MarqueeTextMotion.travelDistance(state, state2)
	local overflows = MarqueeTextMotion.overflows(state, state2)
	local v12

	if playStatus == marqueePlayStatus.Idle then
		v12 = false
	else
		v12 = not (reducedMotion or state3)

		if v12 then
			v12 = travelDistance > 0 and (overflows or props.marqueeShortTitlesEnabled == true)
		end
	end

	if props.holdForNextLoop == true then
		if state3 then
			if playStatus == marqueePlayStatus.Idle then
				state3 = false
			else
				state3 = not reducedMotion

				if state3 then
					state3 = travelDistance > 0 and (overflows or props.marqueeShortTitlesEnabled == true)
				end
			end
		end
	else
		state3 = false
	end

	local v13 = v12 and playStatus == marqueePlayStatus.Playing
	local v14 = v12 or state3
	local v15 = not v14 and overflows

	React.useEffect(function()
		local current = ref.current
		ref.current = 0
		ref2.current = 0
		ref3.current = false
		v11(current)
		setState3(false)
		local current2 = ref4.current

		if current2 ~= nil then
			current2(current)
		end
	end, { props.text, v8, reducedMotion, props.runId, ref4 })

	local v16 = React.useCallback(function(p2)
		if not v13 then
			return
		end

		local v17 = MarqueeTextMotion.advance(
			{ offset = v10:getValue(), loopsCompleted = ref2.current, finished = false },
			travelDistance,
			v7,
			p2,
			v8
		)

		ref2.current = v17.loopsCompleted

		if v17.finished then
			if ref3.current then
				return
			end

			ref3.current = true
			v11(0)
			setState3(true)

			if props.onFinished then
				props.onFinished()
			end
		else
			v11(v17.offset)
			local current = ref4.current

			if current ~= nil then
				current(v17.offset)
			end
		end
	end, { v13, travelDistance, v7, v8, props.onFinished, v10, ref4 })

	React.useEffect(function()
		if not v13 then
			return function() end
		end

		local connection = heartbeat:Connect(v16)
		return function()
			connection:Disconnect()
		end
	end, { v13, heartbeat, v16 })

	React.useEffect(function()
		return function()
			if ref3.current then
				return
			end

			local current = ref4.current

			if current ~= nil then
				current(v10:getValue())
			end
		end
	end, { v10, ref4 })

	local v17 = v9 == Enum.TextDirection.RightToLeft

	local mapped = v10:map(function(p2)
		if not v14 then
			return UDim2.fromOffset(0, 0)
		end

		local signedOffset = MarqueeTextMotion.signedOffset(p2, v9)

		if v17 then
			return UDim2.new(1, signedOffset, 0, 0)
		end

		return UDim2.fromOffset(signedOffset, 0)
	end)
	local v18

	if v14 then
		local v19 = travelDistance + state
		local createElement = React.createElement
		local v21 = {
			Size = UDim2.fromOffset(v19, 0),
			tag = "auto-y no-clip",
			AnchorPoint = 0,
			Position = 0
		}

		local v22 = if v17 then Vector2.new(1, 0) else Vector2.new(0, 0)
		v21.AnchorPoint = v22
		v21.Position = mapped
		v18 = createElement(view, v21, {
			Leading = renderCopy(props.text, fontStyle, not v17 and 0 or travelDistance, state),
			Trailing = renderCopy(props.text, fontStyle, v17 and 0 or travelDistance, state)
		})
	else
		local createElement = React.createElement
		local v20 = {
			Text = props.text,
			fontStyle = fontStyle,
			TextTruncate = 0,
			tag = 0,
			testId = "marquee-text"
		}

		local v21 = if v15 then Enum.TextTruncate.AtEnd else Enum.TextTruncate.None
		v20.TextTruncate = v21
		v20.tag = {
			["size-full-0 auto-y text-align-x-center text-truncate-end content-default"] = v15,
			["size-full-0 auto-y text-align-x-center content-default"] = not v15
		}
		v18 = createElement(text, v20)
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
		Content = v18
	})
end

return MarqueeText
