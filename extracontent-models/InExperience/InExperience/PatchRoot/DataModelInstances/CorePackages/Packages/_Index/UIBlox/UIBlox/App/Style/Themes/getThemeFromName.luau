local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Constants = require(scriptParentParent.Constants)
local validateTheme = require(scriptParentParent.Validator.validateTheme)
local t1 = {
	[Constants.ThemeName.Dark:lower()] = require(scriptParent.DarkTheme),
	[Constants.ThemeName.Light:lower()] = require(scriptParent.LightTheme)
}

return function(s1: string) -- line: 15
	-- upvalues: t1 (copy), Constants (copy), validateTheme (copy)
	local v7 = nil

	if s1 ~= nil and #s1 > 0 then
		v7 = t1[s1:lower()]
	end

	if v7 == nil then
		v7 = t1[Constants.DefaultThemeName:lower()]
	end

	assert(validateTheme(v7))

	return v7
end
