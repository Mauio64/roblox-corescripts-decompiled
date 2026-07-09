local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local WidgetInfo = require(Modules.AvatarExperience.Common.Reducers.WidgetInfo)
local HydratedWidgetData = require(Modules.AvatarExperience.Common.Reducers.HydratedWidgetData)
local SearchPageWidgetInfo = require(Modules.AvatarExperience.Common.Reducers.SearchPageWidgetInfo)
local ContextWidgetInfo = require(Modules.AvatarExperience.Common.Reducers.ContextWidgetInfo)

return Rodux.combineReducers({
	WidgetInfo = WidgetInfo,
	SearchPageWidgetInfo = SearchPageWidgetInfo,
	ContextWidgetInfo = ContextWidgetInfo,
	HydratedWidgetData = HydratedWidgetData
})
