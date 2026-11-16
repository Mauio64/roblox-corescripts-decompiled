local v5 = {
	Unknown = "Unknown",
	Eligible = "Eligible",
	IneligibleGiftingSystemDisabled = "IneligibleGiftingSystemDisabled",
	IneligibleLegalOrRegulatoryRestrictions = "IneligibleLegalOrRegulatoryRestrictions",
	IneligiblePermanentlyBanned = "IneligiblePermanentlyBanned",
	IneligibleTemporarilySuspended = "IneligibleTemporarilySuspended"
}

local set = {}

for k, v6 in pairs(v5) do
	set[v6] = true
end

function v5.fromValue(p2)
	if p2 == nil or not set[p2] then
		return nil
	end

	return p2
end

return v5
