local HttpService = game:GetService("HttpService")

local function makeHttpServiceMock(n1: number, p1) -- line: 3
	-- upvalues: HttpService (copy)
	return {
		lastRequestParams = nil,
		lastEncodedBody = nil,
		RequestInternal = function(p2, p3) -- line: 9
			-- upvalues: HttpService (copy), p1 (copy), n1 (copy)
			p2.lastRequestParams = p3

			return {
				Start = function(_, p5) -- line: 12
					-- upvalues: HttpService (copy), p1 (copy), n1 (copy)
					task.defer(function() -- line: 13
						-- upvalues: HttpService (copy), p1 (copy), n1 (copy), p5 (copy)
						local t1 = {
							Body = HttpService:JSONEncode(p1 or {}),
							StatusCode = n1
						}

						p5(true, t1)
					end)
				end
			}
		end,
		JSONEncode = function(p6, p7) -- line: 24
			-- upvalues: HttpService (copy)
			p6.lastEncodedBody = p7

			return HttpService:JSONEncode(p7)
		end,
		JSONDecode = function(_, p9) -- line: 29
			-- upvalues: HttpService (copy)
			return HttpService:JSONDecode(p9)
		end
	}
end

return makeHttpServiceMock
