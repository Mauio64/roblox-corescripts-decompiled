local parent = script.Parent
local None = require(parent.None)
require(parent.Types)
local forEach = require(parent.forEach)
local forEachArgs = require(parent.forEachArgs)

local function assign(p, ...)
	forEachArgs(function(p2)
		if p2 == nil or p2 == None then
			return
		end

		forEach(p2, function(p3, p4)
			if p3 == None then
				p[p4] = nil
			else
				p[p4] = p3
			end
		end)
	end, ...)
	return p
end

return assign
