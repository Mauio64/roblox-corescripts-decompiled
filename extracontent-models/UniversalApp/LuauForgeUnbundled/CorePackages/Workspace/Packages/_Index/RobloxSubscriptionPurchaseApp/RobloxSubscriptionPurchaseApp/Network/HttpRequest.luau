local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")

local class = {}
class.__index = class

function class.new(p2)
	local object = setmetatable({}, class)
	object.http = p2 or game:GetService("HttpService")
	return object
end

function class.get(p2, p3)
	return Promise.new(function(callback, callback2)
		p2.http:RequestInternal({
			Url = p3,
			Method = "GET",
			Headers = { Accept = "application/json" }
		}):Start(function(p4, p5)
			if p5.StatusCode == 200 then
				callback(p2.http:JSONDecode(p5.Body))
			else
				callback2({ status = p5.StatusCode, body = p5.Body })
			end
		end)
	end)
end

function class:post(p3, p4)
	return Promise.new(function(callback, callback2)
		self.http:RequestInternal({
			Url = p3,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = self.http:JSONEncode(p4)
		}):Start(function(p5, p6)
			if p6.StatusCode == 200 then
				callback(self.http:JSONDecode(p6.Body))
			else
				callback2({ status = p6.StatusCode, body = p6.Body })
			end
		end)
	end)
end

return class
