local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/ReactOtter")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/AppCommonLib")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Foundation").Hooks.useTokens

local useIndicatorScrollAnimation = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useIndicatorScrollAnimation")
local MAX_VISIBLE_INDICATORS = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants").MAX_VISIBLE_INDICATORS

local fFlagLuaAppMediaGalleryPageIndicatorOpacity = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppMediaGalleryPageIndicatorOpacity

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

	local v6 = if fFlagLuaAppMediaGalleryPageIndicatorOpacity then v5.Size.Size_600 else v5.Size.Size_800

	local v7 = if fFlagLuaAppMediaGalleryPageIndicatorOpacity then v5.Size.Size_150 else v5.Padding.Small

	local muted = v5.DarkMode.Content.Muted
	local emphasis = v5.DarkMode.Content.Emphasis
	local white = if fFlagLuaAppMediaGalleryPageIndicatorOpacity then v5.Color.Extended.White else nil

	local v8 = useIndicatorScrollAnimation({
		numberOfItems = props.numberOfItems,
		startIndex = props.startIndex,
		scrolledSignal = props.mediaGalleryScrolledSignal,
		useSpring = props.useSpring,
		springConfig = props.springConfig,
		indicatorSize = size_200,
		indicatorPadding = v7
	})

	local v9 = math.min(props.numberOfItems, MAX_VISIBLE_INDICATORS)

	local v10 = React.useMemo(function()
		return (v9 - 1) * (size_200 + v7) + v6
	end, { v9, size_200, v7, v6 })

	local ref = React.useRef({})

	local v11 = React.useCallback(function(p2)
		local v12 = math.min(v8.firstVisibleIndex + v9 - 1, props.numberOfItems)
		local v13 = v8.firstVisibleIndex > 1
		local v14 = v12 < props.numberOfItems

		if p2 == v8.currentItemIndex then
			return UDim2.fromOffset(v6, size_200)
		end

		if v13 then
			if p2 < v8.firstVisibleIndex then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == v8.firstVisibleIndex then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == v8.firstVisibleIndex + 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		if v14 then
			if v12 < p2 then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == v12 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == v12 - 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		return UDim2.fromOffset(size_200, size_200)
	end, {
		props.numberOfItems,
		v9,
		v8.firstVisibleIndex,
		v8.currentItemIndex,
		size_100,
		size_150,
		size_200,
		v6
	})

	local function fn()
		local children = {}

		for i = 1, props.numberOfItems do
			local v12 = ref.current[i]
			local v13 = v11(i)
			local v14

			if fFlagLuaAppMediaGalleryPageIndicatorOpacity then
				if i == v8.currentItemIndex then
					v14 = if props.currentItemProgressBinding then muted else white.White_100
				else
					v14 = white.White_20
				end
			else
				v14 = muted
			end

			local v15 = "Indicator" .. i
			local createElement = React.createElement
			local fromOffset = UDim2.fromOffset
			local v18 = if i == v8.currentItemIndex then v6 else size_200
			local v17 = {
				Size = fromOffset(v18, size_200),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i
			}

			local createElement2 = React.createElement
			local v20 = {
				AnchorPoint = getDotAnchorPointAtIndex(i, v8.previousItemIndex, v8.currentItemIndex),
				Position = getDotPositionAtIndex(i, v8.previousItemIndex, v8.currentItemIndex),
				Size = v8.animationProgressBinding:map(function(p2)
					if v12 == nil then
						return v13
					end

					return v12:Lerp(v13, p2)
				end),
				BackgroundColor3 = v14.Color3,
				BackgroundTransparency = v14.Transparency,
				BorderSizePixel = 0
			}

			local v21 = {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				ProgressBar = 0
			}
			local v22

			if i == v8.currentItemIndex and props.currentItemProgressBinding then
				v22 = React.createElement("Frame", {
					Size = props.currentItemProgressBinding:map(function(p2)
						return UDim2.fromOffset(size_200 + p2 * (v6 - size_200), size_200)
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

			v21.ProgressBar = v22
			children[v15] = createElement("Frame", v17, {
				Dot = createElement2("Frame", v20, v21)
			})
		end

		return children
	end

	local v14 = React.useMemo(fn, {
		props.numberOfItems,
		props.currentItemProgressBinding,
		v8.previousItemIndex,
		v8.currentItemIndex,
		v11,
		size_200,
		v6,
		muted,
		emphasis,
		v8.animationProgressBinding,
		if fFlagLuaAppMediaGalleryPageIndicatorOpacity then white else nil
	})

	React.useEffect(function()
		for i = 1, props.numberOfItems do
			ref.current[i] = v11(i)
		end
	end, { props.numberOfItems, v11 })

	return React.createElement("ScrollingFrame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = UDim2.fromOffset(v10, 0),
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
		CanvasPosition = v8.canvasPositionBinding,
		Selectable = false
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v7),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v14)
	})
end

return React.memo(MediaGalleryPageIndicators)
