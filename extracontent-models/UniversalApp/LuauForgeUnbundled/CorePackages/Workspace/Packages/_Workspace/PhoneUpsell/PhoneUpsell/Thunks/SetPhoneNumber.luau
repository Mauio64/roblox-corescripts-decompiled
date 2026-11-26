local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Promise")
local PostSetPhone = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Http/Requests/PostSetPhone")
local isStringPhone = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon").Utils.isStringPhone

return function(p2, p3, p4, p5, p6)
	return function()
		if isStringPhone(p4 .. p5) then
			return PostSetPhone(p2, p3, p4, p5, p6):andThen(function(p7)
				return Promise.resolve()
			end, function(p7)
				local v5 = not p7.Body and 0 or HttpService:JSONDecode(p7.Body).errors[1].code

				return Promise.reject({ ErrorCode = v5, PhoneRegexFailed = false })
			end)
		end

		return Promise.reject({ PhoneRegexFailed = true })
	end
end
