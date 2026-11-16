local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppEnums").AppPage

local function getProfileType(p2)
	local extraProps = if p2 ~= nil then p2.extraProps else nil
	local profileType = if extraProps ~= nil then extraProps.profileType else nil

	if profileType == nil then
		return "User"
	end

	return profileType
end

local function routeIdentityMatches(p2, p3, p4): boolean
	if p2.routeName ~= p3 then
		return false
	end

	local params = p2.params
	local detail = if p4 ~= nil then p4.detail else nil
	local v5 = if params ~= nil then params.detail else nil

	if tostring(detail) ~= tostring(v5) then
		return false
	end

	if p3 ~= appPage.ProfilePlatform then
		return true
	end

	local extraProps = if p4 ~= nil then p4.extraProps else nil
	local profileType = if extraProps ~= nil then extraProps.profileType else nil
	local v6 = profileType == nil and "User" or profileType
	local extraProps2 = if params ~= nil then params.extraProps else nil
	local profileType2 = if extraProps2 ~= nil then extraProps2.profileType else nil

	if v6 ~= (profileType2 == nil and "User" or profileType2) then
		return false
	end

	return true
end

return routeIdentityMatches
