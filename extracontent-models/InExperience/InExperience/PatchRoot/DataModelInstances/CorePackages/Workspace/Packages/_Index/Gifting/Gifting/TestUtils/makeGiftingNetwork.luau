local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("Gifting").Parent

local HttpClient = require(parent.HttpClient)

local function makeGiftingNetwork(options)
	local v = options or {}
	local lastRequest = nil
	local count = 0

	return {
		network = HttpClient.createMockNetwork({
			fallback = function(p)
				lastRequest = p
				count += 1

				if v.statusCode == nil then
					return v.responseBody or {}
				end

				return {
					statusCode = v.statusCode,
					responseBody = HttpService:JSONEncode(v.responseBody or {})
				}
			end
		}),
		getLastRequest = function()
			return lastRequest
		end,
		getLastBody = function()
			local v2 = lastRequest

			if v2 == nil or v2.body == nil then
				return nil
			end

			return HttpService:JSONDecode(v2.body)
		end,
		getRequestCount = function()
			return count
		end
	}
end

return makeGiftingNetwork
