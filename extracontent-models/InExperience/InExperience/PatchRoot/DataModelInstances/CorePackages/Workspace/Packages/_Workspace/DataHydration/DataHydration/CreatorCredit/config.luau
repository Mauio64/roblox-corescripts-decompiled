local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)

return {
	pollIntervalSeconds = 30,
	quotaSummaryUrl = `{Http.Url.APIS_URL}credit-metering-service/v1/quotaSummary`,
	dailyLimitUrl = `{Http.Url.APIS_URL}credit-metering-service/v1/dailyLimit`
}
