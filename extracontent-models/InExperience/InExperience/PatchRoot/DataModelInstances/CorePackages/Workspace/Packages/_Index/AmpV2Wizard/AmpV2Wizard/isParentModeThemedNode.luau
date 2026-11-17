local v = {
	UserAgreement = true,
	AgreementConsents = true,
	PinEntry = true,
	VerificationMethodSelection = true,
	OdpAgeEstimation = true,
	OdpGovernmentId = true,
	SessionPolling = true,
	Redirect = true
}

local v2 = { NeedToReverify = true, ReverificationNotice = true }

local function isParentModeThemedNode(p: string, p2: string?): boolean
	if v[p] then
		return true
	end

	return p == "TextScreen" and p2 ~= nil and v2[p2] == true
end

return isParentModeThemedNode
