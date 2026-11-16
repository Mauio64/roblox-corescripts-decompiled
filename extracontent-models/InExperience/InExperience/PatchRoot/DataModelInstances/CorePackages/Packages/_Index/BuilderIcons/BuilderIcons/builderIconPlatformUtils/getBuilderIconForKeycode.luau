local KeycodeMappings = require(script.Parent.KeycodeMappings)
local Platform = require(script.Parent.Platform)
local getInputPlatform = require(script.Parent.getInputPlatform)

local function getBuilderIconForKeycode(p)
	local inputPlatform = getInputPlatform()
	local name = p.Name
	local v = KeycodeMappings[inputPlatform][name]

	if v then
		return v
	end

	assert(KeycodeMappings[Platform.Default][name], `{name} has no associated BuilderIcon`)
	return KeycodeMappings[Platform.Default][name]
end

return getBuilderIconForKeycode
