local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error

local function invariant(p, formatString, ...)
	if not p then
		error(Error(string.format(formatString, ...)))
	end
end

return invariant
