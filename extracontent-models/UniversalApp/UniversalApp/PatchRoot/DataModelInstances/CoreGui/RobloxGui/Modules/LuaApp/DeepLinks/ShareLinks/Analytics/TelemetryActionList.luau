local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local SupportedTelemetryBackends = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)

local function v5(b1: boolean) -- line: 8
	if b1 then
		return "True"
	end

	return "False"
end

local identity = Dash.identity

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("ShareLinksAnalyticsThrottlingThousandths", 10000)
	},
	[EventNames.ShareLinkLatency] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				linkStatus = identity,
				linkType = identity
			}
		}}
	},
	[EventNames.ShareLinkResolveLink] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				linkStatus = identity,
				linkType = identity
			}
		}}
	},
	[EventNames.StaticShareLinkLatency] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				staticLinkType = identity,
				didSucceed = v5
			}
		}}
	},
	[EventNames.StaticShareLinkResolveLink] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					staticLinkType = identity,
					didSucceed = v5
				}
			},
			{
				type = SupportedTelemetryBackends.EventIngest,
				dynamicCustomFields = {
					staticLinkType = identity,
					linkId = identity,
					extraProps = identity,
					didSucceed = v5
				}
			}
		}
	}
}
