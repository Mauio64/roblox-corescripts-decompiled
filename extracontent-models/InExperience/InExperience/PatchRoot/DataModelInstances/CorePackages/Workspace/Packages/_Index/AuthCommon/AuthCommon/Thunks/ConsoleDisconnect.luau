local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)

local AuthPlatformDisconnect = require(AuthCommon.Http.Requests.AuthPlatformDisconnect)

local defineFastFlag = game:DefineFastFlag("EnableConsoleDisconnectNetworkingErrorToast", false)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast

local function ConsoleDisconnect(p, p2, callback)
	return function(object)
		return AuthPlatformDisconnect(p):andThen(function()
			object:dispatch(callback(p, p2))
			return Promise.resolve()
		end, function(p3)
			if defineFastFlag then
				object:dispatch(SetNetworkingErrorToast(p3))
			end

			return Promise.reject(p3)
		end)
	end
end

return ConsoleDisconnect
