local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/hVy")
local module2 = require("@luauforge/bundled/hWq")
local module3 = require("@luauforge/bundled/hWr")

local module4 = require("@luauforge/bundled/hWE")
local module5 = require("@luauforge/bundled/edx")
local module6 = require("@luauforge/bundled/hWF")

local defineFastInt = game:DefineFastInt("EnableSentryUADebugRolloutPercentage", 0)
local v5 = math.random(1, 100) <= math.clamp(defineFastInt, 0, 100)

local extended = Roact.Component:extend("MutedErrorReporter")

local fFlagDisableGoogleAnalyticsErrorReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDisableGoogleAnalyticsErrorReporting

function extended:init()
	local appName = self.props.appName

	local v6 = if module6() then module4 else nil
	local v7 = if v5 then module3 else nil
	self.errorReporter = module.new(module5.ReportMutedError, nil, v6, module2.DEBUG, v7)

	self.errorReporter:setCurrentApp(appName)

	if not fFlagDisableGoogleAnalyticsErrorReporting then
		self.errorReporter:startQueueTimers()
	end
end

function extended.render(p2): nil
	return nil
end

function extended.willUnmount(p2)
	if not fFlagDisableGoogleAnalyticsErrorReporting then
		p2.errorReporter:stopQueueTimers()
	end
end

return extended
