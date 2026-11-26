require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http")
local getSingleSignOnUrls = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/getSingleSignOnUrls")
local consoleAuthRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Utils.ConsoleAuthRequestWrapper
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")

return function(p2)
	local disconnect = getSingleSignOnUrls().disconnect

	if disconnect then
		return consoleAuthRequestWrapper(p2, disconnect(), "POST", {
			postBody = "",
			maxRetryCount = 0
		})
	end

	return Promise.reject({})
end
