local KeycodeMappings = require(script.Parent.KeycodeMappings)
local Platform = require(script.Parent.Platform)
local getInputPlatform = require(script.Parent.getInputPlatform)

local function getBuilderIconForKeycode(p1) -- line: 5
	-- upvalues: getInputPlatform (copy), KeycodeMappings (copy), Platform (copy)
	local v6 = getInputPlatform()
	local p1Name = p1.Name
	local v8 = KeycodeMappings[v6][p1Name]

	if v8 then
		return v8
	end

	assert(KeycodeMappings[Platform.Default][p1Name], `{ p1Name } has no associated BuilderIcon`)

	return KeycodeMappings[Platform.Default][p1Name]
end

return getBuilderIconForKeycode
