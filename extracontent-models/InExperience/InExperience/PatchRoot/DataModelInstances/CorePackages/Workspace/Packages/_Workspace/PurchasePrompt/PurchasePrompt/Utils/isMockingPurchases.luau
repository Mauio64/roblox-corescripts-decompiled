local parent = script.Parent.Parent
local RunService = game:GetService("RunService")

local RequestType = require(parent.Enums.RequestType)

local function isMockingPurchases(p)
	return RunService:IsStudio() and p ~= RequestType.AvatarCreationFee
end

return isMockingPurchases
