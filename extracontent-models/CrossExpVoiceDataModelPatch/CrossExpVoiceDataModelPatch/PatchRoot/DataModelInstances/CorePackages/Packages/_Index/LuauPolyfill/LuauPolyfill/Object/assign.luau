local None = require(script.Parent.None)
local parent = script.Parent.Parent
require(parent.types)

return function(p, items, items2, items3, ...)
	if items ~= nil and typeof(items) == "table" then
		for k, item in pairs(items) do
			if item == None then
				p[k] = nil
			else
				p[k] = item
			end
		end
	end

	if items2 ~= nil and typeof(items2) == "table" then
		for k, item in pairs(items2) do
			if item == None then
				p[k] = nil
			else
				p[k] = item
			end
		end
	end

	if items3 ~= nil and typeof(items3) == "table" then
		for k, item in pairs(items3) do
			if item == None then
				p[k] = nil
			else
				p[k] = item
			end
		end
	end

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		if not (v ~= nil and typeof(v) == "table") then
			continue
		end

		for k, v2 in pairs(v) do
			if v2 == None then
				p[k] = nil
			else
				p[k] = v2
			end
		end
	end

	return p
end
