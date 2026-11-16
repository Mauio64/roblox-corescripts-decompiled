local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local Promise = require(parent.Promise)

local HttpRequest = {}
HttpRequest.__index = HttpRequest

function HttpRequest.new(p)
	local self = setmetatable({}, HttpRequest)
	self.http = p or game:GetService("HttpService")
	return self
end

function HttpRequest.get(p, url: string)
	return Promise.new(function(callback, callback2)
		p.http:RequestInternal({
			Url = url,
			Method = "GET",
			Headers = { Accept = "application/json" }
		}):Start(function(_, p2)
			if p2.StatusCode == 200 then
				callback(p.http:JSONDecode(p2.Body))
			else
				callback2({ status = p2.StatusCode, body = p2.Body })
			end
		end)
	end)
end

function HttpRequest.post(p, url: string, p2)
	return Promise.new(function(callback, callback2)
		p.http:RequestInternal({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
			Body = p.http:JSONEncode(p2)
		}):Start(function(_, p3)
			if p3.StatusCode == 200 then
				callback(p.http:JSONDecode(p3.Body))
			else
				callback2({ status = p3.StatusCode, body = p3.Body })
			end
		end)
	end)
end

return HttpRequest
