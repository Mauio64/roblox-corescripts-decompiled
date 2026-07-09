local AuthCommon = script:FindFirstAncestor("AuthCommon")
local LoginByEmail = require(AuthCommon.Thunks.LoginByEmail)
local LoginByPhone = require(AuthCommon.Thunks.LoginByPhone)
local LoginByUsername = require(AuthCommon.Thunks.LoginByUsername)
local isStringEmail = require(AuthCommon.Utils.isStringEmail)
local isStringPhone = require(AuthCommon.Utils.isStringPhone)
local v7 = game:GetService("GuiService"):IsTenFootInterface()

return function(p1, p2, p3, p4, p5, p6, p7, p8, p9) -- line: 14
	-- upvalues: isStringEmail (copy), v7 (copy), LoginByEmail (copy), isStringPhone (copy), LoginByPhone (copy), LoginByUsername (copy)
	return function(p10) -- line: 25
		-- upvalues: isStringEmail (copy), p2 (copy), p9 (copy), v7 (copy), LoginByEmail (copy), p1 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), p7 (copy), p8 (copy), isStringPhone (copy), LoginByPhone (copy), LoginByUsername (copy)
		if isStringEmail(p2) and (not p9 and not v7) then
			return p10:dispatch(LoginByEmail(p1, p2, p3, p4, p5, p6, p7, p8))
		end

		if isStringPhone(p2) and not p9 and not v7 then
			return p10:dispatch(LoginByPhone(p1, p2, p3, p4, p5, p6, p7, p8))
		end

		return p10:dispatch(LoginByUsername(p1, p2, p3, p4, p5, p6, p7))
	end
end
