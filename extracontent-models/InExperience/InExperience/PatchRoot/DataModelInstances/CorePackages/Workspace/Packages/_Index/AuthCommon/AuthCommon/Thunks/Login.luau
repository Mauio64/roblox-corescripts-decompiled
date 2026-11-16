local AuthCommon = script:FindFirstAncestor("AuthCommon")

local LoginByEmail = require(AuthCommon.Thunks.LoginByEmail)
local LoginByPhone = require(AuthCommon.Thunks.LoginByPhone)
local LoginByUsername = require(AuthCommon.Thunks.LoginByUsername)

local isStringEmail = require(AuthCommon.Utils.isStringEmail)
local isStringPhone = require(AuthCommon.Utils.isStringPhone)

local AppCommonLib = require(AuthCommon.Parent.AppCommonLib)
local tenFootInterface = AppCommonLib.isTenFootInterface()

return function(p, p2, p3, p4, p5, p6, p7, p8, p9)
	return function(object)
		if isStringEmail(p2) and not (p9 or tenFootInterface) then
			return object:dispatch(LoginByEmail(p, p2, p3, p4, p5, p6, p7, p8))
		end

		if isStringPhone(p2) and not (p9 or tenFootInterface) then
			return object:dispatch(LoginByPhone(p, p2, p3, p4, p5, p6, p7, p8))
		end

		return object:dispatch(LoginByUsername(p, p2, p3, p4, p5, p6, p7))
	end
end
