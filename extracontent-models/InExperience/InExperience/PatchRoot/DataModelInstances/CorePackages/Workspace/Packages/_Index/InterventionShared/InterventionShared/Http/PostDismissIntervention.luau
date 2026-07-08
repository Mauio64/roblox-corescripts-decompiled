local Parent = script:FindFirstAncestor("InterventionShared").Parent
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Promise = require(Parent.Promise)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

local function PostDismissIntervention(s1: string) -- line: 18
	-- upvalues: UrlBuilder (copy), HttpService (copy), Promise (copy), HttpRbxApiService (copy)
	local v8 = UrlBuilder.usermoderation.dismissIntervention()
	local json = HttpService:JSONEncode({
		intervention_id = s1
	})

	return Promise.new(function(resolve, reject) -- line: 24
		-- upvalues: HttpRbxApiService (copy), v8 (copy), json (copy), HttpService (copy)
		task.defer(function() -- line: 25
			-- upvalues: HttpRbxApiService (copy), v8 (copy), json (copy), HttpService (copy), resolve (copy), reject (copy)
			local ok, result = pcall(function() -- line: 26
				-- upvalues: HttpRbxApiService (copy), v8 (copy), json (copy)
				return HttpRbxApiService:PostAsyncFullUrl(v8, json, Enum.ThrottlingPriority.Default)
			end)

			if ok then
				local ok2, result2 = pcall(function() -- line: 31
					-- upvalues: HttpService (copy), result (copy)
					return HttpService:JSONDecode(result)
				end)

				if ok2 then
					resolve(result2)

					return
				end

				reject({
					error = "Failed to parse JSON response",
					details = result2
				})

				return
			end

			reject({
				error = "HTTP request failed",
				details = result
			})
		end)
	end)
end

return PostDismissIntervention
