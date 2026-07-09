local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local function toLowerKeyedHeaders(p1) -- line: 13
	if typeof(p1) ~= "table" then
		return nil
	end

	local t1 = {}

	for v6, v7 in p1 do
		t1[tostring(v6):lower()] = tostring(v7)
	end

	return t1
end
local function createRequestInternalNetwork() -- line: 24
	-- upvalues: HttpService (copy), toLowerKeyedHeaders (copy)
	return {
		request = function(p2, p3: ((...any) -> ...any)) -- line: 25
			-- upvalues: HttpService (copy), toLowerKeyedHeaders (copy)
			local v10 = HttpService:RequestInternal({
				Url = p2.url,
				Method = p2.method,
				Headers = p2.headers,
				Body = p2.body,
				OnMessage = p2.onMessage
			})
			local u11 = false

			v10:Start(function(b1: boolean, p4) -- line: 42
				-- upvalues: u11 (ref), p3 (copy), toLowerKeyedHeaders (copy)
				if u11 then
					return
				end

				u11 = true

				if b1 and typeof(p4) == "table" then
					local t2 = nil

					if typeof(p4.Stats) == "table" then
						t2 = {}

						for v15, v16 in p4.Stats do
							if typeof(v15) == "string" and typeof(v16) == "number" then
								t2[v15] = v16
							elseif v15 == "WasRequestRetried" and typeof(v16) == "boolean" then
								t2[v15] = not v16 and 0 or 1
							end
						end
					end

					p3(true, {
						statusCode = tonumber(p4.StatusCode) or 0,
						responseBody = p4.Body,
						headers = toLowerKeyedHeaders(p4.Headers),
						httpError = p4.HttpError,
						stats = t2
					})

					return
				end

				p3(false, (tostring(p4 and p4.StatusMessage or "RequestInternal failed")))
			end)

			return function() -- line: 72
				-- upvalues: u11 (ref), v10 (copy)
				if u11 then
					return
				end

				u11 = true
				pcall(function() -- line: 77
					-- upvalues: v10 (copy)
					v10:Cancel()
				end)
			end
		end
	}
end

return createRequestInternalNetwork
