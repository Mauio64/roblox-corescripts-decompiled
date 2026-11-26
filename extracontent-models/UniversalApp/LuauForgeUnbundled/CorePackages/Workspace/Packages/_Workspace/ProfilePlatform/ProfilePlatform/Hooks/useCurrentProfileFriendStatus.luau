local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local viewerRelationshipUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage/viewerRelationshipUtils")

local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")

return function()
	local v5 = useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}
	local viewerRelationship = v5.viewerRelationship
	local contextualInformation = v5.contextualInformation
	return viewerRelationshipUtils.mapViewerRelationshipAndContextToAnalyticsFriendStatus(
		viewerRelationship,
		contextualInformation
	)
end
