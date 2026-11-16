local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local function viewerOwnsOpenCommunity(p2, p3): boolean
	local components = p2.components

	if components == nil then
		return false
	end

	local component = components[Enums.Components.CommunityProfileHeader]
	local ownerUserId = if type(component) == "table" then component.ownerUserId else nil

	if type(ownerUserId) ~= "number" or tostring(ownerUserId) ~= p3 then
		return false
	end

	return components[Enums.Components.CommunityLocked] == nil
		and components[Enums.Components.CommunityDeactivated] == nil
end

return viewerOwnsOpenCommunity
