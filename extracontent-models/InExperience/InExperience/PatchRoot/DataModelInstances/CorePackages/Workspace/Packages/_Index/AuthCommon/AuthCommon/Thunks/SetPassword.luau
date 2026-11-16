local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local function getChangePasswordUrl() -- 1 equivalent call inferred from this helper
	return string.format("%sv2/user/passwords/change", Url.AUTH_URL)
end

return function(callback, newPassword)
	local jsonEncode = HttpService:JSONEncode({ currentPassword = nil, newPassword = newPassword })
	return callback(getChangePasswordUrl(), "POST", { postBody = jsonEncode }):andThen(function(p) -- inferred equivalent call
		return Promise.resolve(p)
	end, function(p)
		return Promise.reject(p)
	end)
end
