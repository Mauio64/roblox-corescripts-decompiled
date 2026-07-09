local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants

local function mapContentTypeToTreatmentType(p1) -- line: 7
	-- upvalues: OmniFeedConstants (copy), OmniFeedTypes (copy)
	local UserSearchGrid = nil

	if p1 == OmniFeedConstants.ContentGroupType.Game then
		return OmniFeedTypes.SearchGameGrid
	end

	if p1 == OmniFeedConstants.ContentGroupType.Text then
		return OmniFeedTypes.SearchText
	end

	if p1 == OmniFeedConstants.ContentGroupType.User then
		UserSearchGrid = OmniFeedTypes.UserSearchGrid
	end

	return UserSearchGrid
end

return mapContentTypeToTreatmentType
