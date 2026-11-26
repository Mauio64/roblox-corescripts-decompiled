require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local v5 = {
	[Enum.InfoType.GamePass] = "GamePass",
	[Enum.InfoType.Product] = "DeveloperProduct"
}

local function getInGameItemProductIdentifier(p2, p3)
	local v6 = v5[p2]

	if not (v6 ~= nil and p3 ~= nil) then
		return nil
	end

	local v7 = tostring(p3)

	if v7 == "" then
		return nil
	end

	return { namespace = v6, targetIdentifier = v7 }
end

return getInGameItemProductIdentifier
