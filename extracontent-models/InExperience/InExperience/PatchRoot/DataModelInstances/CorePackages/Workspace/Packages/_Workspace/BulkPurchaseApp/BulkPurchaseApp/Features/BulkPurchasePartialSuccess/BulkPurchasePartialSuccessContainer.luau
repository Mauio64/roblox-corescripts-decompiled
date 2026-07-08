local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local BulkPurchasePartialSuccess = require(script.Parent.BulkPurchasePartialSuccess)
local useBulkPurchasePartialSuccessProps = require(script.Parent.useBulkPurchasePartialSuccessProps)

local function BulkPurchasePartialSuccessContainer() -- line: 8
	-- upvalues: useBulkPurchasePartialSuccessProps (copy), React (copy), BulkPurchasePartialSuccess (copy)
	local v6 = useBulkPurchasePartialSuccessProps()

	return React.createElement(BulkPurchasePartialSuccess, v6)
end

return BulkPurchasePartialSuccessContainer
