local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact
local SortedList = require(script.Parent.SortedList)
local CallbackInputBoxWithIcon = require(script.Parent.CallbackInputBoxWithIcon)
local v5 = Roact.Component:extend("FilteredScrollingList")

v5.defaultProps = {
	searchBoxCornerRadius = 0,
	searchBoxHeight = 48,
	searchBoxTopPadding = 0,
	searchBoxLeftPadding = 0,
	searchBoxRightPadding = 0,
	searchBoxBottomPadding = 0,
	searchBackgroundTransparency = 0,
	searchBackgroundColor3 = Color3.new(1, 0, 1),
	searchBoxBorderThickness = 0,
	searchIconCellWidth = 60,
	searchIconSize = 24,
	searchIconColor3 = Color3.new(1, 0, 1),
	searchIconTransparency = 0,
	searchIconImage = "rbxasset://textures/ui/LuaChat/icons/ic-search.png",
	searchInputTextFont = nil,
	searchInputTextColor3 = nil,
	searchInputTextSize = nil,
	searchInputTextTransparency = nil,
	searchPlaceholderTextTransparency = nil,
	searchPlaceholderTextColor3 = nil,
	searchPlaceholderText = nil,
	searchClearIconColor3 = nil,
	searchClearIcon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
	searchDividerColor3 = Color3.new(1, 0, 1),
	searchDividerTransparency = 0,
	searchDividerHeight = 1,
	scrollBarImageTransparency = 0,
	scrollBarImageColor3 = Color3.new(1, 0, 1),
	entries = {},
	renderEntry = nil,
	entryHeight = 54,
	scrollTouchedBottomCallback = nil,
	filterPredicate = function(_, _) -- line: 52
		return true
	end,
	sortComparator = function(_, _) -- line: 56
		return true
	end
}

function v5.shouldUpdate(p5, p6, p7) -- line: 61
	if p7 ~= p5.state then
		return true
	end

	if p6 == p5.props then
		return false
	end

	for k, v in pairs(p6) do
		if k == "extraProps" and not p5.props.extraProps then
			return true
		end

		if v ~= p5.props[k] then
			return true
		end
	end

	for k, v in pairs(p5.props) do
		if k ~= "extraProps" then
			if v == p6[k] then
				continue
			end

			return true
		end

		if not p6.extraProps then
			return true
		end

		for k2, v2 in pairs(v) do
			if v2 ~= p6.extraProps[k2] then
				return true
			end
		end
	end

	return false
end
function v5.init(p8) -- line: 105
	p8:setState({})
end
function v5.render(p9) -- line: 109
	-- upvalues: Roact (copy), SortedList (copy), CallbackInputBoxWithIcon (copy)
	local filterPredicate = p9.props.filterPredicate
	local filterText = p9.state.filterText
	local t1 = {}
	local n1 = 0

	for _, v in pairs(p9.props.entries) do
		if filterPredicate(filterText, v) then
			n1 += 1
			table.insert(t1, v)
		end
	end

	local t2 = {
		sortedList = Roact.createElement(SortedList, {
			entries = t1,
			renderEntry = p9.props.renderEntry,
			entryHeight = p9.props.entryHeight,
			sortComparator = p9.props.sortComparator
		})
	}

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		layout = Roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		dividerTop = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			BackgroundColor3 = p9.props.searchDividerColor3,
			BackgroundTransparency = p9.props.searchDividerTransparency,
			Size = UDim2.new(1, 0, 0, p9.props.searchDividerHeight)
		}),
		callbackBoxContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -p9.props.searchBoxBorderThickness * 2, 0, p9.props.searchBoxHeight + p9.props.searchBoxTopPadding + p9.props.searchBoxBottomPadding)
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, p9.props.searchBoxBottomPadding),
				PaddingLeft = UDim.new(0, p9.props.searchBoxLeftPadding),
				PaddingRight = UDim.new(0, p9.props.searchBoxRightPadding),
				PaddingTop = UDim.new(0, p9.props.searchBoxTopPadding)
			}),
			callbackBox = Roact.createElement(CallbackInputBoxWithIcon, {
				backgroundTransparency = p9.props.searchBackgroundTransparency,
				backgroundColor3 = p9.props.searchBackgroundColor3,
				borderColor = p9.props.searchBoxBorderColor,
				borderTransparency = p9.props.searchBoxBorderTransparency,
				borderThickness = p9.props.searchBoxBorderThickness,
				cornerRadius = p9.props.searchBoxCornerRadius,
				iconCellWidth = p9.props.searchIconCellWidth,
				iconSize = p9.props.searchIconSize,
				iconColor3 = p9.props.searchIconColor3,
				iconTransparency = p9.props.searchIconTransparency,
				iconImage = p9.props.searchIconImage,
				inputTextFont = p9.props.searchInputTextFont,
				inputTextColor3 = p9.props.searchInputTextColor3,
				inputTextSize = p9.props.searchInputTextSize,
				inputTextTransparency = p9.props.searchInputTextTransparency,
				placeholderTextTransparency = p9.props.searchPlaceholderTextTransparency,
				placeholderTextColor3 = p9.props.searchPlaceholderTextColor3,
				placeholderText = p9.props.searchPlaceholderText,
				clearIconColor3 = p9.props.searchClearIconColor3,
				clearIcon = p9.props.searchClearIcon,
				textChangedCallback = function(p10) -- line: 195
					-- upvalues: p9 (copy)
					p9:setState({
						filterText = p10
					})
				end
			})
		}),
		dividerBottom = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 3,
			BackgroundColor3 = p9.props.searchDividerColor3,
			BackgroundTransparency = p9.props.searchDividerTransparency,
			Size = UDim2.new(1, 0, 0, p9.props.searchDividerHeight)
		}),
		entryList = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -p9.props.searchBoxHeight - p9.props.searchBoxTopPadding - p9.props.searchBoxBottomPadding - p9.props.searchDividerHeight * 2),
			CanvasSize = UDim2.new(0, 0, 0, n1 * p9.props.entryHeight),
			BackgroundTransparency = 1,
			ScrollBarThickness = 5,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageTransparency = p9.props.scrollBarImageTransparency,
			ScrollBarImageColor3 = p9.props.scrollBarImageColor3,
			BottomImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			MidImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			TopImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			LayoutOrder = 4,
			[Roact.Change.CanvasPosition] = function(p11) -- line: 234
				-- upvalues: p9 (copy)
				local YOffset = p11.CanvasSize.Y.Offset

				if not p9.isTouchingBottom and YOffset <= p11.CanvasPosition.Y + p11.AbsoluteSize.Y then
					p9.isTouchingBottom = true

					if p9.props.scrollTouchedBottomCallback then
						p9.props.scrollTouchedBottomCallback()

						return
					end
				elseif YOffset > p11.CanvasPosition.Y + p11.AbsoluteSize.Y then
					p9.isTouchingBottom = false
				end
			end
		}, t2)
	})
end

return v5
