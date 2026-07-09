local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local Promise = require(Parent.Promise)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 9
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.http = p1 or game:GetService("HttpService")

	return self
end
function t1.get(t2: {[any]: any}, s1: string) -- line: 15
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, reject) -- line: 16
		-- upvalues: t2 (copy), s1 (copy)
		t2.http:RequestInternal({
			Method = "GET",
			Url = s1,
			Headers = {
				Accept = "application/json"
			}
		}):Start(function(_, p3) -- line: 25
			-- upvalues: resolve (copy), t2 (copy), reject (copy)
			if p3.StatusCode == 200 then
				resolve(t2.http:JSONDecode(p3.Body))

				return
			end

			reject({
				status = p3.StatusCode,
				body = p3.Body
			})
		end)
	end)
end
function t1.post(t3: {[any]: any}, s2: string, t4: {[any]: any}) -- line: 38
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, reject) -- line: 39
		-- upvalues: t3 (copy), s2 (copy), t4 (copy)
		t3.http:RequestInternal({
			Method = "POST",
			Url = s2,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = t3.http:JSONEncode(t4)
		}):Start(function(_, p5) -- line: 50
			-- upvalues: resolve (copy), t3 (copy), reject (copy)
			if p5.StatusCode == 200 then
				resolve(t3.http:JSONDecode(p5.Body))

				return
			end

			reject({
				status = p5.StatusCode,
				body = p5.Body
			})
		end)
	end)
end

return t1
