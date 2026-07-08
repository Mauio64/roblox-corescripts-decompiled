local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local AuthPlatformDisconnect = require(AuthCommon.Http.Requests.AuthPlatformDisconnect)
local v5 = game:DefineFastFlag("EnableConsoleDisconnectNetworkingErrorToast", false)
local SetNetworkingErrorToast = require(AuthCommonParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast

local function ConsoleDisconnect(p1, p2, p3) -- line: 12
	-- upvalues: AuthPlatformDisconnect (copy), Promise (copy), v5 (copy), SetNetworkingErrorToast (copy)
	return function(p4) -- line: 13
		-- upvalues: AuthPlatformDisconnect (copy), p1 (copy), p3 (copy), p2 (copy), Promise (copy), v5 (copy), SetNetworkingErrorToast (copy)
		return AuthPlatformDisconnect(p1):andThen(function() -- line: 14
			-- upvalues: p4 (copy), p3 (copy), p1 (copy), p2 (copy), Promise (copy)
			p4:dispatch(p3(p1, p2))

			return Promise.resolve()
		end, function(p5) -- line: 19
			-- upvalues: v5 (copy), p4 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			if v5 then
				p4:dispatch(SetNetworkingErrorToast(p5))
			end

			return Promise.reject(p5)
		end)
	end
end

return ConsoleDisconnect
