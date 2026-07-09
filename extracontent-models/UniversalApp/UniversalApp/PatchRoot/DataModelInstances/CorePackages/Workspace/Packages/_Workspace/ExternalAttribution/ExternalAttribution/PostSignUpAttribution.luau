local HttpService = game:GetService("HttpService")
local ExternalAttribution = script:FindFirstAncestor("ExternalAttribution")
local ExternalAttributionParent = ExternalAttribution.Parent
local Promise = require(ExternalAttributionParent.Promise)
local Url = require(ExternalAttributionParent.Http).Url

require(ExternalAttributionParent.Http)
require(ExternalAttributionParent.AppStartup)

local LinkingProtocol = require(ExternalAttributionParent.LinkingProtocol).LinkingProtocol
local default = require(ExternalAttributionParent.LoggingProtocol).default
local Utils = require(ExternalAttribution.Utils)
local TelemetryConfigs = require(ExternalAttribution.TelemetryConfigs)
local GetFFlagEnableLuaAppsAppsflyerIdCounter = require(ExternalAttribution.Flags).GetFFlagEnableLuaAppsAppsflyerIdCounter

return {
	attributeV2 = function(p1, p2) -- line: 24
		-- upvalues: Promise (copy), LinkingProtocol (copy), GetFFlagEnableLuaAppsAppsflyerIdCounter (copy), default (copy), TelemetryConfigs (copy), HttpService (copy), Utils (copy), Url (copy)
		return Promise.new(function(resolve) -- line: 25
			-- upvalues: LinkingProtocol (copy), GetFFlagEnableLuaAppsAppsflyerIdCounter (copy), default (copy), TelemetryConfigs (copy), HttpService (copy), Utils (copy), p2 (copy), Url (copy), p1 (copy)
			local _, v15 = LinkingProtocol.default:getUID():await()

			if GetFFlagEnableLuaAppsAppsflyerIdCounter() then
				default:logRobloxTelemetryCounter(TelemetryConfigs.AppsflyerIdTotalCounter)

				if v15 == nil or v15 == "" then
					default:logRobloxTelemetryCounter(TelemetryConfigs.AppsflyerIdFailureCounter)
				end
			end

			if v15 == nil then
				v15 = ""
			end

			local json = HttpService:JSONEncode({
				appsflyerId = v15,
				eventType = Utils.parseLaunchContextToPostAuthenticationEventType(p2)
			})
			local v17 = string.format("%sattribution/v1/events/post-authentication", Url.APIS_URL)

			p1(v17, "POST", {
				postBody = json
			}):await()
			resolve()
		end)
	end
}
