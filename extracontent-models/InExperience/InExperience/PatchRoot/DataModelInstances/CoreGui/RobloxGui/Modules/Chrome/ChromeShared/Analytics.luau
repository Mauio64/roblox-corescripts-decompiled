local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")

local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local ChromeAnalytics = require(script.ChromeAnalytics)
local React = require(CorePackages.Packages.React)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local fFlagUnibarLuaOcclusionMetrics = SharedFlags.GetFFlagUnibarLuaOcclusionMetrics()
local OcclusionMetricsManager = require(script.OcclusionMetricsManager)

local function ChromeAnalyticsListener(_)
	ChromeAnalytics.default:setScreenSize((useObservableValue(ViewportUtil.screenSize)))

	if fFlagUnibarLuaOcclusionMetrics then
		return React.createElement(OcclusionMetricsManager)
	end

	return nil
end

return ChromeAnalyticsListener
