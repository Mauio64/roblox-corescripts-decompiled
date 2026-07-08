local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local common = require(script.common)
local displayOptions = require(script.displayOptions)
local placeInfo = require(script.placeInfo)
local report = require(script.report)

return (Rodux.combineReducers({
	common = common,
	displayOptions = displayOptions,
	placeInfo = placeInfo,
	report = report
}))
