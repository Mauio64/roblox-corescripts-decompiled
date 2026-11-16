local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local PostSetGender = require(AuthSignup.Requests.PostSetGender)

local Promise = require(parent.Promise)

return {
	setGender = function(p, p2)
		return PostSetGender(p, p2):andThen(function(p3)
			if p3 == nil or p3.responseBody == nil then
				return Promise.reject()
			end

			return Promise.resolve()
		end):catch(function(_)
			return Promise.reject()
		end)
	end
}
