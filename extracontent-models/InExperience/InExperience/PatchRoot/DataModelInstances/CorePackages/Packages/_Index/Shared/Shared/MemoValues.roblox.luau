local class = {}
local Roblox = {}

function Roblox.pack(...)
	if select("#", ...) == 1 then
		return (...)
	end

	return (setmetatable(table.pack(...), class))
end

function Roblox.unpack(list)
	if type(list) == "table" and rawequal(getmetatable(list), class) then
		return table.unpack(list, 1, list.n)
	end

	return list
end

return Roblox
