local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url

local function getChangePasswordUrl() -- line: 10
	-- upvalues: Url (copy)
	return string.format("%sv2/user/passwords/change", Url.AUTH_URL)
end

return function(p1, p2) -- line: 22
	-- upvalues: HttpService (copy), Url (copy), Promise (copy)
	local json = HttpService:JSONEncode({
		currentPassword = nil,
		newPassword = p2
	})

	return p1(string.format("%sv2/user/passwords/change", Url.AUTH_URL), "POST", {
		postBody = json
	}):andThen(function(p3) -- line: 24
		-- upvalues: Promise (copy)
		return Promise.resolve(p3)
	end, function(p4) -- line: 26
		-- upvalues: Promise (copy)
		return Promise.reject(p4)
	end)
end
