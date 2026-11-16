local parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local React = require(parent.React)

local CommercePurchaseError = require(script.Parent.CommercePurchaseError)
local useCommercePurchaseErrorProps = require(script.Parent.useCommercePurchaseErrorProps)

local function CommercePurchaseErrorContainer()
	local v = useCommercePurchaseErrorProps()
	return React.createElement(CommercePurchaseError, v)
end

return CommercePurchaseErrorContainer
