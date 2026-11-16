local parent = script.Parent.Parent
local Number = require(parent.Number)

return function(p)
	local v = p and true or false

	if v then
		if p == 0 or p == "" then
			return false
		end

		return not Number.isNaN(p)
	end

	return v
end
