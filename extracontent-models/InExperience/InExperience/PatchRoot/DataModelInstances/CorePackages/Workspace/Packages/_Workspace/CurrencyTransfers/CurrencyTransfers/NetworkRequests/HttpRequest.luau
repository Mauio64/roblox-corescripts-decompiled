local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(CurrencyTransfersParent.Promise)
local ErrorTransferModel = require(CurrencyTransfers.Models.ErrorTransferModel)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 26
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.http = p1 or game:GetService("HttpService")
	self.networkImpl = nil

	return self
end
function t1.fromNetworkImpl(p2) -- line: 39
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.http = nil
	self.networkImpl = p2

	return self
end

local function rejectFromNetworkImpl(p3, p4) -- line: 50
	-- upvalues: HttpService (copy), ErrorTransferModel (copy)
	local v14 = p4 and p4.StatusCode or 0
	local v15 = p4 and p4.Body
	local v16 = nil

	if type(v15) == "table" then
		v16 = v15
	elseif type(v15) == "string" and v15 ~= "" then
		local ok, result = pcall(HttpService.JSONDecode, HttpService, v15)

		if ok then
			v16 = result
		end
	end

	if v16 then
		p3(ErrorTransferModel.format(v16))

		return
	end

	p3({
		status = v14,
		body = v15
	})
end

function t1.get(p5, p6) -- line: 79
	-- upvalues: Promise (copy), rejectFromNetworkImpl (copy), ErrorTransferModel (copy)
	if p5.networkImpl then
		return Promise.new(function(resolve, reject) -- line: 81
			-- upvalues: p5 (copy), p6 (copy), rejectFromNetworkImpl (copy)
			p5.networkImpl(p6, "GET", {
				headers = {
					Accept = "application/json"
				}
			}):andThen(function(p7) -- line: 87
				-- upvalues: resolve (copy)
				resolve(p7.responseBody)
			end, function(p8) -- line: 89
				-- upvalues: rejectFromNetworkImpl (copy), reject (copy)
				rejectFromNetworkImpl(reject, p8)
			end)
		end)
	end

	return Promise.new(function(resolve, reject) -- line: 95
		-- upvalues: p5 (copy), p6 (copy), ErrorTransferModel (copy)
		p5.http:RequestInternal({
			Method = "GET",
			Url = p6,
			Headers = {
				Accept = "application/json"
			}
		}):Start(function(_, p10) -- line: 104
			-- upvalues: resolve (copy), p5 (copy), ErrorTransferModel (copy), reject (copy)
			if p10.StatusCode == 200 then
				resolve(p5.http:JSONDecode(p10.Body))

				return
			end

			if p10.StatusCode == 400 or p10.StatusCode == 403 then
				local v36 = if not p10.Body or p10.Body == "" then nil else p5.http:JSONDecode(p10.Body)

				if v36 then
					local v37 = ErrorTransferModel.format(v36)

					reject(v37)

					return
				end

				reject({
					status = p10.StatusCode,
					body = p10.Body
				})

				return
			end

			reject({
				status = p10.StatusCode,
				body = p10.Body
			})
		end)
	end)
end
function t1.post(p11, p12, p13) -- line: 131
	-- upvalues: Promise (copy), HttpService (copy), rejectFromNetworkImpl (copy), ErrorTransferModel (copy)
	if p11.networkImpl then
		return Promise.new(function(resolve, reject) -- line: 133
			-- upvalues: p11 (copy), p12 (copy), HttpService (copy), p13 (copy), rejectFromNetworkImpl (copy)
			p11.networkImpl(p12, "POST", {
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				},
				postBody = HttpService:JSONEncode(p13)
			}):andThen(function(p14) -- line: 141
				-- upvalues: resolve (copy)
				resolve(p14.responseBody)
			end, function(p15) -- line: 143
				-- upvalues: rejectFromNetworkImpl (copy), reject (copy)
				rejectFromNetworkImpl(reject, p15)
			end)
		end)
	end

	return Promise.new(function(resolve, reject) -- line: 149
		-- upvalues: p11 (copy), p12 (copy), p13 (copy), ErrorTransferModel (copy)
		p11.http:RequestInternal({
			Method = "POST",
			Url = p12,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = p11.http:JSONEncode(p13)
		}):Start(function(_, p17) -- line: 160
			-- upvalues: resolve (copy), p11 (copy), ErrorTransferModel (copy), reject (copy)
			if p17.StatusCode == 200 then
				resolve(p11.http:JSONDecode(p17.Body))

				return
			end

			if p17.StatusCode == 400 or p17.StatusCode == 403 then
				local v42 = if not p17.Body or p17.Body == "" then nil else p11.http:JSONDecode(p17.Body)

				if v42 then
					local v43 = ErrorTransferModel.format(v42)

					reject(v43)

					return
				end

				reject({
					status = p17.StatusCode,
					body = p17.Body
				})

				return
			end

			reject({
				status = p17.StatusCode,
				body = p17.Body
			})
		end)
	end)
end

return t1
