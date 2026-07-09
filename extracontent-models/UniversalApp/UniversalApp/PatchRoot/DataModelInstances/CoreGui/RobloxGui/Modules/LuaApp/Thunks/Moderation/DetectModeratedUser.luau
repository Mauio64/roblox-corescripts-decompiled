local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes

return function(p1) -- line: 7
	-- upvalues: StatusCodes (copy), HttpService (copy), Logger (copy)
	if p1.StatusCode == StatusCodes.FORBIDDEN then
		local ok, result = pcall(HttpService.JSONDecode, HttpService, p1.Body)

		if not ok then
			Logger:info("Failed to parse JSON error body for moderation")
			Logger:info(p1.Body)

			return false
		end

		local v8 = result and result.errors or nil

		if v8 == nil then
			return false
		end

		for _, v in pairs(v8) do
			for k, v2 in pairs(v) do
				if k == "message" and v2 == "User is moderated" then
					return true
				end
			end
		end
	end

	return false
end
