local scriptParent = script.Parent

require(scriptParent.Types)

local function joinArrays(...) -- line: 10
	local t1 = {}

	for _, v5 in { ... } do
		if v5 then
			table.move(v5, 1, #v5, #t1 + 1, t1)
		end
	end

	return t1
end

return joinArrays
