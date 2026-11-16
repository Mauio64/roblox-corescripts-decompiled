local deepEqual = require(script.Parent.deepEqual)
local deepContains = require(script.Parent.deepContains)

return function(list, p, p2): boolean
	for _, item in ipairs(list) do
		if p2 then
			if deepContains(item, p) then
				return true
			end
		elseif deepEqual(item, p) then
			return true
		end
	end

	return false
end
