local CorePackages = game:GetService("CorePackages")
local SocialStopwatch = require(CorePackages.Workspace.Packages.SocialStopwatch)
local EventNames = require(script.Parent.EventNames)
local fireTelemetry = require(script.Parent.fireTelemetry)

require(script.Parent.Parent.LinkStatus)
require(script.Parent.Parent.ShareLinkTypes)

return function(p1, p2) -- line: 10
	-- upvalues: SocialStopwatch (copy), fireTelemetry (copy), EventNames (copy)
	local v7 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ShareLinkOpened)
	local t1 = {
		linkStatus = p2,
		linkType = p1,
		statValue = if not v7 then nil else v7.timeElapsed
	}

	fireTelemetry(EventNames.ShareLinkLatency, t1)
end
