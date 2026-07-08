local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local BulkPurchaseRequest = require(script.Parent.BulkPurchaseRequest)
local useBulkPurchaseRequestProps = require(script.Parent.useBulkPurchaseRequestProps)

local function BulkPurchaseRequestContainer() -- line: 8
	-- upvalues: useBulkPurchaseRequestProps (copy), React (copy), BulkPurchaseRequest (copy)
	local v6 = useBulkPurchaseRequestProps()

	return React.createElement(BulkPurchaseRequest, v6)
end

return BulkPurchaseRequestContainer
