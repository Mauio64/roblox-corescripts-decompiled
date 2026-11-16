local parent = script.Parent
local None = require(parent.None)
require(parent.Types)

local function union(p, items)
	local clone = table.clone(p)

	for k, item in items do
		if item == None then
			clone[k] = nil
		else
			clone[k] = item
		end
	end

	return clone
end

return union
