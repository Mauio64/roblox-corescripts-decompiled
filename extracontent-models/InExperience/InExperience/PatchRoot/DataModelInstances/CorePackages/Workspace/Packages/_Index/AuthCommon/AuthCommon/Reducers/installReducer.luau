local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Rodux = require(parent.Rodux)

local CountryCodeList = require(AuthCommon.Reducers.CountryCodeList)

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags.FFlagUseSignalsForCountryCodeList

return function()
	local combineReducers = Rodux.combineReducers
	local countryCodeList

	if not FFlagUseSignalsForCountryCodeList then
		countryCodeList = CountryCodeList
	end

	return combineReducers({ CountryCodeList = countryCodeList })
end
