local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/fyH")
local module2 = require("@luauforge/deferred/fzL")
local module3 = require("@luauforge/deferred/fzP")
local module4 = require("@luauforge/deferred/fzU")

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
