local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local PostSetGender = require(AuthSignup.Requests.PostSetGender)
local Promise = require(AuthSignupParent.Promise)

return {
	setGender = function(p1, p2) -- line: 8
		-- upvalues: PostSetGender (copy), Promise (copy)
		return PostSetGender(p1, p2):andThen(function(p3) -- line: 9
			-- upvalues: Promise (copy)
			if p3 == nil or p3.responseBody == nil then
				return Promise.reject()
			end

			return Promise.resolve()
		end):catch(function(_) -- line: 15
			-- upvalues: Promise (copy)
			return Promise.reject()
		end)
	end
}
