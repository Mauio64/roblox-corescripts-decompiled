local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeCalendarViewUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeLayoutUtilities = require(script.Parent.Parent.Utilities.DateTimeLayoutUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local ScrollView = require(Foundation.Components.ScrollView)
local StateLayerMode = require(Foundation.Enums.StateLayerMode)
local Text = require(Foundation.Components.Text)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { testId = "--foundation-time-list" }

local function TimeList(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local size_900 = v3.Size.Size_900
	local width = v2.width or UDim.new(0, DateTimeLayoutUtilities.TIME_LIST_WIDTH)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)
	local ref3 = React.useRef(true)
	local ref4 = React.useRef(nil)

	local v4, v5 = React.useMemo(function()
		local dateTime = v2.dateTime or v2.dayAnchor or DateTime.now()
		return DateTimeCalendarViewUtilities.getTimeSlotsForDay(dateTime)
	end, { v2.dateTime, v2.dayAnchor })

	if not v2.dateTime then
		v5 = nil
	end

	local function getTimeKey(p2: number?) -- 1 equivalent call inferred from this helper
		if p2 == nil then
			return nil
		end

		local localTime = DateTimeUtilities.toLocalTime(DateTime.fromUnixTimestamp(p2))
		return string.format("%02d:%02d", localTime.Hour, localTime.Minute)
	end

	React.useEffect(function()
		local timeKey = getTimeKey(v5) -- inferred equivalent call

		if ref2.current then
			ref2.current = false
			ref4.current = timeKey
			ref3.current = false
		else
			local current = ref.current

			if not current then
				return
			end

			local current2 = ref3.current
			ref3.current = false

			if timeKey == nil then
				ref4.current = nil
				return
			end

			if timeKey == ref4.current then
				return
			end

			if not current2 and ref4.current == nil then
				ref4.current = timeKey
				return
			end

			ref4.current = timeKey

			local timeSlotIndex = DateTimeCalendarViewUtilities.getTimeSlotIndex(v4, v5)

			if not timeSlotIndex then
				return
			end

			local v6 = (timeSlotIndex - 1) * size_900 - v2.height / 2 + size_900 / 2
			current.CanvasPosition = Vector2.new(0, (math.max(0, v6)))
		end
	end, { v5, v4, size_900, v2.height })

	local children = {}

	for k, v6 in v4 do
		local v7 = v6.id == v5
		local formatted = `slot-{v6.id}`
		local createElement = React.createElement
		local v8 = {
			LayoutOrder = k,
			Size = UDim2.new(1, 0, 0, size_900),
			Text = v6.text,
			textStyle = 0,
			backgroundStyle = 0,
			stateLayer = 0,
			onActivated = 0,
			tag = "size-full-0 auto-y padding-x-medium text-body-medium text-align-x-left text-align-y-center radius-medium",
			testId = 0
		}
		local textStyle

		if v7 then
			textStyle = v3.Inverse.Content.Emphasis
		end

		v8.textStyle = textStyle
		local backgroundStyle

		if v7 then
			backgroundStyle = v3.Color.System.Contrast
		end

		v8.backgroundStyle = backgroundStyle
		local mode

		if v7 then
			mode = StateLayerMode.Inverse
		else
			mode = StateLayerMode.Default
		end

		v8.stateLayer = { mode = mode }

		function v8.onActivated()
			ref2.current = true
			v2.onItemChanged(v6.id)
		end

		v8.testId = `{v2.testId}--slot-{k}`
		children[formatted] = createElement(Text, v8)
	end

	return React.createElement(ScrollView, {
		LayoutOrder = v2.LayoutOrder,
		Size = UDim2.new(width.Scale, width.Offset, 0, v2.height),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		scrollingFrameRef = ref,
		testId = v2.testId
	}, children)
end

return TimeList
