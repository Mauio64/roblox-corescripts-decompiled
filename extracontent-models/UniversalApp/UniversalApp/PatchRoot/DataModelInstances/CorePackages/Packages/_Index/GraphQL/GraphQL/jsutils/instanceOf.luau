local isNillish = require(script.Parent.Parent.luaUtils.isNillish).isNillish

local function instanceOf(p1, p2) -- line: 10
	-- upvalues: isNillish (copy)
	if isNillish(p1) then
		return false
	end

	if typeof(p1) ~= "table" or typeof(p2) ~= "table" then
		return false
	end

	if p2.new ~= nil and p1.new == p2.new then
		return true
	end

	local mt = getmetatable(p1)

	repeat
		local v6 = mt

		if typeof(v6) ~= "table" then
			return false
		end

		if p2 == v6.__index then
			return true
		end

		mt = getmetatable(v6.__index)
	until v6 == mt

	return false
end

return function(p3, p4) -- line: 41
	-- upvalues: instanceOf (copy)
	return instanceOf(p3, p4)
end
