local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")

local AuthPlatformDisconnect = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/AuthPlatformDisconnect")

local defineFastFlag = game:DefineFastFlag("EnableConsoleDisconnectNetworkingErrorToast", false)
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast

local function ConsoleDisconnect(p2, p3, callback)
	return function(object)
		return AuthPlatformDisconnect(p2):andThen(function()
			object:dispatch(callback(p2, p3))
			return Promise.resolve()
		end, function(p4)
			if defineFastFlag then
				object:dispatch(setNetworkingErrorToast(p4))
			end

			return Promise.reject(p4)
		end)
	end
end

return ConsoleDisconnect
