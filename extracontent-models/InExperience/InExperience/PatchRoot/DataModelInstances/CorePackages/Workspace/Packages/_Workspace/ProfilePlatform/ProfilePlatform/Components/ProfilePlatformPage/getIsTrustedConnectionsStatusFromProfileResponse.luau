local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Enums = require(ProfilePlatform.Common.Enums)
local viewerRelationshipUtils = require(script.Parent.viewerRelationshipUtils)
local FFlagProfilePlatformUseViewerRelationshipForSocialState = require(ProfilePlatform.Flags.FFlagProfilePlatformUseViewerRelationshipForSocialState)

local function getIsTrustedConnectionsStatusFromProfileResponse(p1) -- line: 11
	-- upvalues: FFlagProfilePlatformUseViewerRelationshipForSocialState (copy), viewerRelationshipUtils (copy), getDeepValue (copy), Enums (copy)
	if FFlagProfilePlatformUseViewerRelationshipForSocialState then
		local v8 = viewerRelationshipUtils.getViewerRelationshipFromProfileResponse(p1)

		if v8 then
			return viewerRelationshipUtils.isViewerTrustedFriendsFromViewerRelationship(v8)
		end

		return false
	end

	local v9 = getDeepValue(p1, `responseBody.components.{ Enums.Components.Actions }.contextual`)

	return v9 ~= nil and table.find(v9, Enums.ProfileActions.RemoveTrustedConnection) ~= nil
end

return getIsTrustedConnectionsStatusFromProfileResponse
