local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SetWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.SetWidgetInfo)
local ClearWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.ClearWidgetInfo)
local RemoveWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.RemoveWidgetInfo)
local RemoveLook = require(Modules.AvatarExperience.Common.Actions.RemoveLook)
local ReceivedRecentlyViewedItemsData = require(Modules.AvatarExperience.Catalog.Actions.ReceivedRecentlyViewedItemsData)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local FFlagAXFixRemoveLookOnMySharedAvatars = AvatarExperienceFlags.FFlagAXFixRemoveLookOnMySharedAvatars

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

return (Rodux.createReducer({}, {
	[SetWidgetInfo.name] = function(t1: {[any]: any}, p1) -- line: 42
		-- upvalues: Cryo (copy)
		if not p1.context then
			return t1
		end

		local t2 = {
			Details = p1.widgetInfo,
			RequestId = p1.requestId,
			FetchTime = tick(),
			Configuration = p1.configuration
		}

		return Cryo.Dictionary.join(t1, {
			[p1.context] = t2
		})
	end,
	[ClearWidgetInfo.name] = function(t3: {[any]: any}, p2) -- line: 56
		-- upvalues: Cryo (copy)
		if not p2.context then
			return t3
		end

		return Cryo.Dictionary.join(t3, {
			[p2.context] = Cryo.None
		})
	end,
	[RemoveWidgetInfo.name] = function(p3, p4) -- line: 64
		-- upvalues: Cryo (copy)
		local widgetId = p4.widgetId
		local t4 = {}

		for v23, v24 in p3 do
			local t5 = {}

			for v26, v27 in v24.Details do
				if widgetId == v27.id then
					t5[v26] = Cryo.None
				end
			end

			t4[v23] = Cryo.Dictionary.join(v24, {
				Details = Cryo.Dictionary.join(v24.Details, t5)
			})
		end

		return t4
	end,
	[RemoveLook.name] = function(t6: {[any]: any}, p5) -- line: 84
		-- upvalues: Cryo (copy), FFlagAXFixRemoveLookOnMySharedAvatars (copy)
		local v30 = table.clone(t6)

		for k, v in pairs(t6) do
			local t7 = {}

			for k2, v2 in pairs(v.Details) do
				if v2.content then
					local t8 = {}

					for _, v38 in v2.content do
						if v38.id ~= p5.lookId then
							table.insert(t8, v38)
						end
					end

					t7[k2] = Cryo.Dictionary.join(v2, {
						content = t8
					})
				end
			end

			if FFlagAXFixRemoveLookOnMySharedAvatars then
				v30[k] = Cryo.Dictionary.join(v, {
					Details = t7
				})
			else
				v30[k].Details = Cryo.Dictionary.join(v.Details, t7)
			end
		end

		return v30
	end,
	[ReceivedRecentlyViewedItemsData.name] = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else function(t9: {[any]: any}, p6) -- line: 116
		-- upvalues: Cryo (copy)
		local widget = p6.widget
		local t10 = {
			Details = widget.widgetInfo,
			RequestId = widget.requestId,
			FetchTime = tick()
		}

		return Cryo.Dictionary.join(t9, {
			[widget.context] = t10
		})
	end
}))
