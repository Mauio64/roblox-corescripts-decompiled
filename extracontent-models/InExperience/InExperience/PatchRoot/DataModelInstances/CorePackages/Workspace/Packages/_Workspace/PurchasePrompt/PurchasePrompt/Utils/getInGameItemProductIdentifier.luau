local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
require(PurchasePrompt.types)

local v = { [Enum.InfoType.GamePass] = "GamePass", [Enum.InfoType.Product] = "DeveloperProduct" }

local function getInGameItemProductIdentifier(p, p2)
	local namespace = v[p]

	if not (namespace ~= nil and p2 ~= nil) then
		return nil
	end

	local targetIdentifier = tostring(p2)

	if targetIdentifier == "" then
		return nil
	end

	return { namespace = namespace, targetIdentifier = targetIdentifier }
end

return getInGameItemProductIdentifier
