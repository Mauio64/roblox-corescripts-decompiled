require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/creatorApiHttp")

return {
	ProductStatusType = {
		Inactive = 1,
		Active = 2,
		ToBeActivated = 3,
		ToBeDeactivated = 4,
		ToBeDeleted = 5,
		Deleted = 6,
		OffSale = 7
	},
	DeveloperSubscriptionProductType = { Consumable = 1, Currency = 2, Durable = 3 },
	CurrencyType = { Robux = 1, Fiat = 2 }
}
