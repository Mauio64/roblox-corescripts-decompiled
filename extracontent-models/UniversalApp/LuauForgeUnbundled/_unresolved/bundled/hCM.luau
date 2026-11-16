local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hCx")
local roactNetworking = module.RoactNetworking
local roactAnalytics = module.RoactAnalytics
local module2 = require("@luauforge/bundled/hCG")

local module3 = require("@luauforge/bundled/hCf")
local module4 = require("@luauforge/bundled/hBs")

local nonInteractiveActivationFrameworkWrapper = module4.Components.NonInteractiveActivationFrameworkWrapper
local useRoactService = require("@luauforge/bundled/hCu").useRoactService

local fetchSignupUserAgreements = require("@luauforge/bundled/hCH").FetchSignupUserAgreements
local payloadKey = module4.Enums.PayloadKey

return function(p2)
	local v5 = useRoactService(roactAnalytics)
	local v6 = useRoactService(roactNetworking)

	return module3.createElement(nonInteractiveActivationFrameworkWrapper, {
		step = {
			onNonInteractiveStepExecution = function()
				local v8, v9 = fetchSignupUserAgreements(v6, v5):andThen(function(p3)
					return (module2.List.map(p3, function(p4)
						return p4.id
					end))
				end):await()

				if not v8 then
					return { successPayloadAddendum = nil, errorOutput = {} }
				end

				local jsonEncode = HttpService:JSONEncode(v9)
				return {
					successPayloadAddendum = {
						[payloadKey.SignupAgreedUserAgreements] = jsonEncode
					},
					errorOutput = nil
				}
			end
		},
		navigation = p2.navigation
	})
end
