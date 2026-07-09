local LuaApp = game:GetService("CoreGui").RobloxGui.Modules.LuaApp
local SetUserAccessRestrictionDetail = require(LuaApp.Actions.UserAccess.SetUserAccessRestrictionDetail)

return function(t1: {[any]: any}, p1) -- line: 12
	-- upvalues: SetUserAccessRestrictionDetail (copy)
	local v5 = t1 or {}

	if p1.type == SetUserAccessRestrictionDetail.name then
		v5 = {
			restrictionDetail = p1.restrictionDetail
		}
	end

	return v5
end
