local parent = script.Parent.Parent

local Constants = require(parent.Constants)
local validateFont = require(parent.Validator.validateFont)
local FontLoader = require(script.Parent.FontLoader)
require(parent.StyleTypes)

return function(value, p)
	local v = FontLoader.new(p)
	local v2 = {
		[Constants.FontName.Gotham:lower()] = v:loadFont(),
		[Constants.FontName.Classic:lower()] = v:loadFont(Enum.Font.Cartoon)
	}
	local selected

	if not (value == nil or not (#value > 0)) then
		selected = v2[value:lower()]
	end

	if selected == nil then
		selected = v2[Constants.DefaultFontName:lower()]
	end

	assert(validateFont(selected))
	return selected
end
