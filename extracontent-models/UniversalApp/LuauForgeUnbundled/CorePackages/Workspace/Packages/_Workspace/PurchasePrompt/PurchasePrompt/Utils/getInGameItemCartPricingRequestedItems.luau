require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function getInGameItemCartPricingRequestedItems(p2)
	if type(p2) ~= "table" then
		return nil
	end

	local namespace = p2.namespace
	local targetIdentifier = p2.targetIdentifier

	if type(namespace) ~= "string" or namespace == "" then
		return nil
	end

	if type(targetIdentifier) == "string" and targetIdentifier ~= "" then
		return {
			{
				productIdentifier = {
					namespace = namespace,
					targetIdentifier = targetIdentifier
				}
			}
		}
	end

	return nil
end

return getInGameItemCartPricingRequestedItems
