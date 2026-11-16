local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact

local SortedList = require(script.Parent.SortedList)
local CallbackInputBoxWithIcon = require(script.Parent.CallbackInputBoxWithIcon)

local extended = roact.Component:extend("FilteredScrollingList")
extended.defaultProps = {
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
	filterPredicate = function(_, _): boolean
		return true
	end,
	sortComparator = function(_, _): boolean
		return true
	end
}

function extended.shouldUpdate(p, p2, p3): boolean
	if p3 ~= p.state then
		return true
	end

	if p2 == p.props then
		return false
	end

	for k, v in pairs(p2) do
		if k == "extraProps" and not p.props.extraProps or p.props[k] ~= v then
			return true
		end
	end

	for k, v in pairs(p.props) do
		if k == "extraProps" then
			if not p2.extraProps then
				return true
			end

			for k2, v2 in pairs(v) do
				if p2.extraProps[k2] ~= v2 then
					return true
				end
			end
		elseif p2[k] ~= v then
			return true
		end
	end

	return false
end

function extended.init(object)
	object:setState({})
end

function extended:render()
	local filterPredicate = self.props.filterPredicate
	local filterText = self.state.filterText
	local count = 0
	local entries = {}

	for _, entry in pairs(self.props.entries) do
		if not filterPredicate(filterText, entry) then
			continue
		end

		count += 1
		table.insert(entries, entry)
	end

	local v = {
		sortedList = roact.createElement(SortedList, {
			entries = entries,
			renderEntry = self.props.renderEntry,
			entryHeight = self.props.entryHeight,
			sortComparator = self.props.sortComparator
		})
	}

	return roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		layout = roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		dividerTop = roact.createElement("Frame", {
			BackgroundColor3 = self.props.searchDividerColor3,
			BackgroundTransparency = self.props.searchDividerTransparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, self.props.searchDividerHeight),
			LayoutOrder = 1
		}),
		callbackBoxContainer = roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(
				1,
				-self.props.searchBoxBorderThickness * 2,
				0,
				self.props.searchBoxHeight + self.props.searchBoxTopPadding + self.props.searchBoxBottomPadding
			),
			LayoutOrder = 2
		}, {
			UIPadding = roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, self.props.searchBoxBottomPadding),
				PaddingLeft = UDim.new(0, self.props.searchBoxLeftPadding),
				PaddingRight = UDim.new(0, self.props.searchBoxRightPadding),
				PaddingTop = UDim.new(0, self.props.searchBoxTopPadding)
			}),
			callbackBox = roact.createElement(CallbackInputBoxWithIcon, {
				backgroundTransparency = self.props.searchBackgroundTransparency,
				backgroundColor3 = self.props.searchBackgroundColor3,
				borderColor = self.props.searchBoxBorderColor,
				borderTransparency = self.props.searchBoxBorderTransparency,
				borderThickness = self.props.searchBoxBorderThickness,
				cornerRadius = self.props.searchBoxCornerRadius,
				iconCellWidth = self.props.searchIconCellWidth,
				iconSize = self.props.searchIconSize,
				iconColor3 = self.props.searchIconColor3,
				iconTransparency = self.props.searchIconTransparency,
				iconImage = self.props.searchIconImage,
				inputTextFont = self.props.searchInputTextFont,
				inputTextColor3 = self.props.searchInputTextColor3,
				inputTextSize = self.props.searchInputTextSize,
				inputTextTransparency = self.props.searchInputTextTransparency,
				placeholderTextTransparency = self.props.searchPlaceholderTextTransparency,
				placeholderTextColor3 = self.props.searchPlaceholderTextColor3,
				placeholderText = self.props.searchPlaceholderText,
				clearIconColor3 = self.props.searchClearIconColor3,
				clearIcon = self.props.searchClearIcon,
				textChangedCallback = function(filterText2)
					self:setState({ filterText = filterText2 })
				end
			})
		}),
		dividerBottom = roact.createElement("Frame", {
			BackgroundColor3 = self.props.searchDividerColor3,
			BackgroundTransparency = self.props.searchDividerTransparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, self.props.searchDividerHeight),
			LayoutOrder = 3
		}),
		entryList = roact.createElement("ScrollingFrame", {
			Size = UDim2.new(
				1,
				0,
				1,
				-self.props.searchBoxHeight - self.props.searchBoxTopPadding - self.props.searchBoxBottomPadding - self.props.searchDividerHeight * 2
			),
			CanvasSize = UDim2.new(0, 0, 0, count * self.props.entryHeight),
			BackgroundTransparency = 1,
			ScrollBarThickness = 5,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageTransparency = self.props.scrollBarImageTransparency,
			ScrollBarImageColor3 = self.props.scrollBarImageColor3,
			BottomImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			MidImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			TopImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			LayoutOrder = 4,
			[roact.Change.CanvasPosition] = function(data)
				local offset = data.CanvasSize.Y.Offset

				if self.isTouchingBottom or not (offset <= data.CanvasPosition.Y + data.AbsoluteSize.Y) then
					if data.CanvasPosition.Y + data.AbsoluteSize.Y < offset then
						self.isTouchingBottom = false
					end
				else
					self.isTouchingBottom = true

					if self.props.scrollTouchedBottomCallback then
						self.props.scrollTouchedBottomCallback()
					end
				end
			end
		}, v)
	})
end

return extended
