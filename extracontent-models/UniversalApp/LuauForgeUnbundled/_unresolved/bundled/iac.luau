local CorePackages = game:GetService("CorePackages")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/eec")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")

local module2 = require("@luauforge/bundled/hZK")
local module3 = require("@luauforge/bundled/hZL")
local module4 = require("@luauforge/bundled/iad")
local module5 = require("@luauforge/bundled/iae")
require("@luauforge/bundled/hZh")

local v5 = {
	["c"] = module5.Asset,
	b = module5.Bundle,
	e = module5.ExperienceDetails,
	g = module5.Group,
	l = module5.Look,
	s = module5.Server,
	u = module5.UserProfile
}

local v6 = {
	{
		{ name = appPage.Home },
		{ name = appPage.ShareLinkInvalidModal }
	}
}

return function(p2, p3, p4, p5)
	module.Stopwatch.start(module.Events.StaticShareLinkOpened)
	local v7 = v5[p2] or module5.Unknown

	local v8 = { didSucceed = true, extraProps = p4, linkId = p3, staticLinkType = v7 }
	local v9 = module4[v7](p3, p4, p5)

	if not v9 then
		v8.didSucceed = false
		v9 = v6
	end

	module3(module2.StaticShareLinkResolveLink, v8)

	local v10 = module.Stopwatch.stop(module.Events.StaticShareLinkOpened)

	if v10 then
		module3(module2.StaticShareLinkLatency, Cryo.Dictionary.union(v8, {
			statValue = v10.timeElapsed
		}))
	end

	return v9
end
