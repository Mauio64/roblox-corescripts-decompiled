local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useScreenSize = RobloxAppHooks.useScreenSize
local GridView = UIBlox.App.Grid.GridView
local GalleryActionContainer = require(ParentParent.Components.CapturesGallery.GalleryActionContainer)
local GalleryItem = require(ParentParent.Components.CapturesGallery.GalleryItem)
local ShowMoreButton = require(ParentParent.Components.Common.ShowMoreButton)

require(ParentParent.Types)

local function getItemsPerRow(n1: number) -- line: 40
	return (math.clamp(math.floor(n1 / 120), 1, 4))
end
local function getGalleryItemSize(n2: number, n3: number) -- line: 44
	local v21 = math.clamp(math.floor(n3 / 120), 1, 4)
	local v22 = n3 - 4 * (v21 - 1)
	local v23 = math.min(v22 / v21, v22)
	local v24 = v23 * n2

	return Vector2.new(math.floor(v23), (math.floor(v24)))
end
local function getItemsPerPage(n4: number, n5: number, vector2: Vector2) -- line: 54
	if n4 <= 0 then
		return 0
	end

	local v28 = math.floor(n4 / vector2.Y)

	if n4 < vector2.Y * v28 + (v28 - 1) * 4 then
		v28 -= 1
	end

	return (math.max(v28 * math.clamp(math.floor(n5 / 120), 1, 4), 8))
end
local function renderGalleryItem(p1, n6: number) -- line: 69
	-- upvalues: React (copy), GalleryItem (copy)
	return React.createElement(GalleryItem, {
		capture = p1,
		captureIndex = n6
	})
end

return function(t1: {[any]: any}) -- line: 76
	-- upvalues: React (copy), useScreenSize (copy), useEffectOnce (copy), Dash (copy), GalleryActionContainer (copy), GridView (copy), renderGalleryItem (copy), ShowMoreButton (copy)
	local v32, v33 = React.useState(Vector2.new(0, 0))
	local v34, v35 = React.useState(0)
	local v36 = useScreenSize()
	local v37 = v34 < #t1.captures
	local v38 = v32.X > 0 and v32.Y > 0
	local v39 = React.useCallback(function(p2) -- line: 84
		-- upvalues: v33 (copy)
		v33(p2.AbsoluteSize)
	end, {})
	local v40 = math.clamp(v36.Y / v36.X, 0.42857142857142855, 1)
	local v41 = v32.Y - 12 - 40 - 36
	local X = v32.X
	local v43 = math.clamp(math.floor(X / 120), 1, 4)
	local v44 = X - 4 * (v43 - 1)
	local v45 = math.min(v44 / v43, v44)
	local v46 = v45 * v40
	local vector2 = Vector2.new(math.floor(v45), (math.floor(v46)))
	local n7

	if v41 <= 0 then
		n7 = 0
	else
		local v49 = math.floor(v41 / vector2.Y)

		if v41 < vector2.Y * v49 + (v49 - 1) * 4 then
			v49 -= 1
		end

		n7 = math.max(v49 * math.clamp(math.floor(X / 120), 1, 4), 8)
	end

	if v34 > n7 then
		local v50 = X - 9
		local v51 = math.clamp(math.floor(v50 / 120), 1, 4)
		local v52 = v50 - 4 * (v51 - 1)
		local v53 = math.min(v52 / v51, v52)
		local v54 = v53 * v40

		vector2 = Vector2.new(math.floor(v53), (math.floor(v54)))

		if v41 <= 0 then
			n7 = 0
		else
			local v55 = math.floor(v41 / vector2.Y)

			if v41 < vector2.Y * v55 + (v55 - 1) * 4 then
				v55 -= 1
			end

			n7 = math.max(v55 * math.clamp(math.floor(v50 / 120), 1, 4), 8)
		end
	end

	useEffectOnce(function() -- line: 106
		-- upvalues: v35 (copy), n7 (ref)
		v35(n7)
	end, n7 ~= 0)
	React.useEffect(function() -- line: 110
		-- upvalues: v34 (copy), n7 (ref), v35 (copy)
		if v34 < n7 then
			v35(n7)
		end
	end, { v32 })

	local v56 = React.useCallback(function() -- line: 116
		-- upvalues: v35 (copy), v34 (copy), n7 (ref)
		v35(v34 + n7)
	end, {
		v34,
		n7
	})
	local v57 = React.useMemo(function() -- line: 120
		-- upvalues: t1 (copy), v34 (copy), Dash (copy)
		local v59 = math.min(#t1.captures, v34)

		return Dash.slice(t1.captures, 1, v59)
	end, {
		t1.captures,
		v34
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		Size = t1.Size or UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = v39
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		GalleryActionContainer = React.createElement(GalleryActionContainer, {
			isDisabled = false,
			LayoutOrder = 1,
			itemCount = #t1.captures
		}),
		ScrollingFrame = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			ScrollBarThickness = 1,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.new(1, 0, 1, -36)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 12)
			}),
			GridView = v38 and React.createElement(GridView, {
				LayoutOrder = 1,
				itemPadding = Vector2.new(4, 4),
				items = v57,
				itemSize = vector2,
				renderItem = renderGalleryItem
			}),
			ShowMoreButton = v37 and React.createElement(ShowMoreButton, {
				LayoutOrder = 2,
				buttonHeight = 40,
				onActivated = v56
			})
		})
	})
end
