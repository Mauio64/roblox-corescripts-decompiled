local AmpRecourseAction = {
	Unknown = "Unknown",
	ParentConsentRecourse = "ParentConsentRecourse",
	AgeEstimationRecourse = "AgeEstimationRecourse",
	ParentLinkRecourse = "ParentLinkRecourse"
}

local set = {}

for _, v in pairs(AmpRecourseAction) do
	set[v] = true
end

function AmpRecourseAction.fromValue(p: string?)
	return if not (p == nil or not set[p]) then p else nil
end

function AmpRecourseAction.fromValues(items)
	if type(items) ~= "table" then
		return nil
	end

	local result = {}

	for _, item in items do
		local v = AmpRecourseAction.fromValue(item)

		if v == nil then
			return nil
		end

		table.insert(result, v)
	end

	return result
end

return AmpRecourseAction
