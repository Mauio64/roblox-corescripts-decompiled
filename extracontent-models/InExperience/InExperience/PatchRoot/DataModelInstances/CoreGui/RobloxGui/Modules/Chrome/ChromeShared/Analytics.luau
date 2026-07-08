local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local ChromeAnalytics = require(script.ChromeAnalytics)
local React = require(CorePackages.Packages.React)
local v7 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUnibarLuaOcclusionMetrics()
local OcclusionMetricsManager = require(script.OcclusionMetricsManager)

local function ChromeAnalyticsListener(_) -- line: 14
	-- upvalues: ChromeAnalytics (copy), useObservableValue (copy), ViewportUtil (copy), v7 (copy), React (copy), OcclusionMetricsManager (copy)
	ChromeAnalytics.default:setScreenSize((useObservableValue(ViewportUtil.screenSize)))

	if v7 then
		return React.createElement(OcclusionMetricsManager)
	end

	return nil
end

return ChromeAnalyticsListener
