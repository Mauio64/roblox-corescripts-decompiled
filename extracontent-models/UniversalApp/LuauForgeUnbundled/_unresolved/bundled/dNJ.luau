local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local Rodux = require(CorePackages.Packages.Rodux)
local Dash = require(CorePackages.Packages.Dash)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/bundled/dHL")

local module4 = require("@luauforge/bundled/dMP")

local module5 = require("@luauforge/bundled/dMg")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local removeLook = module3.Actions.RemoveLook
local module6 = require("@luauforge/bundled/dNd")

local fFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

return (Rodux.createReducer({}, {
	[module4.name] = function(p2, p3)
		local v6 = {}

		for k, v7 in p3.payload do
			v6[k] = Dash.joinDeep(p2[k] or {}, v7)
		end

		return Dash.join(p2, v6)
	end,
	[module5.name] = function(p2, p3)
		local lookId = p3.lookId
		local isOwnedAfterPurchase = p3.isOwnedAfterPurchase

		if not isOwnedAfterPurchase then
			return p2
		end

		local look = widgetConstants.ContentType.Look
		local v6 = p2[look] or {}
		local v7 = v6[lookId] or {}

		local joined = Dash.join(v7, { owned = isOwnedAfterPurchase })

		local joined2 = Dash.join(v6, { [lookId] = joined })

		return (Dash.join(p2, { [look] = joined2 }))
	end,
	[module6.name] = fFlagAXSubscriptionRefetchEvictStores and function(items)
		if next(items) == nil then
			return items
		end

		return {}
	end or nil,
	[removeLook.name] = function(p2, p3)
		local lookId = p3.lookId
		local look = widgetConstants.ContentType.Look
		local v6 = p2[look] or {}
		local clone = table.clone(v6)
		clone[lookId] = nil
		return (Dash.join(p2, { [look] = clone }))
	end
}))
