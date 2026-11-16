local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local BulkPurchaseError = require(script.Parent.BulkPurchaseError)
local useBulkPurchaseErrorProps = require(script.Parent.useBulkPurchaseErrorProps)

local function BulkPurchaseErrorContainer()
	local v = useBulkPurchaseErrorProps()
	return React.createElement(BulkPurchaseError, v)
end

return BulkPurchaseErrorContainer
