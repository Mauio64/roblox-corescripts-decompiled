local module = require("@luauforge/deferred/fvb")

local function doHash(p2, p3)
	return tostring(p2) .. "." .. tostring(p3)
end
local v5 = {
	[tostring(nil) .. "." .. tostring("PriceChangedView")] = module.UnknownFailure,
	[tostring("Membership Level Too Low") .. "." .. tostring("TransactionFailureView")] = module.UnknownFailure,
	[tostring("Purchases are Currently Disabled") .. "." .. tostring("TransactionFailureView")] = module.PurchaseDisabled,
	[tostring("Item Not For Sale") .. "." .. tostring("TransactionFailureView")] = module.NotForSale,
	[tostring("Age Restricted Item") .. "." .. tostring("TransactionFailureView")] = module.Under13,
	[tostring("Item Owned") .. "." .. tostring("TransactionFailureView")] = module.AlreadyOwn,
	[tostring("Too Many Purchases") .. "." .. tostring("TransactionFailureView")] = module.TooManyPurchases,
	[tostring("Invalid Parameter") .. "." .. tostring("TransactionFailureView")] = module.InvalidRequest,
	[tostring("Unauthorized") .. "." .. tostring("TransactionFailureView")] = module.Unauthorized
}

local function getErrorTypeFromTitleAndShowDivId(p2, p3)
	return v5[tostring(p2) .. "." .. tostring(p3)]
end

local function getPurchaseErrorTypeFromErrorResponse(data)
	local v6 = data ~= nil and type(data) == "table"
	assert(v6, "err must be a valid table!")

	local title = data.title
	local showDivId = data.showDivId
	local shortfallPrice = data.shortfallPrice

	if
		(showDivId == "TransactionFailureView" or showDivId == "InsufficientFundsView")
		and shortfallPrice ~= nil
		and shortfallPrice > 0
	then
		return module.NotEnoughRobux
	end

	return v5[tostring(title) .. "." .. tostring(showDivId)] or module.UnknownFailure
end

return getPurchaseErrorTypeFromErrorResponse
