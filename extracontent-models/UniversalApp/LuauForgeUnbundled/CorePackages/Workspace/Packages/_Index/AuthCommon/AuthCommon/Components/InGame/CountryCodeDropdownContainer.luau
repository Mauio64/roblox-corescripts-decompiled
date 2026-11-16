local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags").RoactNetworking
local ApiFetchCountryCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/ApiFetchCountryCodes")
local CountryCodeDropdownView = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/InGame/CountryCodeDropdownView")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks").useRoactService
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SignalsReact").useSignalState
local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/GetCountryCodeListStore")
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/Types")

local function CountryCodeDropdownContainer(props)
	local v5 = useRoactService(roactNetworking)
	local v6 = useDispatch()
	local position = props.position
	local maxHeight = props.maxHeight
	local dropdownVisible = props.dropdownVisible
	local onCountryCodeSelected = props.onCountryCodeSelected
	local v7

	if fFlagUseSignalsForCountryCodeList then
		v7 = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
	else
		v7 = useSelector(function(p2)
			return p2.CountryCodeList
		end)
	end

	React.useEffect(function()
		v6(ApiFetchCountryCodes.Fetch(v5)):catch(function() end)
	end, {})

	return React.createElement(CountryCodeDropdownView, {
		dropdownVisible = dropdownVisible,
		countryCodeList = v7,
		onCountryCodeSelected = onCountryCodeSelected,
		maxHeight = maxHeight,
		position = position
	})
end

return CountryCodeDropdownContainer
