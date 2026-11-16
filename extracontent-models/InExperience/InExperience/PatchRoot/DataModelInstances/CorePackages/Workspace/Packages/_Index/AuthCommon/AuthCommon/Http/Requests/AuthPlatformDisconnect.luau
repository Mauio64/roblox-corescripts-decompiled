local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

require(parent.Http)
local getSingleSignOnUrls = require(AuthCommon.Utils.getSingleSignOnUrls)
local Http = require(parent.Http)
local ConsoleAuthRequestWrapper = Http.Utils.ConsoleAuthRequestWrapper
local Promise = require(parent.Promise)

return function(p)
	local disconnect = getSingleSignOnUrls().disconnect

	if disconnect then
		return ConsoleAuthRequestWrapper(p, disconnect(), "POST", {
			postBody = "",
			maxRetryCount = 0
		})
	end

	return Promise.reject({})
end
