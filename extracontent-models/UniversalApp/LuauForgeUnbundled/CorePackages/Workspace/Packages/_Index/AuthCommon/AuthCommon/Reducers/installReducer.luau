local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Rodux")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Reducers/CountryCodeList")

local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagUseSignalsForCountryCodeList

return function()
	return Rodux.combineReducers({
		CountryCodeList = if not fFlagUseSignalsForCountryCodeList then module2 else nil
	})
end
