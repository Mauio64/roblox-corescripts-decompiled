local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local BulkPurchaseSuccess = require(script.Parent.BulkPurchaseSuccess)
local useBulkPurchaseSuccessProps = require(script.Parent.useBulkPurchaseSuccessProps)

local function BulkPurchaseSuccessContainer()
	local v = useBulkPurchaseSuccessProps()
	return React.createElement(BulkPurchaseSuccess, v)
end

return BulkPurchaseSuccessContainer
