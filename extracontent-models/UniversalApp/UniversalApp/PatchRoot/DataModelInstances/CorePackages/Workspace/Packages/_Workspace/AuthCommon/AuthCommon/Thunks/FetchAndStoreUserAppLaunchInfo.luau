local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local AuthCommonParent = AuthCommon.Parent
local GetUserAppLaunchInfo = require(AuthCommon.Http.Requests.GetUserAppLaunchInfo)
local Promise = require(AuthCommonParent.Promise)
local AppStorageService = game:GetService("AppStorageService")

return function(p1) -- line: 8
	-- upvalues: Promise (copy), GetUserAppLaunchInfo (copy), AppStorageUtilities (copy), AppStorageService (copy)
	local _, v9 = Promise.new(function(resolve) -- line: 9
		-- upvalues: GetUserAppLaunchInfo (copy), p1 (copy), AppStorageUtilities (copy), AppStorageService (copy)
		GetUserAppLaunchInfo(p1):andThen(function(p2) -- line: 10
			-- upvalues: AppStorageUtilities (copy), AppStorageService (copy), resolve (copy)
			if p2 and p2.responseBody then
				local name = p2.responseBody.name
				local str = tostring(p2.responseBody.id)

				AppStorageUtilities.setIncompleteSignupUserId(str)
				AppStorageUtilities.setIncompleteSignupUsername(name)
				AppStorageService:Flush()
			end

			resolve(true)
		end):catch(function(_) -- line: 19
			-- upvalues: resolve (copy)
			resolve(false)
		end)
	end):await()

	return v9
end
