local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local GridView = require(ParentParentParent.UIBlox).App.Grid.GridView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local MenuButton = require(ParentParent.Components.MenuButton)

require(ParentParent.Types)

local useScreenSize = require(ParentParent.Hooks.useScreenSize)

local function getItemsPerRow(n1: number) -- line: 41
	return (math.clamp(math.floor(n1 / 120), 1, 4))
end
local function getGalleryItemSize(n2: number, n3: number) -- line: 45
	local v18 = math.clamp(math.floor(n3 / 120), 1, 4)
	local v19 = n3 - 4 * (v18 - 1)
	local v20 = math.min(v19 / v18, v19)
	local v21 = v20 * n2

	return Vector2.new(math.floor(v20), (math.floor(v21)))
end
local function getItemsPerPage(n4: number, n5: number, vector2: Vector2) -- line: 55
	if n4 <= 0 then
		return 0
	end

	local v25 = math.floor(n4 / vector2.Y)

	if n4 < vector2.Y * v25 + (v25 - 1) * 4 then
		v25 -= 1
	end

	return (math.max(v25 * math.clamp(math.floor(n5 / 120), 1, 4), 8))
end

return function(t1: {[any]: any}) -- line: 70
	-- upvalues: React (copy), useScreenSize (copy), getGalleryItemSize (copy), Dash (copy), View (copy), ScrollView (copy), ScrollBarVisibility (copy), GridView (copy), MenuButton (copy)
	local v27, v28 = React.useState(Vector2.new(0, 0))
	local v29, v30 = React.useState(0)
	local v31 = useScreenSize()
	local v32 = React.useCallback(function(p1) -- line: 75
		-- upvalues: v28 (copy)
		v28(p1.AbsoluteSize)
	end, {})
	local v33 = v27.X > 0 and v27.Y > 0
	local v34 = t1.shouldShowShowMoreButton and v29 < #t1.captures
	local u35 = math.clamp(v31.Y / v31.X, 0.42857142857142855, 1)
	local v36 = v27.Y - 12 - 40 - 36
	local v37 = v27.X - 12 - 8
	local v38 = React.useMemo(function() -- line: 89
		-- upvalues: getGalleryItemSize (copy), u35 (ref), v37 (copy)
		return getGalleryItemSize(u35, v37)
	end, {
		u35,
		v37
	})
	local v39 = React.useMemo(function() -- line: 93
		-- upvalues: v36 (copy), v37 (copy), v38 (copy)
		local v43 = v36
		local v44 = v37
		local v45 = v38

		if v43 <= 0 then
			return 0
		end

		local v46 = math.floor(v43 / v45.Y)

		if v43 < v45.Y * v46 + (v46 - 1) * 4 then
			v46 -= 1
		end

		return (math.max(v46 * math.clamp(math.floor(v44 / 120), 1, 4), 8))
	end, {
		v36,
		v37,
		v38
	})

	React.useEffect(function() -- line: 97
		-- upvalues: v29 (copy), v39 (copy), v30 (copy)
		if v29 < v39 then
			v30(v39)
		end
	end, {
		v27,
		v39,
		v29
	})

	local v40 = React.useCallback(function() -- line: 103
		-- upvalues: v30 (copy), v29 (copy), v39 (copy)
		v30(v29 + v39)
	end, {
		v29,
		v39
	})
	local v41 = React.useMemo(function() -- line: 107
		-- upvalues: v34 (copy), t1 (copy), v29 (copy), Dash (copy)
		if v34 then
			local v47 = math.min(#t1.captures, v29)

			return Dash.slice(t1.captures, 1, v47)
		end

		return t1.captures
	end, {
		t1.captures,
		v34,
		v29
	})

	return React.createElement(View, {
		BorderSizePixel = 0,
		tag = "bg-surface-0",
		onAbsoluteSizeChanged = v32,
		Position = if not t1.position then UDim2.fromOffset(0, 0) else t1.position,
		Size = if not t1.size then UDim2.fromScale(1, 1) else t1.size
	}, {
		CaptureGridViewContainer = React.createElement(View, {
			tag = "bg-action-subtle size-full gap-xsmall col align-x-center align-y-top shrink"
		}, {
			Header = t1.header,
			ScrollView = React.createElement(ScrollView, {
				BorderSizePixel = 0,
				tag = "auto-y size-full-0 gap-xsmall col align-x-center align-y-top shrink padding-x-xsmall",
				LayoutOrder = not t1.layoutOrder and 1 or t1.layoutOrder,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = ScrollBarVisibility.Auto
				}
			}, {
				GridView = if not v33 then nil else React.createElement(GridView, {
					LayoutOrder = 1,
					itemPadding = Vector2.new(4, 4),
					items = v41,
					itemSize = v38,
					renderItem = t1.renderItem
				}),
				ShowMore = if not v34 then nil else React.createElement(MenuButton, {
					buttonHeight = 40,
					LayoutOrder = 2,
					text = "Show More",
					onActivated = v40
				})
			})
		})
	})
end
