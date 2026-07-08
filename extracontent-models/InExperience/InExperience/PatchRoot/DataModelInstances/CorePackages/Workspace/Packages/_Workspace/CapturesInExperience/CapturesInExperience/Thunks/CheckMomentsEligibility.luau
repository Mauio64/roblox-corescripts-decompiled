local ParentParent = script.Parent.Parent
local MomentsEligibilityReceived = require(ParentParent.Actions.MomentsEligibilityReceived)
local Constants = require(ParentParent.Constants)
local FFlagCreateMomentsToast = require(ParentParent.Flags.FFlagCreateMomentsToast)
local ContentSharingNetworking = require(ParentParent.App.Networking).ContentSharingNetworking

return function(n1: number) -- line: 14
	-- upvalues: FFlagCreateMomentsToast (copy), ContentSharingNetworking (copy), Constants (copy), MomentsEligibilityReceived (copy)
	return function(p1) -- line: 15
		-- upvalues: FFlagCreateMomentsToast (copy), ContentSharingNetworking (copy), Constants (copy), n1 (copy), MomentsEligibilityReceived (copy)
		if not FFlagCreateMomentsToast or ContentSharingNetworking == nil then
			return
		end

		if type(p1:getState()[Constants.RoduxKey].MomentsEligibility.byUniverseId[n1]) == "boolean" then
			return
		end

		p1:dispatch(ContentSharingNetworking.CheckMomentsEligibility.API({
			contentType = "experience",
			experienceId = tostring(n1)
		})):andThen(function(p2) -- line: 31
			-- upvalues: p1 (copy), MomentsEligibilityReceived (copy), n1 (copy)
			local responseBody = p2.responseBody
			local v10 = type(responseBody) == "table" and responseBody.isEligible == true

			p1:dispatch(MomentsEligibilityReceived(n1, v10))
		end):catch(function() -- line: 36
		end)
	end
end
