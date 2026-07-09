local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.SetWidgetInfo)
local ClearWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.ClearWidgetInfo)
local RemoveWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.RemoveWidgetInfo)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local t1 = {
	RequestId = nil,
	FetchTime = nil,
	Configuration = nil,
	Details = {}
}

return (Rodux.createReducer(t1, {
	[SetWidgetInfo.name] = function(t2: {[any]: any}, p1) -- line: 37
		if p1.query or p1.context then
			return t2
		end

		return {
			Details = p1.widgetInfo,
			RequestId = p1.requestId,
			FetchTime = tick(),
			Configuration = p1.configuration
		}
	end,
	[ClearWidgetInfo.name] = function(t3: {[any]: any}, p2) -- line: 50
		if p2.query or p2.context then
			return t3
		end

		return {
			Details = {}
		}
	end,
	[RemoveWidgetInfo.name] = function(t4: {[any]: any}, p3) -- line: 60
		-- upvalues: Cryo (copy)
		local widgetId = p3.widgetId
		local t5 = {}

		for v17, v18 in t4.Details do
			if widgetId == v18.id then
				t5[v17] = Cryo.None
			end
		end

		return Cryo.Dictionary.join(t4, {
			Details = Cryo.Dictionary.join(t4.Details, t5)
		})
	end
}))
