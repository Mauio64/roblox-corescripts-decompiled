local GiftEligibility = {
	Unknown = "Unknown",
	Eligible = "Eligible",
	IneligibleGiftingSystemDisabled = "IneligibleGiftingSystemDisabled",
	IneligibleLegalOrRegulatoryRestrictions = "IneligibleLegalOrRegulatoryRestrictions",
	IneligiblePermanentlyBanned = "IneligiblePermanentlyBanned",
	IneligibleTemporarilySuspended = "IneligibleTemporarilySuspended"
}

local set = {}

for _, v in pairs(GiftEligibility) do
	set[v] = true
end

function GiftEligibility.fromValue(p: string?)
	return if not (p == nil or not set[p]) then p else nil
end

return GiftEligibility
