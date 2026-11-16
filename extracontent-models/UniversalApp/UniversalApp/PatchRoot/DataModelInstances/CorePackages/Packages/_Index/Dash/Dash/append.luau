local parent = script.Parent
local None = require(parent.None)
local forEachArgs = require(parent.forEachArgs)
local forEach = require(parent.forEach)
local insert = table.insert

local function append(list, ...)
	forEachArgs(function(p)
		if p == None or p == nil then
			return
		end

		forEach(p, function(p2)
			insert(list, p2)
		end)
	end, ...)
	return list
end

return append
