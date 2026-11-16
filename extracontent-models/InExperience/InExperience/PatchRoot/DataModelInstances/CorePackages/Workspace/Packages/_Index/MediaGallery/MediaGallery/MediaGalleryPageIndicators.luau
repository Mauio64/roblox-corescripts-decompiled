local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)
require(parent.ReactOtter)
require(parent.AppCommonLib)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local useIndicatorScrollAnimation = require(MediaGallery.Hooks.useIndicatorScrollAnimation)
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)
local MAX_VISIBLE_INDICATORS = MediaGalleryConstants.MAX_VISIBLE_INDICATORS

local function getDotAnchorPointAtIndex(i: number, previousItemIndex: number, currentItemIndex: number)
	if currentItemIndex < previousItemIndex then
		if i == previousItemIndex then
			return Vector2.new(1, 0.5)
		end

		if i == currentItemIndex then
			return Vector2.new(0, 0.5)
		end
	elseif previousItemIndex < currentItemIndex then
		if i == previousItemIndex then
			return Vector2.new(0, 0.5)
		end

		if i == currentItemIndex then
			return Vector2.new(1, 0.5)
		end
	end

	return Vector2.new(0.5, 0.5)
end

local function getDotPositionAtIndex(i: number, previousItemIndex: number, currentItemIndex: number)
	if currentItemIndex < previousItemIndex then
		if i == previousItemIndex then
			return UDim2.fromScale(1, 0.5)
		end

		if i == currentItemIndex then
			return UDim2.fromScale(0, 0.5)
		end
	elseif previousItemIndex < currentItemIndex then
		if i == previousItemIndex then
			return UDim2.fromScale(0, 0.5)
		end

		if i == currentItemIndex then
			return UDim2.fromScale(1, 0.5)
		end
	end

	return UDim2.fromScale(0.5, 0.5)
end

local function MediaGalleryPageIndicators(props)
	local v = useTokens()

	local size_100 = v.Size.Size_100
	local size_150 = v.Size.Size_150
	local size_200 = v.Size.Size_200
	local size_800 = v.Size.Size_800
	local small = v.Padding.Small

	local muted = v.DarkMode.Content.Muted
	local emphasis = v.DarkMode.Content.Emphasis

	local v2 = useIndicatorScrollAnimation({
		numberOfItems = props.numberOfItems,
		startIndex = props.startIndex,
		scrolledSignal = props.mediaGalleryScrolledSignal,
		useSpring = props.useSpring,
		springConfig = props.springConfig,
		indicatorSize = size_200,
		indicatorPadding = small
	})

	local v3 = math.min(props.numberOfItems, MAX_VISIBLE_INDICATORS)

	local v4 = React.useMemo(function()
		return (v3 - 1) * (size_200 + small) + size_800
	end, { v3, size_200, small, size_800 })

	local ref = React.useRef({})

	local v5 = React.useCallback(function(p: number)
		local v5 = math.min(v2.firstVisibleIndex + v3 - 1, props.numberOfItems)
		local v6 = v2.firstVisibleIndex > 1
		local v7 = v5 < props.numberOfItems

		if p == v2.currentItemIndex then
			return UDim2.fromOffset(size_800, size_200)
		end

		if v6 then
			if p < v2.firstVisibleIndex then
				return UDim2.fromOffset(0, 0)
			end

			if p == v2.firstVisibleIndex then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p == v2.firstVisibleIndex + 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		if v7 then
			if v5 < p then
				return UDim2.fromOffset(0, 0)
			end

			if p == v5 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p == v5 - 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		return UDim2.fromOffset(size_200, size_200)
	end, {
		props.numberOfItems,
		v3,
		v2.firstVisibleIndex,
		v2.currentItemIndex,
		size_100,
		size_150,
		size_200,
		size_800
	})

	local v6 = React.useMemo(function()
		local children = {}

		for i = 1, props.numberOfItems do
			local v6 = ref.current[i]
			local v7 = v5(i)

			local v8 = "Indicator" .. i
			local createElement = React.createElement
			local v9

			if i == v2.currentItemIndex then
				v9 = size_800
			else
				v9 = size_200
			end

			local v10 = {
				Size = UDim2.fromOffset(v9, size_200),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i
			}

			local createElement2 = React.createElement
			local v11 = {
				AnchorPoint = getDotAnchorPointAtIndex(i, v2.previousItemIndex, v2.currentItemIndex),
				Position = getDotPositionAtIndex(i, v2.previousItemIndex, v2.currentItemIndex),
				Size = v2.animationProgressBinding:map(function(p: number)
					if v6 == nil then
						return v7
					end

					return v6:Lerp(v7, p)
				end),
				BackgroundColor3 = muted.Color3,
				BackgroundTransparency = muted.Transparency,
				BorderSizePixel = 0
			}

			local v12 = {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
				ProgressBar = 0
			}
			local progressBar

			if i == v2.currentItemIndex and props.currentItemProgressBinding then
				progressBar = React.createElement("Frame", {
					Size = props.currentItemProgressBinding:map(function(p: number)
						return UDim2.fromOffset(size_200 + p * (size_800 - size_200), size_200)
					end),
					BackgroundColor3 = emphasis.Color3,
					BackgroundTransparency = emphasis.Transparency,
					BorderSizePixel = 0
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
				})
			end

			v12.ProgressBar = progressBar
			children[v8] = createElement("Frame", v10, {
				Dot = createElement2("Frame", v11, v12)
			})
		end

		return children
	end, {
		props.numberOfItems,
		props.currentItemProgressBinding,
		v2.previousItemIndex,
		v2.currentItemIndex,
		v5,
		size_200,
		size_800,
		muted,
		emphasis,
		v2.animationProgressBinding
	})

	React.useEffect(function()
		for i = 1, props.numberOfItems do
			ref.current[i] = v5(i)
		end
	end, { props.numberOfItems, v5 })

	return React.createElement("ScrollingFrame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = UDim2.fromOffset(v4, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		ClipsDescendants = true,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollingEnabled = false,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.fromOffset(0, size_200),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasPosition = v2.canvasPositionBinding,
		Selectable = false
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, small),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v6)
	})
end

return React.memo(MediaGalleryPageIndicators)
