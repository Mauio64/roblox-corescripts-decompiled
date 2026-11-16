local HttpService = game:GetService("HttpService")

local function makeHttpServiceMock(statusCode: number, options)
	local httpServiceMock = { lastRequestParams = nil, lastEncodedBody = nil }

	function httpServiceMock:RequestInternal(lastRequestParams)
		self.lastRequestParams = lastRequestParams
		return {
			Start = function(_, callback)
				task.defer(function()
					callback(true, {
						Body = HttpService:JSONEncode(options or {}),
						StatusCode = statusCode
					})
				end)
			end
		}
	end

	function httpServiceMock:JSONEncode(lastEncodedBody)
		self.lastEncodedBody = lastEncodedBody
		return HttpService:JSONEncode(lastEncodedBody)
	end

	function httpServiceMock:JSONDecode(json)
		return HttpService:JSONDecode(json)
	end

	return httpServiceMock
end

return makeHttpServiceMock
