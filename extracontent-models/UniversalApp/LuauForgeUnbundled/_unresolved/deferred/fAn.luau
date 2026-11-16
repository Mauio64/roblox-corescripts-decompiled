local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/deferred/fAj")
local module2 = require("@luauforge/deferred/fAo")

local union = t.union(t.literal(module2.Open), t.literal(module2.Closed), t.literal(module2.Archived))

local strictInterface = t.strictInterface({
	id = t.number,
	universeId = t.number,
	imageAssetId = t.number,
	status = union,
	name = t.string,
	description = t.string,
	priceInRobux = t.number,
	renewalPeriod = t.literal("Monthly"),
	created = t.string,
	updated = t.string
})

local strictInterface2 = t.strictInterface({ id = t.number, name = t.string })

local union2 = t.union(t.literal(module.Active), t.literal(module.Inactive))

local strictInterface3 = t.strictInterface({
	id = t.string,
	planId = t.number,
	userId = t.number,
	status = union2,
	isAutoRenewing = t.boolean,
	startDate = t.string,
	expirationDate = t.string
})

return {
	PlanCheck = strictInterface,
	PlanStatusCheck = union,
	UniverseCheck = strictInterface2,
	SubscriptionCheck = strictInterface3,
	SubscriptionStatusCheck = union2,
	SubscriptionsResponseCheck = t.strictInterface({
		data = t.array(strictInterface3),
		auxiliaryData = t.strictInterface({
			plans = t.map(t.string, strictInterface),
			universes = t.map(t.string, strictInterface2)
		}),
		previousPageCursor = t.optional(t.string),
		nextPageCursor = t.optional(t.string)
	}),
	DevSubJsonCheck = t.interface({
		id = t.string,
		status = union2,
		isAutoRenewing = t.boolean,
		expirationDate = t.string,
		planData = strictInterface,
		gameData = strictInterface2
	})
}
