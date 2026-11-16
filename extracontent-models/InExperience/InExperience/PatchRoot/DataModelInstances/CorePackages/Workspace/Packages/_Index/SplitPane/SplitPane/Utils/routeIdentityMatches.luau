local parent = script:FindFirstAncestor("SplitPane").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local function getProfileType(p) -- 2 equivalent calls inferred from this helper
	local extraProps

	if p ~= nil then
		extraProps = p.extraProps
	end

	local profileType

	if extraProps ~= nil then
		profileType = extraProps.profileType
	end

	return if profileType == nil then "User" else profileType
end

local function routeIdentityMatches(p, p2: string, p3): boolean
	if p.routeName ~= p2 then
		return false
	end

	local params = p.params
	local detail

	if p3 ~= nil then
		detail = p3.detail
	end

	local v

	if params ~= nil then
		v = params.detail
	end

	if tostring(detail) ~= tostring(v) then
		return false
	end

	if p2 == AppPage.ProfilePlatform and getProfileType(p3) ~= getProfileType(params) then -- inferred equivalent call
		return false
	end

	return true
end

return routeIdentityMatches
