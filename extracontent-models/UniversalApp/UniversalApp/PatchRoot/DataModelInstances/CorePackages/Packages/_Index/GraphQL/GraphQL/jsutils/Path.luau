local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Path = {}

function Path.addPath(prev, p, typename: string?)
	return { prev = prev, key = p, typename = typename }
end

function Path.pathToArray(p)
	local v = {}

	while p do
		table.insert(v, p.key)
		p = p.prev
	end

	return Array.reverse(v)
end

return Path
