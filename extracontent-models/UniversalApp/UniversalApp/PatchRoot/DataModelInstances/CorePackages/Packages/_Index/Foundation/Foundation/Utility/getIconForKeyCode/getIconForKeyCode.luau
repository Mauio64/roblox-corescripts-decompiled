local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.InputPlatform)
local KeyCodeIconMappings = require(script.Parent.KeyCodeIconMappings)

local function getIconForKeyCode(p, p2)
	return KeyCodeIconMappings.getIconForKeyName(p.Name, p2)
end

return getIconForKeyCode
