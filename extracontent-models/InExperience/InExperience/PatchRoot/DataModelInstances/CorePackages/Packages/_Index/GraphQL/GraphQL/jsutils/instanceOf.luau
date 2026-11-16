local isNillish = require(script.Parent.Parent.luaUtils.isNillish)
local isNillish2 = isNillish.isNillish

local function instanceOf(p, p2): boolean
	if isNillish2(p) or (typeof(p) ~= "table" or typeof(p2) ~= "table") then
		return false
	end

	if p2.new ~= nil and p.new == p2.new then
		return true
	end

	local v = getmetatable(p)

	while typeof(v) == "table" do
		if v.__index == p2 then
			return true
		end

		local metatable = getmetatable(v.__index)

		if v == metatable then
			return false
		end

		v = metatable
	end

	return false
end

return function(p, p2)
	return instanceOf(p, p2)
end
