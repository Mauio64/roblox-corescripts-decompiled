local HttpService = game:GetService("HttpService")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes

return function(p2): boolean
	if p2.StatusCode ~= statusCodes.FORBIDDEN then
		return false
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p2.Body)

	if success then
		local errors = result and result.errors or nil

		if errors == nil then
			return false
		end

		for k, err in pairs(errors) do
			for k2, v5 in pairs(err) do
				if k2 == "message" and v5 == "User is moderated" then
					return true
				end
			end
		end
	else
		logger:info("Failed to parse JSON error body for moderation")
		logger:info(p2.Body)

		return false
	end

	return false
end
