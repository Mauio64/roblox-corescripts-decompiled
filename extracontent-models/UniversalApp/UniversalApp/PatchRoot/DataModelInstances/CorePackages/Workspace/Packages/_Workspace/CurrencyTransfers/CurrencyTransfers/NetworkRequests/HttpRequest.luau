local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local Promise = require(CurrencyTransfersParent.Promise)
local ErrorTransferModel = require(CurrencyTransfers.Models.ErrorTransferModel)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 10
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.http = p1 or game:GetService("HttpService")

	return self
end
function t1.get(p2, p3) -- line: 16
	-- upvalues: Promise (copy), ErrorTransferModel (copy)
	return Promise.new(function(resolve, reject) -- line: 17
		-- upvalues: p2 (copy), p3 (copy), ErrorTransferModel (copy)
		p2.http:RequestInternal({
			Method = "GET",
			Url = p3,
			Headers = {
				Accept = "application/json"
			}
		}):Start(function(_, p5) -- line: 26
			-- upvalues: resolve (copy), p2 (copy), ErrorTransferModel (copy), reject (copy)
			if p5.StatusCode == 200 then
				resolve(p2.http:JSONDecode(p5.Body))

				return
			end

			if p5.StatusCode == 400 or p5.StatusCode == 403 then
				local v19 = if not p5.Body or p5.Body == "" then nil else p2.http:JSONDecode(p5.Body)

				if v19 then
					local v20 = ErrorTransferModel.format(v19)

					reject(v20)

					return
				end

				reject({
					status = p5.StatusCode,
					body = p5.Body
				})

				return
			end

			reject({
				status = p5.StatusCode,
				body = p5.Body
			})
		end)
	end)
end
function t1.post(p6, p7, p8) -- line: 53
	-- upvalues: Promise (copy), ErrorTransferModel (copy)
	return Promise.new(function(resolve, reject) -- line: 54
		-- upvalues: p6 (copy), p7 (copy), p8 (copy), ErrorTransferModel (copy)
		p6.http:RequestInternal({
			Method = "POST",
			Url = p7,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			},
			Body = p6.http:JSONEncode(p8)
		}):Start(function(_, p10) -- line: 65
			-- upvalues: resolve (copy), p6 (copy), ErrorTransferModel (copy), reject (copy)
			if p10.StatusCode == 200 then
				resolve(p6.http:JSONDecode(p10.Body))

				return
			end

			if p10.StatusCode == 400 or p10.StatusCode == 403 then
				local v23 = if not p10.Body or p10.Body == "" then nil else p6.http:JSONDecode(p10.Body)

				if v23 then
					local v24 = ErrorTransferModel.format(v23)

					reject(v24)

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

return t1
