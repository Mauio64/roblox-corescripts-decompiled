local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local v6 = Roact.PureComponent:extend("DropdownSelector")

v6.defaultProps = {
	contentMaxWidth = 1e999,
	selectorHeight = 48,
	selectorSpacer = 24,
	paddingHorizontal = 0,
	paddingVertical = 0,
	errorText = "",
	renderErrorItem = function() -- line: 18
	end
}
v6.validateProps = t.strictInterface({
	itemList = t.array(t.strictInterface({
		key = t.string,
		value = t.any
	})),
	screenSize = t.Vector2,
	renderSelectedItem = t.callback,
	contentMaxWidth = t.optional(t.number),
	selectorHeight = t.optional(t.number),
	selectorSpacer = t.optional(t.number),
	paddingHorizontal = t.optional(t.number),
	paddingVertical = t.optional(t.number),
	isDisabled = t.optional(t.boolean),
	errorState = t.optional(t.boolean),
	errorText = t.optional(t.string),
	renderErrorItem = t.optional(t.callback)
})

function v6.init(p1) -- line: 66
	function p1.onSelectionChange(p2) -- line: 67
		-- upvalues: p1 (copy)
		p1:setState({
			selectedKey = p2
		})
	end

	p1:setState({
		selectedKey = nil
	})
end
function v6.getDerivedStateFromProps(p3, p4) -- line: 84
	local itemList = p3.itemList
	local selectedKey = p4.selectedKey

	for _, v in ipairs(itemList) do
		if selectedKey == v.key then
			return nil
		end
	end

	return {
		selectedKey = #itemList > 0 and itemList[1].key or nil
	}
end
function v6.render(p5) -- line: 99
	-- upvalues: Roact (copy), DropdownMenu (copy)
	local itemList = p5.props.itemList
	local screenSize = p5.props.screenSize
	local contentMaxWidth = p5.props.contentMaxWidth
	local selectorHeight = p5.props.selectorHeight
	local selectorSpacer = p5.props.selectorSpacer
	local paddingHorizontal = p5.props.paddingHorizontal
	local paddingVertical = p5.props.paddingVertical
	local isDisabled = p5.props.isDisabled
	local errorState = p5.props.errorState
	local errorText = p5.props.errorText
	local renderErrorItem = p5.props.renderErrorItem
	local renderSelectedItem = p5.props.renderSelectedItem
	local selectedKey = p5.state.selectedKey
	local value = nil
	local t1 = {}

	for _, v in ipairs(itemList) do
		table.insert(t1, {
			text = v.key
		})

		if selectedKey == v.key then
			value = v.value
		end
	end

	local v32 = errorState or #itemList == 0
	local v33 = contentMaxWidth + 2 * paddingHorizontal
	local v34 = selectorHeight + selectorSpacer + paddingVertical

	return Roact.createFragment({
		SelectorFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			Selector = Roact.createElement(DropdownMenu, {
				placeholder = v32 and errorText or selectedKey,
				onChange = p5.onSelectionChange,
				height = UDim.new(0, selectorHeight),
				screenSize = screenSize,
				errorState = errorState,
				isDisabled = isDisabled,
				cellDatas = t1
			}),
			SelectorPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, paddingVertical),
				PaddingLeft = UDim.new(0, paddingHorizontal),
				PaddingRight = UDim.new(0, paddingHorizontal)
			}),
			SelectorMaxWidth = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v33, 1e999)
			})
		}),
		SelectionFrame = Roact.createElement("Frame", {
			ZIndex = -1,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, v34),
			Size = UDim2.new(1, 0, 1, -v34)
		}, v32 and {
			Error = renderErrorItem()
		} or {
			[selectedKey] = renderSelectedItem(value)
		})
	})
end

return v6
