local HttpService = game:GetService("HttpService")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Promise")
local ErrorTransferModel = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ErrorTransferModel")

local class = {}
class.__index = class

function class.new(p2)
	local object = setmetatable({}, class)
	object.http = p2 or game:GetService("HttpService")
	object.networkImpl = nil
	return object
end

function class.fromNetworkImpl(networkImpl)
	local object = setmetatable({}, class)
	object.http = nil
	object.networkImpl = networkImpl
	return object
end

local function rejectFromNetworkImpl(callback, p2)
	local statusCode = p2 and p2.StatusCode or 0
	local body = p2 and p2.Body
	local v5 = nil

	if type(body) == "table" then
		v5 = body
	elseif type(body) == "string" and body ~= "" then
		local success, result = pcall(HttpService.JSONDecode, HttpService, body)

		if success then
			v5 = result
		end
	end

	if v5 then
		callback(ErrorTransferModel.format(v5))
	else
		callback({ status = statusCode, body = body })
	end
end

function class.get(p2, p3)
	if p2.networkImpl then
		return Promise.new(function(callback, p4)
			p2.networkImpl(p3, "GET", {
				headers = { Accept = "application/json" }
			}):andThen(function(p5)
				callback(p5.responseBody)
			end, function(p5)
				rejectFromNetworkImpl(p4, p5)
			end)
		end)
	end

	return Promise.new(function(callback, callback2)
		p2.http:RequestInternal({
			Url = p3,
			Method = "GET",
			Headers = { Accept = "application/json" }
		}):Start(function(p4, p5)
			if p5.StatusCode == 200 then
				callback(p2.http:JSONDecode(p5.Body))
				return
			end

			if p5.StatusCode ~= 400 and p5.StatusCode ~= 403 then
				callback2({ status = p5.StatusCode, body = p5.Body })

				return
			end

			local v5 = if p5.Body and p5.Body ~= "" then p2.http:JSONDecode(p5.Body) else nil

			if not v5 then
				callback2({ status = p5.StatusCode, body = p5.Body })
				return
			end

			callback2((ErrorTransferModel.format(v5)))
		end)
	end)
end

function class:post(p3, p4)
	if self.networkImpl then
		return Promise.new(function(callback, p5)
			self.networkImpl(p3, "POST", {
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				},
				postBody = HttpService:JSONEncode(p4)
			}):andThen(function(p6)
				callback(p6.responseBody)
			end, function(p6)
				rejectFromNetworkImpl(p5, p6)
			end)
		end)
	end

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
				return
			end

			if p6.StatusCode ~= 400 and p6.StatusCode ~= 403 then
				callback2({ status = p6.StatusCode, body = p6.Body })

				return
			end

			local v5 = if p6.Body and p6.Body ~= "" then self.http:JSONDecode(p6.Body) else nil

			if not v5 then
				callback2({ status = p6.StatusCode, body = p6.Body })
				return
			end

			callback2((ErrorTransferModel.format(v5)))
		end)
	end)
end

return class
