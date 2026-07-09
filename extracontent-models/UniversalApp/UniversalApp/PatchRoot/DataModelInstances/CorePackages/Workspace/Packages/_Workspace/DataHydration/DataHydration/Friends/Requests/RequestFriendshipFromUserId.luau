local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)

return function(p1, s1: string?) -- line: 22
	-- upvalues: Url (copy), HttpService (copy), myHttpRequest (copy)
	local v9 = string.format("%s/users/%s/request-friendship", Url.FRIEND_URL, (tostring(p1)))
	local json = HttpService:JSONEncode({
		friendshipOriginSourceType = s1
	})

	return myHttpRequest(v9, "POST", {
		postBody = json
	}):andThen(function() -- line: 28
		return nil
	end):catch(function(p2) -- line: 31
		-- upvalues: HttpService (copy)
		local v12 = if type(p2) ~= "table" then nil else p2.StatusCode
		local code = nil
		local v14 = if type(p2) ~= "table" then nil else p2.Body

		if type(v14) == "string" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v14)

			if ok and type(result) == "table" then
				local errors = result.errors

				if type(errors) == "table" and errors[1] then
					code = errors[1].code
				end
			end
		end

		error({
			statusCode = v12,
			firstErrorCode = code
		})
	end)
end
