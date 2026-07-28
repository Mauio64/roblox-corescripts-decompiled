local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)

return {
	pollIntervalSeconds = 30,
	quotaSummaryUrl = `{ Http.Url.APIS_URL }credit-metering-service/v1/quotaSummary`,
	dailyLimitUrl = `{ Http.Url.APIS_URL }credit-metering-service/v1/dailyLimit`
}
