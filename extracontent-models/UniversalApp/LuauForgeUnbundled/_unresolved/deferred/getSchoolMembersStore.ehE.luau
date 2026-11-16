local module = require("@luauforge/deferred/ehF")

local schoolMembersStore = nil

local function getSchoolMembersStore()
	if not schoolMembersStore then
		schoolMembersStore = module()
	end

	return schoolMembersStore
end

return getSchoolMembersStore
