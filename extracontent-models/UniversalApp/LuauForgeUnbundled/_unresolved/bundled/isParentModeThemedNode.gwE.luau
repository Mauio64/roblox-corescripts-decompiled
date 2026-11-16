local v5 = {
	UserAgreement = true,
	AgreementConsents = true,
	PinEntry = true,
	VerificationMethodSelection = true,
	OdpAgeEstimation = true,
	OdpGovernmentId = true,
	SessionPolling = true,
	Redirect = true
}

local v6 = { NeedToReverify = true, ReverificationNotice = true }

local function isParentModeThemedNode(p2, p3): boolean
	if v5[p2] then
		return true
	end

	if p2 == "TextScreen" and p3 ~= nil then
		return v6[p3] == true
	end

	return false
end

return isParentModeThemedNode
