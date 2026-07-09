local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.SetWidgetInfo)
local ClearWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.ClearWidgetInfo)
local RemoveWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.RemoveWidgetInfo)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

return (Rodux.createReducer({}, {
	[SetWidgetInfo.name] = function(t1: {[any]: any}, p1) -- line: 34
		-- upvalues: Cryo (copy)
		if not p1.query then
			return t1
		end

		local t2 = {
			Details = p1.widgetInfo,
			RequestId = p1.requestId,
			FetchTime = tick(),
			Configuration = p1.configuration
		}

		return Cryo.Dictionary.join(t1, {
			[p1.query] = t2
		})
	end,
	[ClearWidgetInfo.name] = function(t3: {[any]: any}, p2) -- line: 48
		-- upvalues: Cryo (copy)
		if not p2.query then
			return t3
		end

		return Cryo.Dictionary.join(t3, {
			[p2.query] = Cryo.None
		})
	end,
	[RemoveWidgetInfo.name] = function(p3, p4) -- line: 56
		-- upvalues: Cryo (copy)
		local widgetId = p4.widgetId
		local t4 = {}

		for v17, v18 in p3 do
			local t5 = {}

			for v20, v21 in v18.Details do
				if widgetId == v21.id then
					t5[v20] = Cryo.None
				end
			end

			t4[v17] = Cryo.Dictionary.join(v18, {
				Details = Cryo.Dictionary.join(v18.Details, t5)
			})
		end

		return t4
	end
}))
