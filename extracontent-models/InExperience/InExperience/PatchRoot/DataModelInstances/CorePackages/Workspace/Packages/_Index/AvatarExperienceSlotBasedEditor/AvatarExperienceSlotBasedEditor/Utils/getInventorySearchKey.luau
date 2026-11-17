local InventorySearchConstants = require(script.Parent.Parent.InventorySearchConstants)

local function getInventorySearchKey(p: string)
	return InventorySearchConstants.KeyPrefix .. p
end

return getInventorySearchKey
