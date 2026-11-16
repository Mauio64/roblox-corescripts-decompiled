local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

local Enums = require(ProfilePlatform.Common.Enums)

local function viewerOwnsOpenCommunity(p, p2: string): boolean
	local components = p.components

	if components == nil then
		return false
	end

	local component = components[Enums.Components.CommunityProfileHeader]
	local ownerUserId

	if type(component) == "table" then
		ownerUserId = component.ownerUserId
	end

	if type(ownerUserId) ~= "number" or tostring(ownerUserId) ~= p2 then
		return false
	end

	return components[Enums.Components.CommunityLocked] == nil
		and components[Enums.Components.CommunityDeactivated] == nil
end

return viewerOwnsOpenCommunity
