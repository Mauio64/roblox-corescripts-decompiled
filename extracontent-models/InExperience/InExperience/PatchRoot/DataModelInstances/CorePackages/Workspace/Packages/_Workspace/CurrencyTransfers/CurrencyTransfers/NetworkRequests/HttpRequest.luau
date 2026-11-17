local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local HttpService = game:GetService("HttpService")
local Promise = require(parent.Promise)
local ErrorTransferModel = require(CurrencyTransfers.Models.ErrorTransferModel)

local HttpRequest = {}
HttpRequest.__index = HttpRequest

function HttpRequest.new(p)
	local self = setmetatable({}, HttpRequest)
	self.http = p or game:GetService("HttpService")
	self.networkImpl = nil
	return self
end

function HttpRequest.fromNetworkImpl(networkImpl)
	local self = setmetatable({}, HttpRequest)
	self.http = nil
	self.networkImpl = networkImpl
	return self
end

local function rejectFromNetworkImpl(callback, p)
	local statusCode = p and p.StatusCode or 0
	local body = p and p.Body
	local v = nil

	if type(body) == "table" then
		v = body
	elseif type(body) == "string" and body ~= "" then
		local success, result = pcall(HttpService.JSONDecode, HttpService, body)

		if success then
			v = result
		end
	end

	if v then
		callback(ErrorTransferModel.format(v))
	else
		callback({ status = statusCode, body = body })
	end
end

function HttpRequest.get(p, url)
	if p.networkImpl then
		return Promise.new(function(callback, p2)
			p.networkImpl(url, "GET", {
				headers = { Accept = "application/json" }
			}):andThen(function(p3)
				callback(p3.responseBody)
			end, function(p3)
				rejectFromNetworkImpl(p2, p3)
			end)
		end)
	end

	return Promise.new(function(callback, callback2)
		p.http:RequestInternal({
			Url = url,
			Method = "GET",
			Headers = { Accept = "application/json" }
		}):Start(function(_, p2)
			if p2.StatusCode == 200 then
				callback(p.http:JSONDecode(p2.Body))
				return
			end

			if p2.StatusCode ~= 400 and p2.StatusCode ~= 403 then
				callback2({ status = p2.StatusCode, body = p2.Body })

				return
			end

			local v

			if p2.Body and p2.Body ~= "" then
				v = p.http:JSONDecode(p2.Body)
			end

			if not v then
				callback2({ status = p2.StatusCode, body = p2.Body })
				return
			end

			callback2((ErrorTransferModel.format(v)))
		end)
	end)
end

function HttpRequest.post(p, url, p2)
	if p.networkImpl then
		return Promise.new(function(callback, p3)
			p.networkImpl(url, "POST", {
				headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
				postBody = HttpService:JSONEncode(p2)
			}):andThen(function(p4)
				callback(p4.responseBody)
			end, function(p4)
				rejectFromNetworkImpl(p3, p4)
			end)
		end)
	end

	return Promise.new(function(callback, callback2)
		p.http:RequestInternal({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
			Body = p.http:JSONEncode(p2)
		}):Start(function(_, p3)
			if p3.StatusCode == 200 then
				callback(p.http:JSONDecode(p3.Body))
				return
			end

			if p3.StatusCode ~= 400 and p3.StatusCode ~= 403 then
				callback2({ status = p3.StatusCode, body = p3.Body })

				return
			end

			local v

			if p3.Body and p3.Body ~= "" then
				v = p.http:JSONDecode(p3.Body)
			end

			if not v then
				callback2({ status = p3.StatusCode, body = p3.Body })
				return
			end

			callback2((ErrorTransferModel.format(v)))
		end)
	end)
end

return HttpRequest
