local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local HttpService = game:GetService("HttpService")
local MultiPageSignupParent = MultiPageSignup.Parent
local RoactServiceTags = require(MultiPageSignupParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local Cryo = require(MultiPageSignupParent.Cryo)
local React = require(MultiPageSignupParent.React)
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local NonInteractiveActivationFrameworkWrapper = UserActivationFramework.Components.NonInteractiveActivationFrameworkWrapper
local useRoactService = require(MultiPageSignupParent.RobloxAppHooks).useRoactService
local FetchSignupUserAgreements = require(MultiPageSignupParent.UserAgreements).FetchSignupUserAgreements
local PayloadKey = UserActivationFramework.Enums.PayloadKey

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), RoactNetworking (copy), FetchSignupUserAgreements (copy), Cryo (copy), HttpService (copy), PayloadKey (copy), React (copy), NonInteractiveActivationFrameworkWrapper (copy)
	local v15 = useRoactService(RoactAnalytics)
	local v16 = useRoactService(RoactNetworking)
	local t2 = {
		onNonInteractiveStepExecution = function() -- line: 30
			-- upvalues: FetchSignupUserAgreements (copy), v16 (copy), v15 (copy), Cryo (copy), HttpService (copy), PayloadKey (copy)
			local v18, v19 = FetchSignupUserAgreements(v16, v15):andThen(function(p1) -- line: 32
				-- upvalues: Cryo (copy)
				return (Cryo.List.map(p1, function(p2) -- line: 33
					return p2.id
				end))
			end):await()

			if v18 then
				local json = HttpService:JSONEncode(v19)

				return {
					errorOutput = nil,
					successPayloadAddendum = {
						[PayloadKey.SignupAgreedUserAgreements] = json
					}
				}
			end

			return {
				successPayloadAddendum = nil,
				errorOutput = {}
			}
		end
	}

	return React.createElement(NonInteractiveActivationFrameworkWrapper, {
		step = t2,
		navigation = t1.navigation
	})
end
