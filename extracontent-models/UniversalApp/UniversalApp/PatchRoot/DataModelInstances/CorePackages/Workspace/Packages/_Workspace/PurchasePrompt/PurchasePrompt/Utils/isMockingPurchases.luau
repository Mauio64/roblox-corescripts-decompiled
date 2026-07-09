local ParentParent = script.Parent.Parent
local RunService = game:GetService("RunService")
local RequestType = require(ParentParent.Enums.RequestType)

local function isMockingPurchases(p1) -- line: 11
	-- upvalues: RunService (copy), RequestType (copy)
	return RunService:IsStudio() and p1 ~= RequestType.AvatarCreationFee
end

return isMockingPurchases
