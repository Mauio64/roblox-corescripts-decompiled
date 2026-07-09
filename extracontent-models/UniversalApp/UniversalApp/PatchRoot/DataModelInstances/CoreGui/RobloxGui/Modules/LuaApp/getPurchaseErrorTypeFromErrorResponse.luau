local PurchaseErrors = require(script.Parent.Enum.PurchaseErrors)

local function doHash(p1, p2) -- line: 3
	return tostring(p1) .. "." .. tostring(p2)
end

local t1 = {
	[tostring(nil) .. "." .. tostring("PriceChangedView")] = PurchaseErrors.UnknownFailure,
	[tostring("Membership Level Too Low") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.UnknownFailure,
	[tostring("Purchases are Currently Disabled") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.PurchaseDisabled,
	[tostring("Item Not For Sale") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.NotForSale,
	[tostring("Age Restricted Item") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.Under13,
	[tostring("Item Owned") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.AlreadyOwn,
	[tostring("Too Many Purchases") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.TooManyPurchases,
	[tostring("Invalid Parameter") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.InvalidRequest,
	[tostring("Unauthorized") .. "." .. tostring("TransactionFailureView")] = PurchaseErrors.Unauthorized
}

local function getErrorTypeFromTitleAndShowDivId(p3, p4) -- line: 21
	-- upvalues: t1 (copy)
	return t1[tostring(p3) .. "." .. tostring(p4)]
end
local function getPurchaseErrorTypeFromErrorResponse(p5) -- line: 25
	-- upvalues: PurchaseErrors (copy), t1 (copy)
	assert(p5 ~= nil and type(p5) == "table", "err must be a valid table!")

	local title = p5.title
	local showDivId = p5.showDivId
	local shortfallPrice = p5.shortfallPrice

	if (showDivId == "TransactionFailureView" or showDivId == "InsufficientFundsView") and (shortfallPrice ~= nil and shortfallPrice > 0) then
		return PurchaseErrors.NotEnoughRobux
	end

	return t1[tostring(title) .. "." .. tostring(showDivId)] or PurchaseErrors.UnknownFailure
end

return getPurchaseErrorTypeFromErrorResponse
