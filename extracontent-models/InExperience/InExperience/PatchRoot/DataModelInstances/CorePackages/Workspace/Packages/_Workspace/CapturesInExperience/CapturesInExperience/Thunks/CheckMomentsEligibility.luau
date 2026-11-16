local parent = script.Parent.Parent

local MomentsEligibilityReceived = require(parent.Actions.MomentsEligibilityReceived)
local Constants = require(parent.Constants)
local FFlagCreateMomentsToast = require(parent.Flags.FFlagCreateMomentsToast)
local FFlagMomentsCaptureEndIxpEnabled = require(parent.Flags.FFlagMomentsCaptureEndIxpEnabled)
local Networking = require(parent.App.Networking)

local ContentSharingNetworking = Networking.ContentSharingNetworking

return function(p: number)
	return function(object)
		if
			not (FFlagCreateMomentsToast or FFlagMomentsCaptureEndIxpEnabled)
			or ContentSharingNetworking == nil
			or type(object:getState()[Constants.RoduxKey].MomentsEligibility.byUniverseId[p]) == "boolean"
		then
			return
		end

		object:dispatch(ContentSharingNetworking.CheckMomentsEligibility.API({
			contentType = "experience",
			experienceId = tostring(p)
		})):andThen(function(p2)
			local responseBody = p2.responseBody
			object:dispatch(MomentsEligibilityReceived(
				p,
				type(responseBody) == "table" and responseBody.isEligible == true
			))
		end):catch(function() end)
	end
end
