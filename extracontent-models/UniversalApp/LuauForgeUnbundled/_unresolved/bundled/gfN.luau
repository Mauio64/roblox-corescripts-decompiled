local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/gfO")
local url = require("@luauforge/bundled/gfP").Url
require("@luauforge/bundled/gfP")
require("@luauforge/bundled/gfQ")

local linkingProtocol = require("@luauforge/bundled/gfR").LinkingProtocol
local default = require("@luauforge/bundled/gfS").default

local module2 = require("@luauforge/bundled/gfT")
local module3 = require("@luauforge/bundled/gfU")

local getFFlagEnableLuaAppsAppsflyerIdCounter = require("@luauforge/bundled/gfW").GetFFlagEnableLuaAppsAppsflyerIdCounter

return {
	attributeV2 = function(callback, p2)
		return module.new(function(callback2)
			local v5, v6 = linkingProtocol.default:getUID():await()

			if getFFlagEnableLuaAppsAppsflyerIdCounter() then
				default:logRobloxTelemetryCounter(module3.AppsflyerIdTotalCounter)

				if v6 == nil or v6 == "" then
					default:logRobloxTelemetryCounter(module3.AppsflyerIdFailureCounter)
				end
			end

			local jsonEncode = HttpService:JSONEncode({
				appsflyerId = v6 == nil and "" or v6,
				eventType = module2.parseLaunchContextToPostAuthenticationEventType(p2)
			})

			callback(string.format("%sattribution/v1/events/post-authentication", url.APIS_URL), "POST", {
				postBody = jsonEncode
			}):await()
			callback2()
		end)
	end
}
