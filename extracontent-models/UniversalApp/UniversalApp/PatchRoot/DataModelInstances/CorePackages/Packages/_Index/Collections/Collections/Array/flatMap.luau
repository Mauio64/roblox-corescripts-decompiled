local __DEV__ = _G.__DEV__
local parent = script.Parent
local parent2 = parent.Parent.Parent
local flat = require(parent.flat)
local map = require(parent.map)
require(parent2.ES7Types)

local function flatMap(p, callback, p2)
	if __DEV__ then
		if typeof(p) ~= "table" then
			error(string.format("Array.flatMap called on %s", (typeof(p))))
		end

		if typeof(callback) ~= "function" then
			error("callback is not a function")
		end
	end

	return flat(map(p, callback, p2))
end

return flatMap
