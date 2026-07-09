local CountryCode = script:FindFirstAncestor("CountryCode")
local CountryCodeParent = CountryCode.Parent
local Rodux = require(CountryCodeParent.Rodux)
local ReceivedUserCountryCode = require(CountryCode.Actions.ReceivedUserCountryCode)

return Rodux.createReducer("", {
	[ReceivedUserCountryCode.name] = function(_, p2) -- line: 10
		return p2.countryCode
	end
})
