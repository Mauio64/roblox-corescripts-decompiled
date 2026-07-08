local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent

require(AuthCommonParent.Http)

local getSingleSignOnUrls = require(AuthCommon.Utils.getSingleSignOnUrls)
local ConsoleAuthRequestWrapper = require(AuthCommonParent.Http).Utils.ConsoleAuthRequestWrapper
local Promise = require(AuthCommonParent.Promise)

return function(p1) -- line: 9
	-- upvalues: getSingleSignOnUrls (copy), ConsoleAuthRequestWrapper (copy), Promise (copy)
	local disconnect = getSingleSignOnUrls().disconnect

	if disconnect then
		return ConsoleAuthRequestWrapper(p1, disconnect(), "POST", {
			postBody = "",
			maxRetryCount = 0
		})
	end

	return Promise.reject({})
end
