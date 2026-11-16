local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
require(PurchasePrompt.types)

local function getInGameItemCartPricingRequestedItems(p)
	if type(p) ~= "table" then
		return nil
	end

	local namespace = p.namespace
	local targetIdentifier = p.targetIdentifier

	if type(namespace) ~= "string" or namespace == "" then
		return nil
	end

	if type(targetIdentifier) == "string" and targetIdentifier ~= "" then
		return {
			{
				productIdentifier = { namespace = namespace, targetIdentifier = targetIdentifier }
			}
		}
	end

	return nil
end

return getInGameItemCartPricingRequestedItems
