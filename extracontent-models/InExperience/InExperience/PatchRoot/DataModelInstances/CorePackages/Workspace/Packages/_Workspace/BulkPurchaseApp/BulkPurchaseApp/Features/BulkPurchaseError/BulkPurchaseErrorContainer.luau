local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local BulkPurchaseError = require(script.Parent.BulkPurchaseError)
local useBulkPurchaseErrorProps = require(script.Parent.useBulkPurchaseErrorProps)

local function BulkPurchaseErrorContainer() -- line: 8
	-- upvalues: useBulkPurchaseErrorProps (copy), React (copy), BulkPurchaseError (copy)
	local v6 = useBulkPurchaseErrorProps()

	return React.createElement(BulkPurchaseError, v6)
end

return BulkPurchaseErrorContainer
