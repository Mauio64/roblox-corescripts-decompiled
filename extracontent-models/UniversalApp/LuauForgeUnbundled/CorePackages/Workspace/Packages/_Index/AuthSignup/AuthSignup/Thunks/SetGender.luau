local PostSetGender = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Requests/PostSetGender")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Promise")

return {
	setGender = function(p2, p3)
		return PostSetGender(p2, p3):andThen(function(p4)
			if p4 == nil or p4.responseBody == nil then
				return Promise.reject()
			end

			return Promise.resolve()
		end):catch(function(p4)
			return Promise.reject()
		end)
	end
}
