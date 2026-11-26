local MessageBusService = game:GetService("MessageBusService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Promise")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Cryo")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/AppCommonLib").Logging

require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/RequestTypes")
local FFlagEnableStrictConsoleAuthCredentialHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Flags/FFlagEnableStrictConsoleAuthCredentialHeaders")

return function(callback, p2, p3, p4, p5)
	return Promise.new(function(p6, callback2)
		MessageBusService:MakeRequest(
			"CredentialsProtocol",
			"getHeaders",
			{ ["url"] = p2, method = p3 },
			function(p7)
				if not (p7 and p7.success) then
					logging.warn("credential headers error")

					callback2({})

					if FFlagEnableStrictConsoleAuthCredentialHeaders and p5 then
						return
					end
				end

				p4.headers = Cryo.Dictionary.join(p4.headers or {}, p7.headers or {})
				return callback(p2, p3, p4):andThen(p6):catch(callback2)
			end,
			{}
		)
	end)
end
