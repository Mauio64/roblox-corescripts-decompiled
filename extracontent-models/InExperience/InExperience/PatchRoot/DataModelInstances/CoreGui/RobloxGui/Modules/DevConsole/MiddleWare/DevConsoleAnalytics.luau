local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)
local SetDevConsoleVisibility = require(script.Parent.Parent.Actions.SetDevConsoleVisibility)
local SetDevConsoleMinimized = require(script.Parent.Parent.Actions.SetDevConsoleMinimized)
local v7 = game:DefineFastInt("ReportDevConsoleTabEventsThrottleHundredthsPercent", 0)

function ReportDevConsoleOpenClose(p1, p2) -- line: 23
	-- upvalues: SetDevConsoleVisibility (copy), RbxAnalyticsService (copy)
	if p2.type == SetDevConsoleVisibility.name then
		local isVisible = p1:getState().DisplayOptions.isVisible
		local visibleStartTime = p1:getState().DisplayOptions.visibleStartTime

		if isVisible ~= p2.isVisible then
			if p2.isVisible then
				RbxAnalyticsService:ReportCounter("DevConsoleStartVisible", 1)

				return
			end

			local v12 = tick() - visibleStartTime

			RbxAnalyticsService:ReportStats("DevConsoleSessionTime", v12)
		end
	end
end
function getTabAnalyticsKeyName(p3, p4) -- line: 39
	if p4 ~= nil then
		return string.format("%s_%s", p3, not p4 and "Server" or "Client")
	end

	return string.format("%s", p3)
end
function dispatchTabAnalytics(p5) -- line: 47
	-- upvalues: Dash (copy), RbxAnalyticsService (copy), v7 (copy)
	local v16 = Dash.join({
		calledFrom = "devConsoleTabChange",
		placeId = game.PlaceId
	}, p5)

	RbxAnalyticsService:ReportInfluxSeries("devConsoleMetric", v16, v7)
end
function ReportTabChange(p6, p7) -- line: 59
	-- upvalues: SetActiveTab (copy), SetDevConsoleVisibility (copy), SetDevConsoleMinimized (copy)
	if p7.type == SetActiveTab.name then
		local MainView = p6:getState().MainView
		local newTabIndex = p7.newTabIndex
		local isClientView = p7.isClientView

		if newTabIndex ~= MainView.currTabIndex or isClientView ~= nil and isClientView ~= MainView.isClientView then
			local t1 = {
				initTab = getTabAnalyticsKeyName(MainView.currTabIndex, MainView.isClientView),
				endTab = getTabAnalyticsKeyName(newTabIndex, isClientView)
			}

			dispatchTabAnalytics(t1)

			return
		end
	else
		if p7.type == SetDevConsoleVisibility.name then
			local MainView = p6:getState().MainView
			local DisplayOptions = p6:getState().DisplayOptions
			local v25 = if not p7.isVisible then if not DisplayOptions.isMinimized then {
				endTab = "EndVisible",
				initTab = getTabAnalyticsKeyName(MainView.currTabIndex, MainView.isClientView)
			} else {
				initTab = "Minimized",
				endTab = "EndVisible"
			} else {
				initTab = "StartVisible",
				endTab = getTabAnalyticsKeyName(MainView.currTabIndex, MainView.isClientView)
			}

			dispatchTabAnalytics(v25)

			return
		end

		if p7.type == SetDevConsoleMinimized.name then
			local MainView = p6:getState().MainView
			local v27 = if not p7.isMinimized then {
				initTab = "Minimized",
				endTab = getTabAnalyticsKeyName(MainView.currTabIndex, MainView.isClientView)
			} else {
				endTab = "Minimized",
				initTab = getTabAnalyticsKeyName(MainView.currTabIndex, MainView.isClientView)
			}

			dispatchTabAnalytics(v27)
		end
	end
end

return function(p8, p9) -- line: 117
	return function(p10) -- line: 118
		-- upvalues: p9 (copy), p8 (copy)
		ReportTabChange(p9, p10)
		ReportDevConsoleOpenClose(p9, p10)
		p8(p10)
	end
end
