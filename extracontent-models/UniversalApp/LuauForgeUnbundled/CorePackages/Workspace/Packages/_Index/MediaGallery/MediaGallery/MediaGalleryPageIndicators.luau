local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/ReactOtter")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/AppCommonLib")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Foundation").Hooks.useTokens

local useIndicatorScrollAnimation = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useIndicatorScrollAnimation")
local MAX_VISIBLE_INDICATORS = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants").MAX_VISIBLE_INDICATORS

local function getDotAnchorPointAtIndex(i, previousItemIndex, currentItemIndex)
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

local function getDotPositionAtIndex(i, previousItemIndex, currentItemIndex)
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
	local v5 = useTokens()

	local size_100 = v5.Size.Size_100
	local size_150 = v5.Size.Size_150
	local size_200 = v5.Size.Size_200
	local size_800 = v5.Size.Size_800
	local small = v5.Padding.Small

	local muted = v5.DarkMode.Content.Muted
	local emphasis = v5.DarkMode.Content.Emphasis

	local v6 = useIndicatorScrollAnimation({
		numberOfItems = props.numberOfItems,
		startIndex = props.startIndex,
		scrolledSignal = props.mediaGalleryScrolledSignal,
		useSpring = props.useSpring,
		springConfig = props.springConfig,
		indicatorSize = size_200,
		indicatorPadding = small
	})

	local v7 = math.min(props.numberOfItems, MAX_VISIBLE_INDICATORS)

	local v8 = React.useMemo(function()
		return (v7 - 1) * (size_200 + small) + size_800
	end, { v7, size_200, small, size_800 })

	local ref = React.useRef({})

	local v9 = React.useCallback(function(p2)
		local v10 = math.min(v6.firstVisibleIndex + v7 - 1, props.numberOfItems)
		local v11 = v6.firstVisibleIndex > 1
		local v12 = v10 < props.numberOfItems

		if p2 == v6.currentItemIndex then
			return UDim2.fromOffset(size_800, size_200)
		end

		if v11 then
			if p2 < v6.firstVisibleIndex then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == v6.firstVisibleIndex then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == v6.firstVisibleIndex + 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		if v12 then
			if v10 < p2 then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == v10 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == v10 - 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		return UDim2.fromOffset(size_200, size_200)
	end, {
		props.numberOfItems,
		v7,
		v6.firstVisibleIndex,
		v6.currentItemIndex,
		size_100,
		size_150,
		size_200,
		size_800
	})

	local v10 = React.useMemo(function()
		local children = {}

		for i = 1, props.numberOfItems do
			local v11 = ref.current[i]
			local v12 = v9(i)

			local v13 = "Indicator" .. i
			local createElement = React.createElement
			local fromOffset = UDim2.fromOffset
			local v16 = if i == v6.currentItemIndex then size_800 else size_200
			local v15 = {
				Size = fromOffset(v16, size_200),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i
			}

			local createElement2 = React.createElement
			local v18 = {
				AnchorPoint = getDotAnchorPointAtIndex(i, v6.previousItemIndex, v6.currentItemIndex),
				Position = getDotPositionAtIndex(i, v6.previousItemIndex, v6.currentItemIndex),
				Size = v6.animationProgressBinding:map(function(p2)
					if v11 == nil then
						return v12
					end

					return v11:Lerp(v12, p2)
				end),
				BackgroundColor3 = muted.Color3,
				BackgroundTransparency = muted.Transparency,
				BorderSizePixel = 0
			}

			local v19 = {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				ProgressBar = 0
			}
			local v20

			if i == v6.currentItemIndex and props.currentItemProgressBinding then
				v20 = React.createElement("Frame", {
					Size = props.currentItemProgressBinding:map(function(p2)
						return UDim2.fromOffset(size_200 + p2 * (size_800 - size_200), size_200)
					end),
					BackgroundColor3 = emphasis.Color3,
					BackgroundTransparency = emphasis.Transparency,
					BorderSizePixel = 0
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					})
				})
			end

			v19.ProgressBar = v20
			children[v13] = createElement("Frame", v15, {
				Dot = createElement2("Frame", v18, v19)
			})
		end

		return children
	end, {
		props.numberOfItems,
		props.currentItemProgressBinding,
		v6.previousItemIndex,
		v6.currentItemIndex,
		v9,
		size_200,
		size_800,
		muted,
		emphasis,
		v6.animationProgressBinding
	})

	React.useEffect(function()
		for i = 1, props.numberOfItems do
			ref.current[i] = v9(i)
		end
	end, { props.numberOfItems, v9 })

	return React.createElement("ScrollingFrame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = UDim2.fromOffset(v8, 0),
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
		CanvasPosition = v6.canvasPositionBinding,
		Selectable = false
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, small),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v10)
	})
end

return React.memo(MediaGalleryPageIndicators)
