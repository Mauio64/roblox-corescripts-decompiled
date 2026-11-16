local SetCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Actions/SetCountryCodeList")

return function(options, p2)
	local v5 = options or {}
	assert(v5, "")

	if p2.type == SetCountryCodeList.name then
		v5 = p2.countryCodeList
	end

	return v5
end
