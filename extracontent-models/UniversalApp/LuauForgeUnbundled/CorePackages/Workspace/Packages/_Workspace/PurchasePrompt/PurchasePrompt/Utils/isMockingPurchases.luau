local RunService = game:GetService("RunService")

local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local function isMockingPurchases(p2)
	return RunService:IsStudio() and p2 ~= RequestType.AvatarCreationFee
end

return isMockingPurchases
