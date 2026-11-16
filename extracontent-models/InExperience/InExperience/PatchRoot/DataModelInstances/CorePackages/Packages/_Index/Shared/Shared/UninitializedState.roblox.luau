local console = require(script.Parent.console)

local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Roblox = {}

setmetatable(Roblox, {
	__index = function(_, _): nil
		if ReactGlobals.__DEV__ then
			console.warn("Attempted to access uninitialized state. Use setState to initialize state")
		end

		return nil
	end,
	__newindex = function(_, _): nil
		if ReactGlobals.__DEV__ then
			console.error("Attempted to directly mutate state. Use setState to assign new values to state.")
		end

		return nil
	end,
	__tostring = function(_): string
		return "<uninitialized component state>"
	end,
	__metatable = "UninitializedState"
})

return Roblox
