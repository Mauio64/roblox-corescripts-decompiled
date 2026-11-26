local module = require("@luauforge/deferred/ekZ")

local schoolMembersStore = nil

local function getSchoolMembersStore()
	if not schoolMembersStore then
		schoolMembersStore = module()
	end

	return schoolMembersStore
end

return getSchoolMembersStore
