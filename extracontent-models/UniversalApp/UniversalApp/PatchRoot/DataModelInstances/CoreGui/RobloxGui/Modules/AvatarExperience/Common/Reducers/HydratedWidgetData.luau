local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local UpdateLookDetailsAfterSuccessfulPurchase = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetailsAfterSuccessfulPurchase)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local RemoveLook = require(Modules.AvatarExperience.Common.Actions.RemoveLook)
local ClearReceivedCatalogData = require(Modules.AvatarExperience.Common.Actions.ClearReceivedCatalogData)
local FFlagAXFixRemoveLookOnMySharedAvatars = AvatarExperienceFlags.FFlagAXFixRemoveLookOnMySharedAvatars
local FFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

return (Rodux.createReducer({}, {
	[SetHydratedWidgetData.name] = function(t1: {[any]: any}, p1) -- line: 35
		-- upvalues: Dash (copy)
		local t2 = {}

		for v18, v19 in p1.payload do
			t2[v18] = Dash.joinDeep(t1[v18] or {}, v19)
		end

		return Dash.join(t1, t2)
	end,
	[UpdateLookDetailsAfterSuccessfulPurchase.name] = function(t3: {[any]: any}, p2) -- line: 50
		-- upvalues: WidgetConstants (copy), Dash (copy)
		local lookId = p2.lookId
		local isOwnedAfterPurchase = p2.isOwnedAfterPurchase

		if not isOwnedAfterPurchase then
			return t3
		end

		local Look = WidgetConstants.ContentType.Look
		local v25 = t3[Look] or {}
		local v26 = v25[lookId] or {}
		local v27 = Dash.join(v26, {
			owned = isOwnedAfterPurchase
		})
		local v28 = Dash.join(v25, {
			[lookId] = v27
		})

		return (Dash.join(t3, {
			[Look] = v28
		}))
	end,
	[ClearReceivedCatalogData.name] = if not FFlagAXSubscriptionRefetchEvictStores then nil else function(t4: {[any]: any}) -- line: 78
		if next(t4) == nil then
			return t4
		end

		return {}
	end,
	[RemoveLook.name] = function(t5: {[any]: any}, p3) -- line: 95
		-- upvalues: WidgetConstants (copy), FFlagAXFixRemoveLookOnMySharedAvatars (copy), Dash (copy), Cryo (copy)
		local lookId = p3.lookId
		local Look = WidgetConstants.ContentType.Look
		local v34 = t5[Look] or {}
		local v35

		if FFlagAXFixRemoveLookOnMySharedAvatars then
			v35 = table.clone(v34)
			v35[lookId] = nil
		else
			v35 = Dash.join(v34, {
				[lookId] = Cryo.None
			})
		end

		return (Dash.join(t5, {
			[Look] = v35
		}))
	end
}))
