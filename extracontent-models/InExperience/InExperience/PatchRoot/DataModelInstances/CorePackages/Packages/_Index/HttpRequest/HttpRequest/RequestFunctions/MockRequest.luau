local parent = script:FindFirstAncestor("HttpRequest").Parent
local Cryo = require(parent.Cryo)

return function(url, method, data)
	return {
		Start = function(_, callback)
			local v = {}

			if type(data.mockResponse) == "function" then
				v = data.mockResponse()
			elseif data.mockResponse then
				v = data.mockResponse
			end

			local joined = Cryo.Dictionary.join({ Url = url, Method = method }, v)

			callback(data.success, joined)
		end,
		Cancel = function()
			if data.cancel then
				data.cancel()
			end
		end
	}
end
