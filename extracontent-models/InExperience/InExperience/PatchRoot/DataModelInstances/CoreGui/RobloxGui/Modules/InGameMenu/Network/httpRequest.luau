local HttpService = game:GetService("HttpService")
local Promise = require(script.Parent.Parent.Utility.Promise)
local Extreme = Enum.ThrottlingPriority.Extreme
local ApplicationJson = Enum.HttpContentType.ApplicationJson

return function(p1) -- line: 9
	-- upvalues: ApplicationJson (copy), Extreme (copy), Promise (copy), HttpService (copy)
	local function doHttpPost(p2, p3) -- line: 11
		-- upvalues: ApplicationJson (copy), Extreme (copy), p1 (copy)
		assert(p3.postBody, "Expected a postBody to be specified with this request")
		assert(type(p3.postBody) == "string", "Expected postBody to be a string")

		if not p3.contentType then
			p3.contentType = ApplicationJson
		end

		if not p3.throttlingPriority then
			p3.throttlingPriority = Extreme
		end

		return function() -- line: 23
			-- upvalues: p1 (copy), p2 (copy), p3 (copy)
			return p1:PostAsyncFullUrl(p2, p3.postBody, p3.throttlingPriority, p3.contentType)
		end
	end
	local function doHttpGet(p4) -- line: 33
		-- upvalues: p1 (copy), Extreme (copy)
		return function() -- line: 34
			-- upvalues: p1 (copy), p4 (copy), Extreme (copy)
			return p1:GetAsyncFullUrl(p4, Extreme)
		end
	end

	return function(p5, p6, p7) -- line: 47
		-- upvalues: ApplicationJson (copy), Extreme (copy), p1 (copy), Promise (copy), HttpService (copy)
		assert(type(p5) == "string", "Expected url to be a string")
		assert(type(p6) == "string", "Expected requestMethod to be a string")
		assert(not p7 or type(p7) == "table", "Expected options to be a table")

		local v14 = string.upper(p6)
		local u15 = nil

		if v14 == "POST" then
			assert(p7.postBody, "Expected a postBody to be specified with this request")
			assert(type(p7.postBody) == "string", "Expected postBody to be a string")

			if not p7.contentType then
				p7.contentType = ApplicationJson
			end

			if not p7.throttlingPriority then
				p7.throttlingPriority = Extreme
			end

			function u15() -- line: 23
				-- upvalues: p1 (copy), p5 (copy), p7 (copy)
				return p1:PostAsyncFullUrl(p5, p7.postBody, p7.throttlingPriority, p7.contentType)
			end
		elseif v14 == "GET" then
			function u15() -- line: 34
				-- upvalues: p1 (copy), p5 (copy), Extreme (copy)
				return p1:GetAsyncFullUrl(p5, Extreme)
			end
		else
			error(string.format("Unsupported requestMethod : %s", v14 or "nil"))
		end

		return Promise.new(function(resolve, reject) -- line: 62
			-- upvalues: u15 (ref), HttpService (copy)
			if u15 then
				coroutine.wrap(function() -- line: 64
					-- upvalues: u15 (ref), HttpService (copy), resolve (copy), reject (copy)
					local ok, result = pcall(u15)

					if ok then
						local ok2, result2 = pcall(function() -- line: 68
							-- upvalues: HttpService (copy), result (copy)
							return HttpService:JSONDecode(result)
						end)

						if ok2 then
							resolve({
								responseBody = result2
							})

							return
						end

						reject(result2)

						return
					end

					reject(result)
				end)()

				return
			end

			reject()
		end)
	end
end
