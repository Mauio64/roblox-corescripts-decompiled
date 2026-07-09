local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local Cryo = require(CorePackages.Packages.Cryo)
local SocialStopwatch = require(CorePackages.Workspace.Packages.SocialStopwatch)

require(CorePackages.Workspace.Packages.NavigationRodux)

local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local EventNames = require(scriptParentParent.Analytics.EventNames)
local fireTelemetry = require(scriptParentParent.Analytics.fireTelemetry)
local StaticLinkTypeToHandlerMap = require(scriptParent.StaticLinkTypeToHandlerMap)
local StaticShareLinkTypes = require(scriptParent.StaticShareLinkTypes)

require(scriptParentParent.Types)

local t1 = {
	c = StaticShareLinkTypes.Asset,
	b = StaticShareLinkTypes.Bundle,
	e = StaticShareLinkTypes.ExperienceDetails,
	g = StaticShareLinkTypes.Group,
	l = StaticShareLinkTypes.Look,
	s = StaticShareLinkTypes.Server,
	u = StaticShareLinkTypes.UserProfile
}
local t2 = {{
	{
		name = AppPage.Home
	},
	{
		name = AppPage.ShareLinkInvalidModal
	}
}}

return function(s1: string, s2: string, t3: {[any]: any}, p1) -- line: 34
	-- upvalues: SocialStopwatch (copy), t1 (copy), StaticShareLinkTypes (copy), StaticLinkTypeToHandlerMap (copy), t2 (copy), fireTelemetry (copy), EventNames (copy), Cryo (copy)
	SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.StaticShareLinkOpened)

	local v17 = t1[s1] or StaticShareLinkTypes.Unknown
	local v18 = StaticLinkTypeToHandlerMap[v17]
	local t4 = {
		didSucceed = true,
		extraProps = t3,
		linkId = s2,
		staticLinkType = v17
	}
	local v20 = v18(s2, t3, p1)

	if not v20 then
		t4.didSucceed = false
		v20 = t2
	end

	fireTelemetry(EventNames.StaticShareLinkResolveLink, t4)

	local v21 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.StaticShareLinkOpened)

	if v21 then
		fireTelemetry(EventNames.StaticShareLinkLatency, Cryo.Dictionary.union(t4, {
			statValue = v21.timeElapsed
		}))
	end

	return v20
end
