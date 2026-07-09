local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.ReactOtter)
require(CorePackages.Workspace.Packages.AppCommonLib)

local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local v6 = game:DefineFastInt("LuaAppEdpMediaGalleryPageIndicatorsMaxVisibleCount", 5)

local function getFirstVisibleIndexOnScrollingRight(n1: number, n2: number) -- line: 35
	-- upvalues: v6 (copy)
	if n1 > v6 then
		return (math.max(1, math.min(n2, n1 - 2) - v6 + 2 + 1))
	end

	return 1
end
local function getFirstVisibleIndexOnScrollingLeft(n3: number, n4: number) -- line: 52
	-- upvalues: v6 (copy)
	if n3 > v6 then
		return (math.min(n3 - v6 + 1, math.max(n4, 3) - 2))
	end

	return 1
end
local function getDotAnchorPointAtIndex(n5: number, n6: number, n7: number) -- line: 66
	if n7 < n6 then
		if n5 == n6 then
			return Vector2.new(1, 0.5)
		end

		if n5 == n7 then
			return Vector2.new(0, 0.5)
		end
	elseif n6 < n7 then
		if n5 == n6 then
			return Vector2.new(0, 0.5)
		end

		if n5 == n7 then
			return Vector2.new(1, 0.5)
		end
	end

	return Vector2.new(0.5, 0.5)
end
local function getDotPositionAtIndex(n8: number, n9: number, n10: number) -- line: 86
	if n10 < n9 then
		if n8 == n9 then
			return UDim2.fromScale(1, 0.5)
		end

		if n8 == n10 then
			return UDim2.fromScale(0, 0.5)
		end
	elseif n9 < n10 then
		if n8 == n9 then
			return UDim2.fromScale(0, 0.5)
		end

		if n8 == n10 then
			return UDim2.fromScale(1, 0.5)
		end
	end

	return UDim2.fromScale(0.5, 0.5)
