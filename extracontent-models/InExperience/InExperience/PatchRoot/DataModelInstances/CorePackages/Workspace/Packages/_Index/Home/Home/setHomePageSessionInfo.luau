local parent = script:FindFirstAncestor("Home").Parent

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType

local function setHomePageSessionInfo(object, p: string?, p2: string?)
	if object == nil then
		return
	end

	object:SetSession(
		SessionType.StructuralIdentifier.Level1,
		SessionType.StructuralIdentifier.HomePageSessionInfo,
		SessionType.StructuralIdentifier.HomePageSessionInfo
	)

	if p then
		object:SetMetadata(
			SessionType.StructuralIdentifier.HomePageSessionInfo,
			SessionType.Metadata.HomePageSessionInfo.RequestId,
			p
		)
	end

	if p2 then
		object:SetMetadata(
			SessionType.StructuralIdentifier.HomePageSessionInfo,
			SessionType.Metadata.HomePageSessionInfo.OmniSessionId,
			p2
		)
	end
end

return setHomePageSessionInfo
