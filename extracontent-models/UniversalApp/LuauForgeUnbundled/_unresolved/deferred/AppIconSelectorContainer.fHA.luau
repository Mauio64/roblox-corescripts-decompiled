local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/fGx")
local module2 = require("@luauforge/deferred/fHB")
local module3 = require("@luauforge/deferred/fHE")
local module4 = require("@luauforge/deferred/fHJ")

local function AppIconSelectorContainer(props)
	local v5 = module4.useAppIconStrings()
	local v6 = module3(v5.optionLabels)

	return React.createElement(module, {
		style = props.style,
		header = v5.heading,
		description = v5.description,
		layoutOrder = props.layoutOrder,
		topToBottom = true,
		Control = React.createElement(module2, {
			options = v6.options,
			onSelect = v6.onSelect,
			columns = props.columns
		})
	})
end

return AppIconSelectorContainer
