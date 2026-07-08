local AuthCommon = script:FindFirstAncestor("AuthCommon")
local SetCountryCodeList = require(AuthCommon.Actions.SetCountryCodeList)

return function(t1: {[any]: any}?, p1) -- line: 13
	-- upvalues: SetCountryCodeList (copy)
	local v5 = t1 or {}

	assert(v5, "")

	if p1.type == SetCountryCodeList.name then
		v5 = p1.countryCodeList
	end

	return v5
end
