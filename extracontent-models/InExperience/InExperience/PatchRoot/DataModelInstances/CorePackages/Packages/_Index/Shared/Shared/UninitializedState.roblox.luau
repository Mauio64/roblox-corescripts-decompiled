local console = require(script.Parent.console)
local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local t1 = {}

setmetatable(t1, {
	__metatable = "UninitializedState",
	__index = function(_, _) -- line: 26
		-- upvalues: ReactGlobals (copy), console (copy)
		if ReactGlobals.__DEV__ then
			console.warn("Attempted to access uninitialized state. Use setState to initialize state")
		end

		return nil
	end,
	__newindex = function(_, _) -- line: 34
		-- upvalues: ReactGlobals (copy), console (copy)
		if ReactGlobals.__DEV__ then
			console.error("Attempted to directly mutate state. Use setState to assign new values to state.")
		end

		return nil
	end,
	__tostring = function(_) -- line: 42
		return "<uninitialized component state>"
	end
})

return t1
