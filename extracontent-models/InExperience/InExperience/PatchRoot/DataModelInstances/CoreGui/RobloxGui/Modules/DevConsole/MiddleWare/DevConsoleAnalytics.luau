local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)

local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)
local SetDevConsoleVisibility = require(script.Parent.Parent.Actions.SetDevConsoleVisibility)
local SetDevConsoleMinimized = require(script.Parent.Parent.Actions.SetDevConsoleMinimized)

local defineFastInt = game:DefineFastInt("ReportDevConsoleTabEventsThrottleHundredthsPercent", 0)

function ReportDevConsoleOpenClose(object, p)
	if p.type == SetDevConsoleVisibility.name then
		local isVisible = object:getState().DisplayOptions.isVisible
		local visibleStartTime = object:getState().DisplayOptions.visibleStartTime

		if p.isVisible ~= isVisible then
			if p.isVisible then
				RbxAnalyticsService:ReportCounter("DevConsoleStartVisible", 1)
			else
				RbxAnalyticsService:ReportStats("DevConsoleSessionTime", tick() - visibleStartTime)
			end
		end
	end
end

function getTabAnalyticsKeyName(p, p2)
	if p2 == nil then
		return string.format("%s", p)
	end

	return string.format("%s_%s", p, p2 and "Client" or "Server")
end

function dispatchTabAnalytics(p)
	RbxAnalyticsService:ReportInfluxSeries(
		"devConsoleMetric",
		Dash.join({ placeId = game.PlaceId, calledFrom = "devConsoleTabChange" }, p),
		defineFastInt
	)
end

function ReportTabChange(object, data)
	if data.type == SetActiveTab.name then
		local mainView = object:getState().MainView

		local newTabIndex = data.newTabIndex
		local isClientView = data.isClientView

		if newTabIndex ~= mainView.currTabIndex or isClientView ~= nil and isClientView ~= mainView.isClientView then
			local v = {
				initTab = getTabAnalyticsKeyName(mainView.currTabIndex, mainView.isClientView),
				endTab = getTabAnalyticsKeyName(newTabIndex, isClientView)
			}

			dispatchTabAnalytics(v)
		end
	elseif data.type == SetDevConsoleVisibility.name then
		local mainView = object:getState().MainView
		local displayOptions = object:getState().DisplayOptions
		local v

		if data.isVisible then
			v = {
				initTab = "StartVisible",
				endTab = getTabAnalyticsKeyName(mainView.currTabIndex, mainView.isClientView)
			}
		else
			v = displayOptions.isMinimized and { initTab = "Minimized", endTab = "EndVisible" }
				or {
					initTab = getTabAnalyticsKeyName(mainView.currTabIndex, mainView.isClientView),
					endTab = "EndVisible"
				}
		end

		dispatchTabAnalytics(v)
	elseif data.type == SetDevConsoleMinimized.name then
		local mainView = object:getState().MainView
		local v

		if data.isMinimized then
			v = {
				initTab = getTabAnalyticsKeyName(mainView.currTabIndex, mainView.isClientView),
				endTab = "Minimized"
			}
		else
			v = {
				initTab = "Minimized",
				endTab = getTabAnalyticsKeyName(mainView.currTabIndex, mainView.isClientView)
			}
		end

		dispatchTabAnalytics(v)
	end
end

return function(callback, p)
	return function(p2)
		ReportTabChange(p, p2)
		ReportDevConsoleOpenClose(p, p2)
		callback(p2)
	end
end
