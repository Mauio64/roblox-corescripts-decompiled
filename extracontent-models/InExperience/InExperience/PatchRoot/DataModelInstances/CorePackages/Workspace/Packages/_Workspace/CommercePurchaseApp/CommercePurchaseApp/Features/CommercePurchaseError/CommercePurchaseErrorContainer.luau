local Parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local React = require(Parent.React)
local CommercePurchaseError = require(script.Parent.CommercePurchaseError)
local useCommercePurchaseErrorProps = require(script.Parent.useCommercePurchaseErrorProps)

local function CommercePurchaseErrorContainer() -- line: 8
	-- upvalues: useCommercePurchaseErrorProps (copy), React (copy), CommercePurchaseError (copy)
	local v6 = useCommercePurchaseErrorProps()

	return React.createElement(CommercePurchaseError, v6)
end

return CommercePurchaseErrorContainer
