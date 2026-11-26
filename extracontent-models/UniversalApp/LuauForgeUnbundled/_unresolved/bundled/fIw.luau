local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local supportedTelemetryBackends = require("@luauforge/bundled/ecs").Analytics.Enums.SupportedTelemetryBackends
local module = require("@luauforge/bundled/fIu")

local function fn(p2): string
	if p2 then
		return "True"
	end

	return "False"
end

local identity = Dash.identity

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("ShareLinksAnalyticsThrottlingThousandths", 10000),
		links = ""
	},
	[module.ShareLinkLatency] = {
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = { linkStatus = identity, linkType = identity }
			}
		}
	},
	[module.ShareLinkResolveLink] = {
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = { linkStatus = identity, linkType = identity }
			}
		}
	},
	[module.StaticShareLinkLatency] = {
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = { staticLinkType = identity, didSucceed = fn }
			}
		}
	},
	[module.StaticShareLinkResolveLink] = {
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = { staticLinkType = identity, didSucceed = fn }
			},
			{
				type = supportedTelemetryBackends.EventIngest,
				dynamicCustomFields = {
					staticLinkType = identity,
					linkId = identity,
					extraProps = identity,
					didSucceed = fn
				}
			}
		}
	}
}
