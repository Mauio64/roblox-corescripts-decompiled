local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppSessionization").SessionType

local function setHomePageSessionInfo(object, p2, p3)
	if object == nil then
		return
	end

	object:SetSession(
		sessionType.StructuralIdentifier.Level1,
		sessionType.StructuralIdentifier.HomePageSessionInfo,
		sessionType.StructuralIdentifier.HomePageSessionInfo
	)

	if p2 then
		object:SetMetadata(
			sessionType.StructuralIdentifier.HomePageSessionInfo,
			sessionType.Metadata.HomePageSessionInfo.RequestId,
			p2
		)
	end

	if p3 then
		object:SetMetadata(
			sessionType.StructuralIdentifier.HomePageSessionInfo,
			sessionType.Metadata.HomePageSessionInfo.OmniSessionId,
			p3
		)
	end
end

return setHomePageSessionInfo
