local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local console = LuauPolyfill.console

local function infoLog(...)
	return console.log(...)
end

return infoLog
