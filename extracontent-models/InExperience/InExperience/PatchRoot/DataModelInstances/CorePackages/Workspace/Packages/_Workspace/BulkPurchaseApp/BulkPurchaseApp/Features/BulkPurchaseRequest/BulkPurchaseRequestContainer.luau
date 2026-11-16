local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local BulkPurchaseRequest = require(script.Parent.BulkPurchaseRequest)
local useBulkPurchaseRequestProps = require(script.Parent.useBulkPurchaseRequestProps)

local function BulkPurchaseRequestContainer()
	local v = useBulkPurchaseRequestProps()
	return React.createElement(BulkPurchaseRequest, v)
end

return BulkPurchaseRequestContainer
