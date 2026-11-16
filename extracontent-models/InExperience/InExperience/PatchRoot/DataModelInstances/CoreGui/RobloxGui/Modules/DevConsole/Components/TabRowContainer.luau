local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local TextService = game:GetService("TextService")

local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)

local TabRowButton = require(script.Parent.TabRowButton)
local DropDown = require(script.Parent.DropDown)
local FullScreenDropDownButton = require(script.Parent.FullScreenDropDownButton)

local Constants = require(script.Parent.Parent.Constants)
local TabDropDownWidth = Constants.TabRowFormatting.TabDropDownWidth
local TabOverlapThreshold = Constants.TabRowFormatting.TabOverlapThreshold

local extended = Roact.Component:extend("TabRowContainer")

local function initTabList(tabList)
	local result = {}
	local total = 0
	local count = 0

	for k, _ in pairs(tabList) do
		local textSize = TextService:GetTextSize(
			k,
			Constants.DefaultFontSize.TabBar,
			Constants.Font.TabBar,
			Vector2.new(0, 0)
		)
		result[k] = textSize.X
		total += textSize.X
		count += 1
	end

	return result, total, count
end

function extended:init()
	local textWidths, totalTextLength, totalTabCount = initTabList(self.props.tabList)

	self.state = {
		textWidths = textWidths,
		totalTextLength = totalTextLength,
		totalTabCount = totalTabCount,
		currContainerWidth = 0
	}

	function self.onTabButtonClicked(p)
		for k, tab in pairs(self.props.tabList) do
			if tab.layoutOrder == p then
				self.props.dispatchSetActiveTab(k, tab.hasClientServer)
				break
			end
		end
	end
end

function extended.didUpdate(object, p, _)
	if p.tabList ~= object.props.tabList then
		local textWidths, totalTextLength, totalTabCount = initTabList(object.props.tabList)
		object:setState({
			textWidths = textWidths,
			totalTextLength = totalTextLength,
			totalTabCount = totalTabCount
		})
	end
end

function extended.render(props)
	local tabList = props.props.tabList
	local currTabIndex = props.props.currTabIndex
	local formFactor = props.props.formFactor
	local windowWidth = props.props.windowWidth
	local frameHeight = props.props.frameHeight
	local layoutOrder = props.props.layoutOrder

	local textWidths = props.state.textWidths
	local totalTextLength = props.state.totalTextLength
	local totalTabCount = props.state.totalTabCount
	local children = {}

	local padding = (windowWidth - totalTextLength) / totalTabCount

	local v = padding % 1 * totalTabCount / 2
	local v2

	if padding < TabOverlapThreshold then
		v2 = windowWidth > 0
	else
		v2 = false
	end

	local v3 = formFactor == Constants.FormFactor.Small

	if tabList then
		if v2 or v3 then
			local layoutOrder2 = tabList[currTabIndex].layoutOrder
			local dropDownList = {}

			for k, tab in pairs(tabList) do
				dropDownList[tab.layoutOrder] = k
			end

			if v3 then
				return Roact.createElement(FullScreenDropDownButton, {
					buttonSize = UDim2.new(0, TabDropDownWidth, 0, frameHeight),
					dropDownList = dropDownList,
					selectedIndex = layoutOrder2,
					onSelection = props.onTabButtonClicked,
					layoutOrder = layoutOrder
				})
			end

			if v2 then
				return Roact.createElement(DropDown, {
					buttonSize = UDim2.new(0, TabDropDownWidth, 0, frameHeight),
					dropDownList = dropDownList,
					selectedIndex = layoutOrder2,
					onSelection = props.onTabButtonClicked
				})
			end
		else
			for k, tab in pairs(tabList) do
				if textWidths[k] then
					children[k] = Roact.createElement(TabRowButton, {
						index = tab.layoutOrder,
						name = k,
						padding = padding,
						textWidth = v2 and TabDropDownWidth or textWidths[k],
						isSelected = k == currTabIndex,
						layoutOrder = tab.layoutOrder,
						onTabButtonClicked = props.onTabButtonClicked
					})
				end
			end
		end

		children.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Horizontal
		})
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, frameHeight),
			Position = UDim2.new(0, v, 0, 0),
			Transparency = 1,
			LayoutOrder = layoutOrder
		},
		children
	)
end

local function mapStateToProps(p, _)
	return { tabList = p.MainView.tabList, currTabIndex = p.MainView.currTabIndex }
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetActiveTab = function(p, p2)
			callback(SetActiveTab(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
