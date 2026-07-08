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
local v12 = Roact.Component:extend("TabRowContainer")

local function initTabList(p1) -- line: 19
	-- upvalues: TextService (copy), Constants (copy)
	local t1 = {}
	local n1 = 0
	local n2 = 0

	for k, _ in pairs(p1) do
		local TextSize = TextService:GetTextSize(k, Constants.DefaultFontSize.TabBar, Constants.Font.TabBar, Vector2.new(0, 0))

		t1[k] = TextSize.X
		n1 += TextSize.X
		n2 += 1
	end

	return t1, n1, n2
end

function v12.init(p2) -- line: 33
	-- upvalues: initTabList (copy)
	local tabList = p2.props.tabList
	local v25, v26, v27 = initTabList(tabList)

	p2.state = {
		currContainerWidth = 0,
		textWidths = v25,
		totalTextLength = v26,
		totalTabCount = v27
	}

	function p2.onTabButtonClicked(p3) -- line: 45
		-- upvalues: p2 (copy)
		for k, v in pairs(p2.props.tabList) do
			if p3 == v.layoutOrder then
				p2.props.dispatchSetActiveTab(k, v.hasClientServer)

				return
			end
		end
	end
end
function v12.didUpdate(p4, p5, _) -- line: 55
	-- upvalues: initTabList (copy)
	if p5.tabList ~= p4.props.tabList then
		local v31, v32, v33 = initTabList(p4.props.tabList)

		p4:setState({
			textWidths = v31,
			totalTextLength = v32,
			totalTabCount = v33
		})
	end
end
function v12.render(p7) -- line: 66
	-- upvalues: TabOverlapThreshold (copy), Constants (copy), Roact (copy), FullScreenDropDownButton (copy), TabDropDownWidth (copy), DropDown (copy), TabRowButton (copy)
	local tabList = p7.props.tabList
	local currTabIndex = p7.props.currTabIndex
	local formFactor = p7.props.formFactor
	local windowWidth = p7.props.windowWidth
	local frameHeight = p7.props.frameHeight
	local layoutOrder = p7.props.layoutOrder
	local textWidths = p7.state.textWidths
	local totalTextLength = p7.state.totalTextLength
	local totalTabCount = p7.state.totalTabCount
	local t2 = {}
	local v45 = (windowWidth - totalTextLength) / totalTabCount
	local v46 = v45 % 1 * totalTabCount / 2
	local v47 = v45 < TabOverlapThreshold and windowWidth > 0
	local v48 = formFactor == Constants.FormFactor.Small

	if tabList then
		if v47 or v48 then
			local t3 = {}
			local layoutOrder2 = tabList[currTabIndex].layoutOrder

			for k, v in pairs(tabList) do
				t3[v.layoutOrder] = k
			end

			if v48 then
				return Roact.createElement(FullScreenDropDownButton, {
					buttonSize = UDim2.new(0, TabDropDownWidth, 0, frameHeight),
					dropDownList = t3,
					selectedIndex = layoutOrder2,
					onSelection = p7.onTabButtonClicked,
					layoutOrder = layoutOrder
				})
			end

			if v47 then
				return Roact.createElement(DropDown, {
					buttonSize = UDim2.new(0, TabDropDownWidth, 0, frameHeight),
					dropDownList = t3,
					selectedIndex = layoutOrder2,
					onSelection = p7.onTabButtonClicked
				})
			end
		else
			for k, v in pairs(tabList) do
				if textWidths[k] then
					t2[k] = Roact.createElement(TabRowButton, {
						index = v.layoutOrder,
						name = k,
						padding = v45,
						textWidth = v47 and TabDropDownWidth or textWidths[k],
						isSelected = k == currTabIndex,
						layoutOrder = v.layoutOrder,
						onTabButtonClicked = p7.onTabButtonClicked
					})
				end
			end
		end

		t2.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Horizontal
		})
	end

	return Roact.createElement("Frame", {
		Transparency = 1,
		Size = UDim2.new(1, 0, 0, frameHeight),
		Position = UDim2.new(0, v46, 0, 0),
		LayoutOrder = layoutOrder
	}, t2)
end

local function mapStateToProps(p8, _) -- line: 146
	return {
		tabList = p8.MainView.tabList,
		currTabIndex = p8.MainView.currTabIndex
	}
end
local function mapDispatchToProps(p10) -- line: 153
	-- upvalues: SetActiveTab (copy)
	return {
		dispatchSetActiveTab = function(p11, p12) -- line: 155
			-- upvalues: p10 (copy), SetActiveTab (copy)
			p10(SetActiveTab(p11, p12))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v12)
