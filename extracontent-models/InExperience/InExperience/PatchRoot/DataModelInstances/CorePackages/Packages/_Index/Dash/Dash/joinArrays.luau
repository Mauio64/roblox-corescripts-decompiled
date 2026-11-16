local parent = script.Parent
require(parent.Types)

local function joinArrays(...)
	local v = {}

	for _, v2 in { ... } do
		if v2 then
			table.move(v2, 1, #v2, #v + 1, v)
		end
	end

	return v
end

return joinArrays
