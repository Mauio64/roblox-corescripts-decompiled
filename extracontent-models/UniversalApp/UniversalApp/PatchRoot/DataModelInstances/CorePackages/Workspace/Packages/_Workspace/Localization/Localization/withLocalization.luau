local Parent = script:FindFirstAncestor("Localization").Parent
local React = require(Parent.React)
local ArgCheck = require(Parent.ArgCheck)
local LocalizationConsumer = require(script.Parent.LocalizationConsumer)

local function withLocalization(p1) -- line: 7
	-- upvalues: ArgCheck (copy), React (copy), LocalizationConsumer (copy)
	ArgCheck.isType(p1, "table", "stringsToBeLocalized passed to withLocalization()")

	return function(p2) -- line: 10
		-- upvalues: ArgCheck (copy), React (copy), LocalizationConsumer (copy), p1 (copy)
		ArgCheck.isType(p2, "function", "render passed to withLocalization()")

		return React.createElement(LocalizationConsumer, {
			render = p2,
			stringsToBeLocalized = p1
		})
	end
end

return withLocalization
