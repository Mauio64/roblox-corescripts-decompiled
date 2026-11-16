require(script.Parent.UniversalMessage.Types)

local function getDefaultCooldownKey(p): nil | string
	return if p.kind == "preset" then "preset" else nil
end

return getDefaultCooldownKey
