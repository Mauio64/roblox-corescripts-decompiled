local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local validateFont = require(ParentParent.Validator.validateFont)
local FontLoader = require(script.Parent.FontLoader)

require(ParentParent.StyleTypes)

return function(p1, p2) -- line: 9
	-- upvalues: FontLoader (copy), Constants (copy), validateFont (copy)
	local v7 = FontLoader.new(p2)
	local t1 = {
		[Constants.FontName.Gotham:lower()] = v7:loadFont()
	}
	local v9 = nil

	if p1 ~= nil and #p1 > 0 then
		v9 = t1[p1:lower()]
	end

	if v9 == nil then
		v9 = t1[Constants.DefaultFontName:lower()]
	end

	assert(validateFont(v9))

	return v9
end
