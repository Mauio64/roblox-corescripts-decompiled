local parent = script.Parent
local parent2 = parent.Parent
local ReactGlobals = require(parent2.ReactGlobals)
local LuauPolyfill = require(parent2.LuauPolyfill)
local console = LuauPolyfill.console
local consoleWithStackDev = require(parent.consoleWithStackDev)

if ReactGlobals.__DEV__ then
	return (setmetatable({ warn = consoleWithStackDev.warn, error = consoleWithStackDev.error }, {
		__index = console
	}))
end

return console
