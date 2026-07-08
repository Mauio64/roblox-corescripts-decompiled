local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local None = require(scriptParent.None)

require(ParentParent.ES7Types)

return function(p1, p2, p3, p4, ...) -- line: 30
	-- upvalues: None (copy)
	if p2 ~= nil and typeof(p2) == "table" then
		for k, v in pairs(p2) do
			if v == None then
				p1[k] = nil
			else
				p1[k] = v
			end
		end
	end

	if p3 ~= nil and typeof(p3) == "table" then
		for k, v in pairs(p3) do
			if v == None then
				p1[k] = nil
			else
				p1[k] = v
			end
		end
	end

	if p4 ~= nil and typeof(p4) == "table" then
		for k, v in pairs(p4) do
			if v == None then
				p1[k] = nil
			else
				p1[k] = v
			end
		end
	end

	for i = 1, select("#", ...) do
		local v15 = select(i, ...)

		if v15 ~= nil and typeof(v15) == "table" then
			for k, v in pairs(v15) do
				if v == None then
					p1[k] = nil
				else
					p1[k] = v
				end
			end
		end
	end

	return p1
end
