local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local GetShareLinkMetaData = require(Modules.LuaApp.Http.Requests.GetShareLinkMetaData)
local HttpService = game:GetService("HttpService")

return function(p1, s1: string, s2: string) -- line: 6
	-- upvalues: GetShareLinkMetaData (copy), HttpService (copy), Promise (copy)
	return GetShareLinkMetaData(p1, s1, s2):andThen(function(p2) -- line: 7
		-- upvalues: HttpService (copy), Promise (copy)
		if p2 and (p2.responseBody and p2.responseBody.data) then
			local data = HttpService:JSONDecode(p2.responseBody.data)

			return Promise.resolve(data)
		end

		return Promise.reject()
	end, function(p3) -- line: 14
		-- upvalues: Promise (copy)
		return Promise.reject({ p3.StatusCode })
	end)
end
