local Parent = script:FindFirstAncestor("RoduxGames").Parent
local t = require(Parent.t)
local t1 = {}

function t1.new(p1) -- line: 13
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 25
	-- upvalues: t1 (copy)
	local v6 = p2 or {}

	return (t1.new({
		productId = v6.productId or "productId",
		sellerId = v6.sellerId or "sellerId",
		price = v6.price or 666,
		isForSale = v6.isForSale or true
	}))
end
function t1.format(p3) -- line: 38
	-- upvalues: t1 (copy)
	return (t1.new({
		productId = tostring(p3.productId),
		sellerId = tostring(p3.sellerId),
		isForSale = p3.isForSale or false,
		price = p3.price or 0
	}))
end

t1.isValid = t.strictInterface({
	productId = t.string,
	sellerId = t.string,
	price = t.number,
	isForSale = t.boolean
})

return t1
