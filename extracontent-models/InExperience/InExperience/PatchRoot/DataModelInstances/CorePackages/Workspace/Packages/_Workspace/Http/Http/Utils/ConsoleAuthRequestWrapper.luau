local MessageBusService = game:GetService("MessageBusService")
local Http = script:FindFirstAncestor("Http")
local HttpParent = Http.Parent
local Promise = require(HttpParent.Promise)
local Cryo = require(HttpParent.Cryo)
local Logging = require(HttpParent.AppCommonLib).Logging

require(Http.RequestTypes)

return function(p1, s1: string, s2: string, p2) -- line: 16
	-- upvalues: Promise (copy), MessageBusService (copy), Logging (copy), Cryo (copy)
	return Promise.new(function(resolve, reject) -- line: 17
		-- upvalues: s1 (copy), s2 (copy), MessageBusService (copy), Logging (copy), p2 (copy), Cryo (copy), p1 (copy)
		local t1 = {
			url = s1,
			method = s2
		}

		MessageBusService:MakeRequest("CredentialsProtocol", "getHeaders", t1, function(t2: {[any]: any}) -- line: 22
			-- upvalues: Logging (copy), reject (copy), p2 (copy), Cryo (copy), p1 (copy), s1 (copy), s2 (copy), resolve (copy)
			if not t2 or not t2.success then
				Logging.warn("credential headers error")
				reject({})
			end

			p2.headers = Cryo.Dictionary.join(p2.headers or {}, t2.headers or {})

			return p1(s1, s2, p2):andThen(resolve):catch(reject)
		end, {})
	end)
end
