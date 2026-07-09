local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local DevSubStatus = require(Modules.LuaApp.Enum.DevSubStatus)
local DevSubPlanStatus = require(Modules.LuaApp.Enum.DevSubPlanStatus)
local v6 = t.union(t.literal(DevSubPlanStatus.Open), t.literal(DevSubPlanStatus.Closed), t.literal(DevSubPlanStatus.Archived))
local v7 = t.strictInterface({
	id = t.number,
	universeId = t.number,
	imageAssetId = t.number,
	status = v6,
	name = t.string,
	description = t.string,
	priceInRobux = t.number,
	renewalPeriod = t.literal("Monthly"),
	created = t.string,
	updated = t.string
})
local v8 = t.strictInterface({
	id = t.number,
	name = t.string
})
local v9 = t.union(t.literal(DevSubStatus.Active), t.literal(DevSubStatus.Inactive))
local v10 = t.strictInterface({
	id = t.string,
	planId = t.number,
	userId = t.number,
	status = v9,
	isAutoRenewing = t.boolean,
	startDate = t.string,
	expirationDate = t.string
})
local v11 = t.strictInterface({
	data = t.array(v10),
	auxiliaryData = t.strictInterface({
		plans = t.map(t.string, v7),
		universes = t.map(t.string, v8)
	}),
	previousPageCursor = t.optional(t.string),
	nextPageCursor = t.optional(t.string)
})
local v12 = t.interface({
	id = t.string,
	status = v9,
	isAutoRenewing = t.boolean,
	expirationDate = t.string,
	planData = v7,
	gameData = v8
})

return {
	PlanCheck = v7,
	PlanStatusCheck = v6,
	UniverseCheck = v8,
	SubscriptionCheck = v10,
	SubscriptionStatusCheck = v9,
	SubscriptionsResponseCheck = v11,
	DevSubJsonCheck = v12
}
