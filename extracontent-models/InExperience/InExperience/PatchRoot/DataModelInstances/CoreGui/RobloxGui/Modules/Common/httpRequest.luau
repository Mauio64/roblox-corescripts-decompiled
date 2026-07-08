local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local Extreme = Enum.ThrottlingPriority.Extreme
local ApplicationJson = Enum.HttpContentType.ApplicationJson

return function(p1) -- line: 10
	-- upvalues: HttpService (copy), ApplicationJson (copy), Extreme (copy), Promise (copy)
	local function doHttpPost(p2, p3) -- line: 12
		-- upvalues: HttpService (copy), ApplicationJson (copy), Extreme (copy), p1 (copy)
		local json = nil

		assert(p3.postBody, "Expected a postBody to be specified with this request")

		if type(p3.postBody) == "table" then
			json = HttpService:JSONEncode(p3.postBody)
		elseif type(p3.postBody) == "string" then
			json = p3.postBody
		else
			error("Expected postBody to be a string or table")
		end

		if not p3.contentType then
			p3.contentType = ApplicationJson
		end

		if not p3.throttlingPriority then
			p3.throttlingPriority = Extreme
		end

		return function() -- line: 31
			-- upvalues: p1 (copy), p2 (copy), json (ref), p3 (copy)
			return p1:PostAsyncFullUrl(p2, json, p3.throttlingPriority, p3.contentType)
		end
	end
	local function doHttpGet(p4) -- line: 41
		-- upvalues: p1 (copy), Extreme (copy)
		return function() -- line: 42
			-- upvalues: p1 (copy), p4 (copy), Extreme (copy)
			return p1:GetAsyncFullUrl(p4, Extreme)
		end
	end

	return function(p5, p6, p7) -- line: 55
		-- upvalues: doHttpPost (copy), p1 (copy), Extreme (copy), Promise (copy), HttpService (copy)
		assert(type(p5) == "string", "Expected url to be a string")
		assert(type(p6) == "string", "Expected requestMethod to be a string")
		assert(not p7 or type(p7) == "table", "Expected options to be a table")

		local v16 = string.upper(p6)
		local u17 = nil

		if v16 == "POST" then
			u17 = doHttpPost(p5, p7)
		elseif v16 == "GET" then
			function u17() -- line: 42
				-- upvalues: p1 (copy), p5 (copy), Extreme (copy)
				return p1:GetAsyncFullUrl(p5, Extreme)
			end
		else
			error(string.format("Unsupported requestMethod : %s", v16 or "nil"))
		end

		return Promise.new(function(resolve, reject) -- line: 70
			-- upvalues: u17 (ref), HttpService (copy)
			if u17 then
				spawn(function() -- line: 72
					-- upvalues: u17 (ref), HttpService (copy), resolve (copy), reject (copy)
					local ok, result = pcall(u17)

					if ok then
						local ok2, result2 = pcall(function() -- line: 76
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
				end)

				return
			end

			reject()
		end)
	end
end
