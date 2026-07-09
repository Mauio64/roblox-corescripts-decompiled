local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CheckHttpErrorStatus = require(Modules.LuaApp.Thunks.CheckHttpErrorStatus)
local CheckChallengeHeaders = require(Modules.LuaApp.Thunks.AccountSecurity.CheckChallengeHeaders)
local GetFFlagLuaAppAttachChallengeInterceptor = require(Modules.LuaApp.Flags.GetFFlagLuaAppAttachChallengeInterceptor)
local v5 = game:DefineFastFlag("SilentlyFailIfChallenge", true)

local function wrapRequestWithChallengeMiddleware(p1, p2) -- line: 10
	-- upvalues: CheckChallengeHeaders (copy)
	local function makeRequest(p3, p4, p5) -- line: 11
		-- upvalues: p1 (copy), p2 (copy), CheckChallengeHeaders (copy)
		local v18, v19 = p1(p3, p4, p5)

		return v18:andThen(nil, function(p6) -- line: 14
			-- upvalues: p2 (copy), CheckChallengeHeaders (copy), p1 (copy), p3 (copy), p4 (copy), p5 (copy)
			return p2:dispatch(CheckChallengeHeaders(p1, p3, p4, p5, p6))
		end), v19
	end

	return makeRequest
end
local function wrapRequestWithMiddleware(p7, p8, p9) -- line: 22
	-- upvalues: v5 (copy), GetFFlagLuaAppAttachChallengeInterceptor (copy), CheckHttpErrorStatus (copy), CheckChallengeHeaders (copy)
	local function makeRequest(p10, p11, p12, p13) -- line: 23
		-- upvalues: p7 (copy), v5 (copy), GetFFlagLuaAppAttachChallengeInterceptor (copy), p8 (copy), CheckHttpErrorStatus (copy), CheckChallengeHeaders (copy), p9 (copy)
		local v24, v25 = p7(p10, p11, p12)

		if v5 and p13 then
			return v24, v25
		end

		return v24:andThen(nil, function(p14) -- line: 30
			-- upvalues: GetFFlagLuaAppAttachChallengeInterceptor (copy), p8 (copy), CheckHttpErrorStatus (copy), p7 (copy), CheckChallengeHeaders (copy), p10 (copy), p9 (copy)
			if GetFFlagLuaAppAttachChallengeInterceptor() then
				local v28 = p8
				local v29 = CheckHttpErrorStatus
				local v30 = p7
				local v31 = p8

				local function makeRequest2(p15, p16, p17) -- line: 11
					-- upvalues: v30 (copy), v31 (copy), CheckChallengeHeaders (copy)
					local v37, v38 = v30(p15, p16, p17)

					return v37:andThen(nil, function(p18) -- line: 14
						-- upvalues: v31 (copy), CheckChallengeHeaders (copy), v30 (copy), p15 (copy), p16 (copy), p17 (copy)
						return v31:dispatch(CheckChallengeHeaders(v30, p15, p16, p17, p18))
					end), v38
				end

				return v28:dispatch(v29(makeRequest2, p10, p14, p9))
			end

			return p8:dispatch(CheckHttpErrorStatus(p7, p10, p14, p9))
		end):andThen(nil, function(p19) -- line: 40
			-- upvalues: p8 (copy), CheckChallengeHeaders (copy), p7 (copy), p10 (copy), p11 (copy), p12 (copy)
			return p8:dispatch(CheckChallengeHeaders(p7, p10, p11, p12, p19))
		end), v25
	end

	return makeRequest
end

return wrapRequestWithMiddleware
