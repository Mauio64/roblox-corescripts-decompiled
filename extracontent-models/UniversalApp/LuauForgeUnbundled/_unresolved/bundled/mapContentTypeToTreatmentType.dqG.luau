local module = require("@luauforge/bundled/dqn")
local omniFeedTypes = module.OmniFeedTypes
local omniFeedConstants = module.OmniFeedConstants

local function mapContentTypeToTreatmentType(p2)
	local userSearchGrid = nil

	if p2 == omniFeedConstants.ContentGroupType.Game then
		return omniFeedTypes.SearchGameGrid
	end

	if p2 == omniFeedConstants.ContentGroupType.Text then
		return omniFeedTypes.SearchText
	end

	if p2 == omniFeedConstants.ContentGroupType.User then
		userSearchGrid = omniFeedTypes.UserSearchGrid
	end

	return userSearchGrid
end

return mapContentTypeToTreatmentType
