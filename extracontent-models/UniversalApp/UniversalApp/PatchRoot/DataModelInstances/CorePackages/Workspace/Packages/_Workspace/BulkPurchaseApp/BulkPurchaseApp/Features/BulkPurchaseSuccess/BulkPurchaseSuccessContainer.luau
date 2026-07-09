local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local BulkPurchaseSuccess = require(script.Parent.BulkPurchaseSuccess)
local useBulkPurchaseSuccessProps = require(script.Parent.useBulkPurchaseSuccessProps)

local function BulkPurchaseSuccessContainer() -- line: 8
	-- upvalues: useBulkPurchaseSuccessProps (copy), React (copy), BulkPurchaseSuccess (copy)
	local v6 = useBulkPurchaseSuccessProps()

	return React.createElement(BulkPurchaseSuccess, v6)
end

return BulkPurchaseSuccessContainer
