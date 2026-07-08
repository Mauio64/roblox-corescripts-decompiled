local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(InterventionSharedParent.UrlBuilder).UrlBuilder
local Promise = require(InterventionSharedParent.Promise)
local buildQueryString = require(InterventionShared.Utils.buildQueryString)

local function GetModerationDetail(t1: {[any]: any}) -- line: 20
	-- upvalues: UrlBuilder (copy), buildQueryString (copy), Promise (copy), HttpRbxApiService (copy), HttpService (copy)
	local v10 = UrlBuilder.usermoderation.moderationDetail() .. buildQueryString(t1)

	return Promise.new(function(resolve, reject) -- line: 24
		-- upvalues: HttpRbxApiService (copy), v10 (copy), HttpService (copy)
		task.defer(function() -- line: 25
			-- upvalues: HttpRbxApiService (copy), v10 (copy), HttpService (copy), resolve (copy), reject (copy)
			local ok, result = pcall(function() -- line: 26
				-- upvalues: HttpRbxApiService (copy), v10 (copy)
				return HttpRbxApiService:GetAsyncFullUrl(v10, Enum.ThrottlingPriority.Default)
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

return GetModerationDetail
