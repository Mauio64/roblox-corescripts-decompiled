local AuthCommon = script:FindFirstAncestor("AuthCommon")
local SetCountryCodeList = require(AuthCommon.Actions.SetCountryCodeList)

return function(options, p)
	local v = options or {}
	assert(v, "")

	if p.type == SetCountryCodeList.name then
		return p.countryCodeList
	end

	return v
end
