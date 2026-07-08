local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(script.Parent.console)
local n1 = 0
local log = nil
local info = nil
local warn = nil
local error = nil
local group = nil
local groupCollapsed = nil
local groupEnd = nil

local function v12() -- line: 34
end

return {
	disabledLog = v12,
	disableLogs = function() -- line: 43
		-- upvalues: ReactGlobals (copy), n1 (ref), log (ref), console (copy), info (ref), warn (ref), error (ref), group (ref), groupCollapsed (ref), groupEnd (ref), v12 (copy)
		if ReactGlobals.__DEV__ then
			if n1 == 0 then
				log = console.log
				info = console.info
				warn = console.warn
				error = console.error
				group = console.group
				groupCollapsed = console.groupCollapsed
				groupEnd = console.groupEnd
				console.info = v12
				console.log = v12
				console.warn = v12
				console.error = v12
				console.group = v12
				console.groupCollapsed = v12
				console.groupEnd = v12
			end

			n1 += 1
		end
	end,
	reenableLogs = function() -- line: 67
		-- upvalues: ReactGlobals (copy), n1 (ref), console (copy), log (ref), info (ref), warn (ref), error (ref), group (ref), groupCollapsed (ref), groupEnd (ref)
		if ReactGlobals.__DEV__ then
			n1 -= 1

			if n1 == 0 then
				console.log = log
				console.info = info
				console.warn = warn
				console.error = error
				console.group = group
				console.groupCollapsed = groupCollapsed
				console.groupEnd = groupEnd
			end

			if n1 < 0 then
				console.error("disabledDepth fell below zero. This is a bug in React. Please file an issue.")
			end
		end
	end
}
