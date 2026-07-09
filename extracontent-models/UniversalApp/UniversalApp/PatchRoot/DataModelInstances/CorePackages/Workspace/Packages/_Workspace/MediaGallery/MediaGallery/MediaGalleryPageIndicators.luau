local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)

require(MediaGalleryParent.ReactOtter)
require(MediaGalleryParent.AppCommonLib)

local useTokens = require(MediaGalleryParent.Foundation).Hooks.useTokens
local useIndicatorScrollAnimation = require(MediaGallery.Hooks.useIndicatorScrollAnimation)
local MAX_VISIBLE_INDICATORS = require(MediaGallery.MediaGalleryConstants).MAX_VISIBLE_INDICATORS

local function getDotAnchorPointAtIndex(n1: number, n2: number, n3: number) -- line: 30
	if n3 < n2 then
		if n1 == n2 then
			return Vector2.new(1, 0.5)
		end

		if n1 == n3 then
			return Vector2.new(0, 0.5)
		end
	elseif n2 < n3 then
		if n1 == n2 then
			return Vector2.new(0, 0.5)
		end

		if n1 == n3 then
			return Vector2.new(1, 0.5)
		end
	end

	return Vector2.new(0.5, 0.5)
end
local function getDotPositionAtIndex(n4: number, n5: number, n6: number) -- line: 48
	if n6 < n5 then
		if n4 == n5 then
			return UDim2.fromScale(1, 0.5)
		end

		if n4 == n6 then
			return UDim2.fromScale(0, 0.5)
		end
	elseif n5 < n6 then
		if n4 == n5 then
			return UDim2.fromScale(0, 0.5)
		end

		if n4 == n6 then
			return UDim2.fromScale(1, 0.5)
		end
	end

	return UDim2.fromScale(0.5, 0.5)
end
local function MediaGalleryPageIndicators(t1: {[any]: any}) -- line: 66
	-- upvalues: useTokens (copy), useIndicatorScrollAnimation (copy), MAX_VISIBLE_INDICATORS (copy), React (copy), getDotAnchorPointAtIndex (copy), getDotPositionAtIndex (copy)
	local v17 = useTokens()
	local Size_100 = v17.Size.Size_100
	local Size_150 = v17.Size.Size_150
	local Size_200 = v17.Size.Size_200
	local Size_800 = v17.Size.Size_800
	local Small = v17.Padding.Small
	local Muted = v17.DarkMode.Content.Muted
	local Emphasis = v17.DarkMode.Content.Emphasis
	local v25 = useIndicatorScrollAnimation({
		numberOfItems = t1.numberOfItems,
		startIndex = t1.startIndex,
		scrolledSignal = t1.mediaGalleryScrolledSignal,
		useSpring = t1.useSpring,
		springConfig = t1.springConfig,
		indicatorSize = Size_200,
		indicatorPadding = Small
	})
	local v26 = math.min(t1.numberOfItems, MAX_VISIBLE_INDICATORS)
	local v27 = React.useMemo(function() -- line: 92
		-- upvalues: v26 (copy), Size_200 (copy), Small (copy), Size_800 (copy)
		return (v26 - 1) * (Size_200 + Small) + Size_800
	end, {
		v26,
		Size_200,
		Small,
		Size_800
	})
	local v28 = React.useRef({})
	local v29 = React.useCallback(function(n7: number) -- line: 99
		-- upvalues: v25 (copy), v26 (copy), t1 (copy), Size_800 (copy), Size_200 (copy), Size_100 (copy), Size_150 (copy)
		local v32 = math.min(v25.firstVisibleIndex + v26 - 1, t1.numberOfItems)
		local v33 = v25.firstVisibleIndex > 1
		local v34 = v32 < t1.numberOfItems

		if n7 == v25.currentItemIndex then
			return UDim2.fromOffset(Size_800, Size_200)
		end

		if v33 then
			if n7 < v25.firstVisibleIndex then
				return UDim2.fromOffset(0, 0)
			end

			if n7 == v25.firstVisibleIndex then
				return UDim2.fromOffset(Size_100, Size_100)
			end

			if n7 == v25.firstVisibleIndex + 1 then
				return UDim2.fromOffset(Size_150, Size_150)
			end
		end

		if v34 then
			if v32 < n7 then
				return UDim2.fromOffset(0, 0)
			end

			if n7 == v32 then
				return UDim2.fromOffset(Size_100, Size_100)
			end

			if n7 == v32 - 1 then
				return UDim2.fromOffset(Size_150, Size_150)
			end
		end

		return UDim2.fromOffset(Size_200, Size_200)
	end, {
		t1.numberOfItems,
		v26,
		v25.firstVisibleIndex,
		v25.currentItemIndex,
		Size_100,
		Size_150,
		Size_200,
		Size_800
	})
	local v30 = React.useMemo(function() -- line: 144
		-- upvalues: t1 (copy), v28 (copy), v29 (copy), React (copy), v25 (copy), Size_800 (copy), Size_200 (copy), getDotAnchorPointAtIndex (copy), getDotPositionAtIndex (copy), Muted (copy), Emphasis (copy)
		local t2 = {}

		for i = 1, t1.numberOfItems do
			local v37 = v28.current[i]
			local v38 = v29(i)

			t2["Indicator" .. i] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(if i ~= v25.currentItemIndex then Size_200 else Size_800, Size_200),
				LayoutOrder = i
			}, {
				Dot = React.createElement("Frame", {
					BorderSizePixel = 0,
					AnchorPoint = getDotAnchorPointAtIndex(i, v25.previousItemIndex, v25.currentItemIndex),
					Position = getDotPositionAtIndex(i, v25.previousItemIndex, v25.currentItemIndex),
					Size = v25.animationProgressBinding:map(function(n8: number) -- line: 178
						-- upvalues: v37 (copy), v38 (copy)
						if v37 == nil then
							return v38
						end

						return v37:Lerp(v38, n8)
					end),
					BackgroundColor3 = Muted.Color3,
					BackgroundTransparency = Muted.Transparency
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					}),
					ProgressBar = if i ~= v25.currentItemIndex or not t1.currentItemProgressBinding then nil else React.createElement("Frame", {
						BorderSizePixel = 0,
						Size = t1.currentItemProgressBinding:map(function(n9: number) -- line: 196
							-- upvalues: Size_200 (copy), Size_800 (copy)
							return UDim2.fromOffset(Size_200 + n9 * (Size_800 - Size_200), Size_200)
						end),
						BackgroundColor3 = Emphasis.Color3,
						BackgroundTransparency = Emphasis.Transparency
					}, {
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(1, 0)
						})
					})
				})
			})
		end

		return t2
	end, {
		t1.numberOfItems,
		t1.currentItemProgressBinding,
		v25.previousItemIndex,
		v25.currentItemIndex,
		v29,
		Size_200,
		Size_800,
		Muted,
		Emphasis,
		v25.animationProgressBinding
	})

	React.useEffect(function() -- line: 232
		-- upvalues: t1 (copy), v28 (copy), v29 (copy)
		for i = 1, t1.numberOfItems do
			v28.current[i] = v29(i)
		end
	end, {
		t1.numberOfItems,
		v29
	})

	return React.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ScrollingEnabled = false,
		ScrollBarThickness = 0,
		Selectable = false,
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		Size = UDim2.fromOffset(v27, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = t1.ZIndex,
		ScrollingDirection = Enum.ScrollingDirection.X,
		CanvasSize = UDim2.fromOffset(0, Size_200),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasPosition = v25.canvasPositionBinding
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, Small),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v30)
	})
end

return React.memo(MediaGalleryPageIndicators)
