local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/gik")
local module3 = require("@luauforge/bundled/ilx")
local module4 = require("@luauforge/bundled/gie")
local module5 = require("@luauforge/bundled/gXF")
local module6 = require("@luauforge/bundled/gJd")
local module7 = require("@luauforge/bundled/dKv")
local module8 = require("@luauforge/bundled/fzT")
local authOperationTiming = module8.Events.authOperationTiming
local authClientError = module8.Events.authClientError
local eventStreamConstants = module8.EventStreamConstants

game:DefineFastInt("LuaAppBirthdayComplianceUnblockInitialDelayMs", 1000)
game:DefineFastInt("LuaAppBirthdayComplianceUnblockPollIntervalMs", 1000)
game:DefineFastInt("LuaAppBirthdayComplianceUnblockPollMaxRetries", 4)

local function isModeratedError(p2)
	return type(p2) == "table" and module3(p2)
end

return function(p2)
	return function(object)
		local v5 = game:GetFastInt("LuaAppBirthdayComplianceUnblockInitialDelayMs") / 1000
		local v6 = game:GetFastInt("LuaAppBirthdayComplianceUnblockPollIntervalMs") / 1000
		local fastInt = game:GetFastInt("LuaAppBirthdayComplianceUnblockPollMaxRetries")
		local lastTime = os.clock()

		local function routeHome()
			object:dispatch(module7({
				{ name = appPage.Home, rnKey = appPage.Home }
			}))
		end

		local function waitUntilUnblocked(p3)
			return module2(p2):andThen(function()
				return eventStreamConstants.State.GatewayUnblocked
			end, function(p4)
				local v7 = type(p4) == "table" and module3(p4)

				if not v7 then
					return eventStreamConstants.State.GatewayProbeFailed
				end

				if fastInt <= p3 then
					return eventStreamConstants.State.GatewayRetriesExhausted
				end

				return module.delay(v6):andThen(function()
					return waitUntilUnblocked(p3 + 1)
				end)
			end)
		end

		local v7

		if v5 > 0 then
			v7 = module.delay(v5):andThen(function()
				return waitUntilUnblocked(0)
			end)
		else
			v7 = waitUntilUnblocked(0)
		end

		return v7:andThen(function(p3)
			authOperationTiming(
				eventStreamConstants.Context.BirthdayComplianceUnblockWait,
				math.round((os.clock() - lastTime) * 1000),
				p3
			)

			return object:dispatch(module5(p2))
		end):andThen(function(p3)
			if p3 == nil then
				object:dispatch(module6())
			elseif p3.source == module4.BirthdayCompliance then
				routeHome()
			end
		end, function()
			authClientError(
				eventStreamConstants.Context.BirthdayComplianceUnblockWait,
				eventStreamConstants.State.FetchAccessStatusError
			)

			routeHome()
		end)
	end
end
