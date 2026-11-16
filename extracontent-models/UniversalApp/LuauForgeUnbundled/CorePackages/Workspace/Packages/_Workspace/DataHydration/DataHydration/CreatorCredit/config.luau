local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

return {
	pollIntervalSeconds = 30,
	quotaSummaryUrl = `{module.Url.APIS_URL}credit-metering-service/v1/quotaSummary`,
	dailyLimitUrl = `{module.Url.APIS_URL}credit-metering-service/v1/dailyLimit`
}
