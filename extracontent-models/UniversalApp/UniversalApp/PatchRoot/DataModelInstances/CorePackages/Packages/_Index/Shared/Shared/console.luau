local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ReactGlobals = require(scriptParentParent.ReactGlobals)
local console = require(scriptParentParent.LuauPolyfill).console
local consoleWithStackDev = require(scriptParent.consoleWithStackDev)

if ReactGlobals.__DEV__ then
	return (setmetatable({
		warn = consoleWithStackDev.warn,
		error = consoleWithStackDev.error
	}, {
		__index = console
	}))
end

return console
