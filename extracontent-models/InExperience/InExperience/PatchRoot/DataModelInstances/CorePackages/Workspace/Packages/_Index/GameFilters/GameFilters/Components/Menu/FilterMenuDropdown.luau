local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent

require(GameFiltersParent.DiscoveryTypes)

local Foundation = require(GameFiltersParent.Foundation)
local React = require(GameFiltersParent.React)
local useDispatch = require(GameFiltersParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local FilterClickButtonName = require(GameFilters.Analytics.FilterClickButtonName)
local FilterMenuActionBar = require(GameFilters.Components.Menu.FilterMenuActionBar)
local FilterMenuHeader = require(GameFilters.Components.Menu.FilterMenuHeader)
local FilterMenuOptions = require(GameFilters.Components.Menu.FilterMenuOptions)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)
local FFlagLuaAppChartsFilterOptionTextTag = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local FFlagLuaAppChartsActiveFilterChips = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsActiveFilterChips
local v14 = not FFlagLuaAppChartsFilterOptionTextTag and 10000 or nil

local function applyTokenScaling(n1: number, p1) -- line: 39
	return n1 * p1.Config.UI.Scale
end
local function FilterMenuDropdown(p2) -- line: 44
	-- upvalues: useTokens (copy), useDispatch (copy), React (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), v14 (copy), FilterClickButtonName (copy), getOptionContextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy), FilterMenuHeader (copy), FilterMenuOptions (copy), FilterMenuActionBar (copy)
	local v20 = useTokens()
	local v21 = useDispatch()
	local v22 = 260 * v20.Config.UI.Scale
	local v23 = 84 * v20.Config.UI.Scale
	local v24, v25 = React.useState(p2.filter.selectedOptionId)
	local Scrim = v20.Color.Common.Scrim
	local Surface_100 = v20.Color.Surface.Surface_100
	local Border = v20.Color.ActionStandard.Border
	local uDim2, vector2

	if p2.openPosition then
		uDim2 = UDim2.fromOffset(p2.openPosition.X, p2.openPosition.Y)
		vector2 = Vector2.new(0, 0)
	else
		uDim2 = UDim2.fromScale(0.5, 0.5)
		vector2 = Vector2.new(0.5, 0.5)
	end

	local v31, v32 = React.useBinding(Vector2.new(0, 0))
	local v33, v34 = React.useBinding(0)
	local v35 = nil
	local v36 = nil
	local v37 = nil
	local u38 = nil
	local v39 = nil

	if FFlagLuaAppChartsFilterOptionTextTag then
		local v40

		v37, v40 = React.useBinding(0)
		u38 = v40
		v39 = React.useCallback(function(p3) -- line: 74
			-- upvalues: u38 (ref)
			u38(p3.AbsoluteCanvasSize.Y)
		end, {})
	else
		v35, v36 = React.useBinding(Vector2.new(v14, 0))
	end

	local v41 = v31:map(function(vector2_2: Vector2) -- line: 81
		-- upvalues: p2 (copy), v22 (copy)
		local v50, v51

		if p2.openPosition then
			v50 = math.max(vector2_2.X - p2.openPosition.X - 24, v22)
			v51 = math.max(vector2_2.Y - p2.openPosition.Y - 24, 0)
		else
			v50 = vector2_2.X - 48
			v51 = vector2_2.Y - 48
		end

		return Vector2.new(v50, v51)
	end)
	local v42 = if not FFlagLuaAppChartsFilterOptionTextTag then v41:map(function(vector2_3: Vector2) -- line: 98
		return vector2_3.X
	end) else nil
	local v43 = React.joinBindings({
		v33,
		if not FFlagLuaAppChartsFilterOptionTextTag then v35 else v37
	}):map(function(t1: {[any]: any}) -- line: 105
		-- upvalues: FFlagLuaAppChartsFilterOptionTextTag (copy), v23 (copy)
		local v54 = t1[1]

		if FFlagLuaAppChartsFilterOptionTextTag then
			local v55 = t1[2]

			return UDim2.fromOffset(0, v54 + v55 + v23)
		end

		local v56 = t1[2]

		return UDim2.fromOffset(v56.X, v54 + v56.Y + v23)
	end)
	local v44 = v33:map(function(n2: number) -- line: 118
		-- upvalues: FFlagLuaAppChartsFilterOptionTextTag (copy), v23 (copy)
		return UDim2.new(not FFlagLuaAppChartsFilterOptionTextTag and 1 or 0, 0, 1, -n2 - v23)
	end)
	local v45 = React.useCallback(function() -- line: 122
		-- upvalues: v21 (copy), p2 (copy), FilterClickButtonName (copy), v24 (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy)
		v21(p2.closeCentralOverlayThunk())
		p2.onFilterMenuClosed()
		p2.sendFilterClick(FilterClickButtonName.CloseDropdown, p2.filter.selectedOptionId, v24, if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(p2.filter, p2.filter.selectedOptionId), if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(p2.filter, v24), not not FFlagLuaAppChartsActiveFilterChips or nil)
	end, {
		p2.filter,
		v24,
		p2.closeCentralOverlayThunk,
		p2.onFilterMenuClosed,
		p2.sendFilterClick
	})
	local v46 = v24 ~= p2.filter.selectedOptionId
	local v47 = React.useCallback(function() -- line: 146
		-- upvalues: p2 (copy), v24 (copy), v21 (copy), FilterClickButtonName (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy)
		p2.onFilterApplied(p2.filter.filterType, v24)
		v21(p2.closeCentralOverlayThunk())
		p2.onFilterMenuClosed()
		p2.sendFilterClick(FilterClickButtonName.Apply, v24, p2.filter.selectedOptionId, if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(p2.filter, v24), if not FFlagLuaAppChartsFilterOptionTextTag then nil else getOptionContextTag(p2.filter, p2.filter.selectedOptionId), not not FFlagLuaAppChartsActiveFilterChips or nil)
	end, {
		p2.filter,
		v24,
		p2.onFilterApplied,
		p2.closeCentralOverlayThunk,
		p2.onFilterMenuClosed,
		p2.sendFilterClick
	})

	return React.createElement("TextButton", {
		BackgroundColor3 = Scrim.Color3,
		BackgroundTransparency = Scrim.Transparency,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = v45,
		[React.Change.AbsoluteSize] = function(p4) -- line: 179
			-- upvalues: v32 (copy)
			v32(p4.AbsoluteSize)
		end,
		Selectable = false
	}, {
		Dropdown = React.createElement("TextButton", {
			ClipsDescendants = true,
			Text = "",
			AutoButtonColor = false,
			Selectable = false,
			BackgroundColor3 = Surface_100.Color3,
			BackgroundTransparency = Surface_100.Transparency,
			BorderColor3 = Border.Color3,
			Position = uDim2,
			AnchorPoint = vector2,
			Size = v43,
			AutomaticSize = if not FFlagLuaAppChartsFilterOptionTextTag then nil else Enum.AutomaticSize.X
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v20.Radius.Medium)
			}),
			SizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = Vector2.new(v22, 0),
				MaxSize = v41
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalFlex = if not FFlagLuaAppChartsFilterOptionTextTag then nil else Enum.UIFlexAlignment.Fill
			}),
			Header = React.createElement(FilterMenuHeader, {
				LayoutOrder = 1,
				title = p2.filter.filterDisplayName,
				onCloseButtonActivated = v45,
				onHeightChanged = v34
			}),
			Options = React.createElement(FilterMenuOptions, {
				LayoutOrder = 2,
				Size = v44,
				containerMaxWidthBinding = if not FFlagLuaAppChartsFilterOptionTextTag then v42 else nil,
				options = p2.filter.filterOptions,
				selectedOptionId = v24,
				onSelectedOptionChanged = v25,
				onCanvasSizeChanged = if not FFlagLuaAppChartsFilterOptionTextTag then v36 else v39
			}),
			ActionBar = React.createElement(FilterMenuActionBar, {
				LayoutOrder = 3,
				Size = UDim2.new(not FFlagLuaAppChartsFilterOptionTextTag and 1 or 0, 0, 0, v23),
				applyEnabled = v46,
				onApply = v47
			})
		})
	})
end

return FilterMenuDropdown
