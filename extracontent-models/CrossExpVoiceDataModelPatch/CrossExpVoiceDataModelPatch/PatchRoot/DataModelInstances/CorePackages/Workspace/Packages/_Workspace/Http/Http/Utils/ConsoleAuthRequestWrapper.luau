local MessageBusService = game:GetService("MessageBusService")

local Http = script:FindFirstAncestor("Http")
local parent = Http.Parent
local Promise = require(parent.Promise)
local Cryo = require(parent.Cryo)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

require(Http.RequestTypes)
local FFlagEnableStrictConsoleAuthCredentialHeaders = require(Http.Flags.FFlagEnableStrictConsoleAuthCredentialHeaders)

return function(callback, url: string, method: string, p, flag: boolean?)
	return Promise.new(function(p2, callback2)
		MessageBusService:MakeRequest(
			"CredentialsProtocol",
			"getHeaders",
			{ ["url"] = url, method = method },
			function(p3)
				if not (p3 and p3.success) then
					Logging.warn("credential headers error")

					callback2({})

					if FFlagEnableStrictConsoleAuthCredentialHeaders and flag then
						return
					end
				end

				p.headers = Cryo.Dictionary.join(p.headers or {}, p3.headers or {})
				return callback(url, method, p):andThen(p2):catch(callback2)
			end,
			{}
		)
	end)
end