end
local function MediaGalleryPageIndicators(t1: {[any]: any}) -- line: 106
	-- upvalues: useTokens (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), React (copy), v6 (copy), Otter (copy), getDotAnchorPointAtIndex (copy), getDotPositionAtIndex (copy)
	local v23 = useTokens()
	local Size_100 = v23.Size.Size_100
	local Size_150 = v23.Size.Size_150
	local Size_200 = v23.Size.Size_200
	local Size_800 = v23.Size.Size_800
	local Small = v23.Padding.Small
	local Muted = v23.DarkMode.Content.Muted
	local v30 = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else v23.DarkMode.Content.Emphasis
	local v31, v32 = React.useState(t1.mediaGalleryStartIndex)
	local v33, v34 = React.useState(t1.mediaGalleryStartIndex)
	local v35, v36 = React.useState(1)
	local v37, v38 = React.useBinding(Vector2.new(0, 0))
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useBinding(0)
	local v43 = React.useRef({})
	local v44 = math.min(t1.numberOfItems, v6)
	local v45 = React.useMemo(function() -- line: 133
		-- upvalues: v44 (copy), Size_200 (copy), Small (copy), Size_800 (copy)
		return (v44 - 1) * (Size_200 + Small) + Size_800
	end, {
		v44,
		Size_200,
		Small,
		Size_800
	})
	local v46 = React.useCallback(function(n11: number) -- line: 137
		-- upvalues: Size_200 (copy), Small (copy)
		return Vector2.new((n11 - 1) * (Size_200 + Small), 0)
	end, {
		Size_200,
		Small
	})
	local v47 = React.useCallback(function(n12: number) -- line: 142
		-- upvalues: v35 (copy), v44 (copy), t1 (copy), v31 (copy), Size_800 (copy), Size_200 (copy), Size_100 (copy), Size_150 (copy)
		local v51 = math.min(v35 + v44 - 1, t1.numberOfItems)
		local v52 = v35 > 1
		local v53 = v51 < t1.numberOfItems

		if n12 == v31 then
			return UDim2.fromOffset(Size_800, Size_200)
		end

		if v52 then
			if n12 < v35 then
				return UDim2.fromOffset(0, 0)
			end

			if n12 == v35 then
				return UDim2.fromOffset(Size_100, Size_100)
			end

			if n12 == v35 + 1 then
				return UDim2.fromOffset(Size_150, Size_150)
			end
		end

		if v53 then
			if v51 < n12 then
				return UDim2.fromOffset(0, 0)
			end

			if n12 == v51 then
				return UDim2.fromOffset(Size_100, Size_100)
			end

			if n12 == v51 - 1 then
				return UDim2.fromOffset(Size_150, Size_150)
			end
		end

		return UDim2.fromOffset(Size_200, Size_200)
	end, {
		t1.numberOfItems,
		v44,
		v35,
		v31,
		Size_100,
		Size_150,
		Size_200,
		Size_800
	})

	React.useEffect(function() -- line: 186
		-- upvalues: t1 (copy), v6 (copy), v38 (copy), v46 (copy), v36 (copy), v42 (copy), v32 (copy)
		local numberOfItems = t1.numberOfItems
		local mediaGalleryStartIndex = t1.mediaGalleryStartIndex
		local v56 = not (numberOfItems > v6) and 1 or math.max(1, math.min(mediaGalleryStartIndex, numberOfItems - 2) - v6 + 2 + 1)

		v38(v46(v56))
		v36(v56)
		v42(1)
		v32(t1.mediaGalleryStartIndex)
	end, {
		t1.numberOfItems,
		t1.mediaGalleryStartIndex,
		v46
	})
	React.useEffect(function() -- line: 196
		-- upvalues: v32 (copy), t1 (copy), v6 (copy), v34 (copy), v36 (copy), v40 (copy)
		local function handleMediaGalleryScrolled(n13: number) -- line: 197
			-- upvalues: v32 (copy), t1 (copy), v6 (copy), v34 (copy), v36 (copy), v40 (copy)
			v32(function(p1) -- line: 198
				-- upvalues: n13 (copy), t1 (copy), v6 (copy), v34 (copy), v36 (copy), v40 (copy)
				local v74

				if p1 < n13 then
					local numberOfItems = t1.numberOfItems
					local v73 = n13

					v74 = not (numberOfItems > v6) and 1 or math.max(1, math.min(v73, numberOfItems - 2) - v6 + 2 + 1)
				else
					local numberOfItems = t1.numberOfItems
					local v76 = n13

					v74 = not (numberOfItems > v6) and 1 or math.min(numberOfItems - v6 + 1, math.max(v76, 3) - 2)
				end

				v34(p1)
				v36(v74)
				v40(true)

				return n13
			end)
		end

		local u58 = t1.mediaGalleryScrolledSignal:connect(function(n14: number) -- line: 216
			-- upvalues: v32 (copy), t1 (copy), v6 (copy), v34 (copy), v36 (copy), v40 (copy)
			v32(function(p2) -- line: 198
				-- upvalues: n14 (copy), t1 (copy), v6 (copy), v34 (copy), v36 (copy), v40 (copy)
				local v80

				if p2 < n14 then
					local numberOfItems = t1.numberOfItems
					local v79 = n14

					v80 = not (numberOfItems > v6) and 1 or math.max(1, math.min(v79, numberOfItems - 2) - v6 + 2 + 1)
				else
					local numberOfItems = t1.numberOfItems
					local v82 = n14

					v80 = not (numberOfItems > v6) and 1 or math.min(numberOfItems - v6 + 1, math.max(v82, 3) - 2)
				end

				v34(p2)
				v36(v80)
				v40(true)

				return n14
			end)
		end)

		return function() -- line: 220
			-- upvalues: u58 (ref)
			if u58 ~= nil then
				u58:disconnect()
				u58 = nil
			end
		end
	end, {
		t1.numberOfItems,
		t1.mediaGalleryScrolledSignal
	})
	React.useEffect(function() -- line: 229
		-- upvalues: v39 (copy), Otter (copy), t1 (copy), v37 (copy), v46 (copy), v35 (copy), v42 (copy), v38 (copy), v40 (copy)
		if not v39 then
			return
		end

		local v59 = Otter.createSingleMotor(0)

		v59:setGoal(if not t1.useSpring then Otter.instant(1) else Otter.spring(1, t1.springConfig))

		local v60 = v37:getValue()
		local v61 = v46(v35)

		v59:onStep(function(n15: number) -- line: 240
			-- upvalues: v42 (copy), v38 (copy), v60 (copy), v61 (copy)
			v42(n15)
			v38(v60:Lerp(v61, n15))
		end)
		v59:onComplete(function() -- line: 245
			-- upvalues: v40 (copy)
			v40(false)
		end)

		return function() -- line: 248
			-- upvalues: v59 (copy)
			v59:destroy()
		end
	end, {
		t1.useSpring,
		t1.springConfig,
		v39,
		v35,
		v37,
		v46
	})

	local v48 = React.useMemo(function() -- line: 263
		-- upvalues: t1 (copy), v43 (copy), v47 (copy), React (copy), v31 (copy), Size_800 (copy), Size_200 (copy), getDotAnchorPointAtIndex (copy), v33 (copy), getDotPositionAtIndex (copy), v41 (copy), Muted (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), v30 (copy)
		local t2 = {}

		for i = 1, t1.numberOfItems do
			local v64 = v43.current[i]
			local v65 = v47(i)

			t2["Indicator" .. i] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(if i ~= v31 then Size_200 else Size_800, Size_200),
				LayoutOrder = i
			}, {
				Dot = React.createElement("Frame", {
					BorderSizePixel = 0,
					AnchorPoint = getDotAnchorPointAtIndex(i, v33, v31),
					Position = getDotPositionAtIndex(i, v33, v31),
					Size = v41:map(function(n16: number) -- line: 286
						-- upvalues: v64 (copy), v65 (copy)
						if v64 == nil then
							return v65
						end

						return v64:Lerp(v65, n16)
					end),
					BackgroundColor3 = Muted.Color3,
					BackgroundTransparency = Muted.Transparency
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					}),
					ProgressBar = if not FFlagLuaAppEdpMediaGalleryAutoAdvance or (i ~= v31 or not t1.currentItemProgressBinding) then nil else React.createElement("Frame", {
						BorderSizePixel = 0,
						Size = t1.currentItemProgressBinding:map(function(n17: number) -- line: 305
							-- upvalues: Size_200 (copy), Size_800 (copy)
							return UDim2.fromOffset(Size_200 + n17 * (Size_800 - Size_200), Size_200)
						end),
						BackgroundColor3 = v30.Color3,
						BackgroundTransparency = v30.Transparency
					}, {
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(1, 0)
						})
					})
				})
			})
			v43.current[i] = v65
		end

		return t2
	end, {
		t1.numberOfItems,
		if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else t1.currentItemProgressBinding,
		v33,
		v31,
		v47,
		Size_200,
		Size_800,
		Muted,
		if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else v30,
		v41
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
		Size = UDim2.fromOffset(v45, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = t1.ZIndex,
		ScrollingDirection = Enum.ScrollingDirection.X,
		CanvasSize = UDim2.fromOffset(0, Size_200),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasPosition = v37
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, Small),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v48)
	})
end

return MediaGalleryPageIndicators
