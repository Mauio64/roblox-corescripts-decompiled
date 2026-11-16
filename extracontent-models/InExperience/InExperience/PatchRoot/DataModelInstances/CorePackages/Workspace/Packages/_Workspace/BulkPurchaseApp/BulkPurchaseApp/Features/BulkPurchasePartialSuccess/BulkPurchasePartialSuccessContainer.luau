local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local BulkPurchasePartialSuccess = require(script.Parent.BulkPurchasePartialSuccess)
local useBulkPurchasePartialSuccessProps = require(script.Parent.useBulkPurchasePartialSuccessProps)

local function BulkPurchasePartialSuccessContainer()
	local v = useBulkPurchasePartialSuccessProps()
	return React.createElement(BulkPurchasePartialSuccess, v)
end

return BulkPurchasePartialSuccessContainer
