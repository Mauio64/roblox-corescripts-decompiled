local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant

local function HeroUnitActionButton(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		text = props.action.text,
		variant = buttonVariant.Emphasis,
		size = props.size,
		width = 0,
		onActivated = 0,
		testId = 0
	}
	local v7 = if props.width then UDim.new(0, props.width) else nil
	v6.width = v7
	v6.onActivated = props.action.onActivated
	v6.testId = props.testId
	return createElement(button, v6)
end

return HeroUnitActionButton
