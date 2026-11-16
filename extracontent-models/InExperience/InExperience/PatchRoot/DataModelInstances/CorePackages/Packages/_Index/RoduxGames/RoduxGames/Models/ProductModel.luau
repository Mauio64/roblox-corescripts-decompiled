local parent = script:FindFirstAncestor("RoduxGames").Parent
local t = require(parent.t)

local ProductModel = {}

function ProductModel.new(p)
	assert(ProductModel.isValid(p))

	ProductModel.__index = ProductModel

	setmetatable(p, ProductModel)

	return p
end

function ProductModel.mock(options)
	local v = options or {}

	return (ProductModel.new({
		productId = v.productId or "productId",
		sellerId = v.sellerId or "sellerId",
		price = v.price or 666,
		isForSale = v.isForSale or true
	}))
end

function ProductModel.format(data)
	return (ProductModel.new({
		productId = tostring(data.productId),
		sellerId = tostring(data.sellerId),
		isForSale = data.isForSale or false,
		price = data.price or 0
	}))
end

ProductModel.isValid = t.strictInterface({
	productId = t.string,
	sellerId = t.string,
	price = t.number,
	isForSale = t.boolean
})

return ProductModel
