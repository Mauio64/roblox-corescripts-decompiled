local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Rodux = require(AuthCommonParent.Rodux)
local CountryCodeList = require(AuthCommon.Reducers.CountryCodeList)

return function() -- line: 8
	-- upvalues: Rodux (copy), CountryCodeList (copy)
	return Rodux.combineReducers({
		CountryCodeList = CountryCodeList
	})
end
