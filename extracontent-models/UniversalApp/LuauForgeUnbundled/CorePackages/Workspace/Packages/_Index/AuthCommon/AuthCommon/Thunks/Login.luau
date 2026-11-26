local LoginByEmail = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/LoginByEmail")
local LoginByPhone = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/LoginByPhone")
local LoginByUsername = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/LoginByUsername")

local isStringEmail = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/isStringEmail")
local isStringPhone = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/isStringPhone")

local tenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").isTenFootInterface()

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	return function(object)
		if isStringEmail(p3) and not (p10 or tenFootInterface) then
			return object:dispatch(LoginByEmail(p2, p3, p4, p5, p6, p7, p8, p9))
		end

		if isStringPhone(p3) and not (p10 or tenFootInterface) then
			return object:dispatch(LoginByPhone(p2, p3, p4, p5, p6, p7, p8, p9))
		end

		return object:dispatch(LoginByUsername(p2, p3, p4, p5, p6, p7, p8))
	end
end
