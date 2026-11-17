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

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryPageIndicatorOpacity = SharedFlags.FFlagLuaAppMediaGalleryPageIndicatorOpacity

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
	local v2

	if FFlagLuaAppMediaGalleryPageIndicatorOpacity then
		v2 = v.Size.Size_600
	else
		v2 = v.Size.Size_800
	end

	local indicatorPadding

	if FFlagLuaAppMediaGalleryPageIndicatorOpacity then
		indicatorPadding = v.Size.Size_150
	else
		indicatorPadding = v.Padding.Small
	end

	local muted = v.DarkMode.Content.Muted
	local emphasis = v.DarkMode.Content.Emphasis
	local white

	if FFlagLuaAppMediaGalleryPageIndicatorOpacity then
		white = v.Color.Extended.White
	else
		white = nil
	end

	local v3 = useIndicatorScrollAnimation({
		numberOfItems = props.numberOfItems,
		startIndex = props.startIndex,
		scrolledSignal = props.mediaGalleryScrolledSignal,
		useSpring = props.useSpring,
		springConfig = props.springConfig,
		indicatorSize = size_200,
		indicatorPadding = indicatorPadding
	})

	local v4 = math.min(props.numberOfItems, MAX_VISIBLE_INDICATORS)

	local v5 = React.useMemo(function()
		return (v4 - 1) * (size_200 + indicatorPadding) + v2
	end, { v4, size_200, indicatorPadding, v2 })

	local ref = React.useRef({})

	local v6 = React.useCallback(function(p: number)
		local v6 = math.min(v3.firstVisibleIndex + v4 - 1, props.numberOfItems)
		local v7 = v3.firstVisibleIndex > 1
		local v8 = v6 < props.numberOfItems

		if p == v3.currentItemIndex then
			return UDim2.fromOffset(v2, size_200)
		end

		if v7 then
			if p < v3.firstVisibleIndex then
				return UDim2.fromOffset(0, 0)
			end

			if p == v3.firstVisibleIndex then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p == v3.firstVisibleIndex + 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		if v8 then
			if v6 < p then
				return UDim2.fromOffset(0, 0)
			end

			if p == v6 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p == v6 - 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		return UDim2.fromOffset(size_200, size_200)
	end, {
		props.numberOfItems,
		v4,
		v3.firstVisibleIndex,
		v3.currentItemIndex,
		size_100,
		size_150,
		size_200,
		v2
	})

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for i = 1, props.numberOfItems do
			local v7 = ref.current[i]
			local v8 = v6(i)
			local v9

			if FFlagLuaAppMediaGalleryPageIndicatorOpacity then
				if i == v3.currentItemIndex then
					if props.currentItemProgressBinding then
						v9 = muted
					else
						v9 = white.White_100
					end
				else
					v9 = white.White_20
				end
			else
				v9 = muted
			end

			local v10 = "Indicator" .. i
			local createElement = React.createElement
			local v11

			if i == v3.currentItemIndex then
				v11 = v2
			else
				v11 = size_200
			end

			local v12 = {
				Size = UDim2.fromOffset(v11, size_200),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i
			}

			local createElement2 = React.createElement
			local v13 = {
				AnchorPoint = getDotAnchorPointAtIndex(i, v3.previousItemIndex, v3.currentItemIndex),
				Position = getDotPositionAtIndex(i, v3.previousItemIndex, v3.currentItemIndex),
				Size = v3.animationProgressBinding:map(function(p: number)
					if v7 == nil then
						return v8
					end

					return v7:Lerp(v8, p)
				end),
				BackgroundColor3 = v9.Color3,
				BackgroundTransparency = v9.Transparency,
				BorderSizePixel = 0
			}

			local v14 = {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
				ProgressBar = 0
			}
			local progressBar

			if i == v3.currentItemIndex and props.currentItemProgressBinding then
				progressBar = React.createElement("Frame", {
					Size = props.currentItemProgressBinding:map(function(p: number)
						return UDim2.fromOffset(size_200 + p * (v2 - size_200), size_200)
					end),
					BackgroundColor3 = emphasis.Color3,
					BackgroundTransparency = emphasis.Transparency,
					BorderSizePixel = 0
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
				})
			end

			v14.ProgressBar = progressBar
			children[v10] = createElement("Frame", v12, {
				Dot = createElement2("Frame", v13, v14)
			})
		end

		return children
	end

	local numberOfItems = props.numberOfItems
	local currentItemProgressBinding = props.currentItemProgressBinding
	local previousItemIndex = v3.previousItemIndex
	local currentItemIndex = v3.currentItemIndex

	local animationProgressBinding = v3.animationProgressBinding
	local v7

	if FFlagLuaAppMediaGalleryPageIndicatorOpacity then
		v7 = white
	end

	local v8 = useMemo(fn, {
		numberOfItems,
		currentItemProgressBinding,
		previousItemIndex,
		currentItemIndex,
		v6,
		size_200,
		v2,
		muted,
		emphasis,
		animationProgressBinding,
		v7
	})

	React.useEffect(function()
		for i = 1, props.numberOfItems do
			ref.current[i] = v6(i)
		end
	end, { props.numberOfItems, v6 })

	return React.createElement("ScrollingFrame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = UDim2.fromOffset(v5, 0),
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
		CanvasPosition = v3.canvasPositionBinding,
		Selectable = false
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, indicatorPadding),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v8)
	})
end

return React.memo(MediaGalleryPageIndicators)
