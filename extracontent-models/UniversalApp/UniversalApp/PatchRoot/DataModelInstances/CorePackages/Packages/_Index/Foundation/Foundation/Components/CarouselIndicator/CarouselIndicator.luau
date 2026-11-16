local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactUtils = require(parent.ReactUtils)
local useRefCache = ReactUtils.useRefCache

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Dot = require(script.Parent.Dot)
local getCarouselIndicatorDotsConfig = require(script.Parent.getCarouselIndicatorDotsConfig)

local function getDotCenter(dots, p: number, size_100: number)
	local v = math.max(#dots - 1, 0) * size_100
	local total = 0

	for k, item in dots do
		v += item.size

		if k < p then
			total += item.size + size_100
		elseif k == p then
			total += item.size / 2
		end
	end

	return total - v / 2
end

local v = { page = 1, count = 5, testId = "--foundation-carousel-indicator" }

local function CarouselIndicator(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local count = v2.count
	local size_100 = v3.Size.Size_100
	local size_200 = v3.Size.Size_200
	local size_100_2 = v3.Size.Size_100
	local v4 = math.min(5, count)
	local v5 = v4 * size_200 + (v4 - 1) * size_100

	local current2 = React.useMemo(function()
		return getCarouselIndicatorDotsConfig(size_200, size_100_2, v2.page, count)
	end, { size_200, size_100_2, v2.page, count })

	local ref = React.useRef(nil)

	local v6, v7 = ReactOtter.useAnimatedBinding(0)
	local v8 = useRefCache()

	local v9 = React.useMemo(function()
		return { easingStyle = v3.Ease.StandardOut, duration = v3.Time.Time_200 }
	end, { v3 })

	React.useEffect(function()
		local current = ref.current
		ref.current = current2

		if not current or current.count ~= current2.count or current.page == current2.page then
			v7((ReactOtter.instant(0)))

			return
		end

		local v10 = current2.page - current.page
		local v11 = math.clamp(current.activeVisibleIndex + v10, 1, #current.dots)
		local v12 = getDotCenter(current.dots, v11, size_100) - getDotCenter(
			current2.dots,
			current2.activeVisibleIndex,
			size_100
		)

		v7(ReactOtter.ease(0, {
			easingStyle = v9.easingStyle,
			duration = v9.duration,
			startingValue = v6:getValue() + v12
		}))
	end, { current2, size_100, v9 })

	local colorEaseConfig = React.useMemo(function()
		return { easingStyle = v3.Ease.Linear, duration = v3.Time.Time_100 }
	end, { v3 })

	local scaleEaseConfig = React.useMemo(function()
		return { easingStyle = v3.Ease.StandardOut, duration = v3.Time.Time_300 }
	end, { v3 })

	React.useImperativeHandle(p2, function()
		if not v2.onActivated then
			return nil
		end

		local page = nil

		for _, dot in current2.dots do
			if not dot.isActive then
				page = dot.page
				break
			end
		end

		if page then
			return v8[page].current
		end

		return nil
	end, { v8, current2.dots, v2.onActivated })

	local children = {}

	for k, dot in current2.dots do
		local v10 = current2.dots[k - 1]
		local v11 = current2.dots[k + 1]

		if v10 and v10.isActive then
			v10 = current2.dots[k - 2]
		end

		if v11 and v11.isActive then
			v11 = current2.dots[k + 2]
		end

		local formatted = `Page{dot.page}`
		local createElement = React.createElement
		local v12 = {
			LayoutOrder = k,
			scale = dot.size / size_200,
			isActive = dot.isActive,
			maxSize = size_200,
			page = dot.page,
			scaleEaseConfig = scaleEaseConfig,
			colorEaseConfig = colorEaseConfig,
			onActivated = 0,
			Selectable = 0,
			NextSelectionUp = 0,
			NextSelectionDown = 0,
			NextSelectionLeft = 0,
			NextSelectionRight = 0,
			ref = 0,
			testId = 0
		}
		local onActivated

		if not dot.isActive then
			onActivated = v2.onActivated
		end

		v12.onActivated = onActivated
		v12.Selectable = not dot.isActive and v2.onActivated ~= nil
		v12.NextSelectionUp = v2.NextSelectionUp
		v12.NextSelectionDown = v2.NextSelectionDown
		local nextSelectionLeft

		if v10 == nil then
			nextSelectionLeft = v2.NextSelectionLeft
		else
			nextSelectionLeft = v8[v10.page]
		end

		v12.NextSelectionLeft = nextSelectionLeft
		local nextSelectionRight

		if v11 == nil then
			nextSelectionRight = v2.NextSelectionRight
		else
			nextSelectionRight = v8[v11.page]
		end

		v12.NextSelectionRight = nextSelectionRight

		v12.ref = v8[dot.page]
		v12.testId = `{v2.testId}--page-{dot.page}`
		children[formatted] = createElement(Dot, v12)
	end

	local layout = React.useMemo(function()
		return {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, size_100),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}
	end, { size_100 })

	return React.createElement(View, withCommonProps(v2, { tag = "auto-xy" }), {
		Dots = React.createElement(View, {
			tag = "auto-y",
			Size = UDim2.fromOffset(v5, 0),
			layout = layout,
			Position = v6:map(function(p3)
				return UDim2.fromOffset(p3, 0)
			end),
			testId = `{v2.testId}--dots`
		}, children)
	})
end

return React.memo(React.forwardRef(CarouselIndicator))
