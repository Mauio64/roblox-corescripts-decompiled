local parent = script:FindFirstAncestor("Localization").Parent
local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)
local LocalizationConsumer = require(script.Parent.LocalizationConsumer)

local function withLocalization(stringsToBeLocalized)
	ArgCheck.isType(stringsToBeLocalized, "table", "stringsToBeLocalized passed to withLocalization()")

	return function(render)
		ArgCheck.isType(render, "function", "render passed to withLocalization()")

		return React.createElement(LocalizationConsumer, {
			render = render,
			stringsToBeLocalized = stringsToBeLocalized
		})
	end
end

return withLocalization
