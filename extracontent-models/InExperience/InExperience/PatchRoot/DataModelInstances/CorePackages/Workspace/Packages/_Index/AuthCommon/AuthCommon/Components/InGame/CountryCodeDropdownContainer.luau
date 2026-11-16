local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local ApiFetchCountryCodes = require(AuthCommon.Thunks.ApiFetchCountryCodes)
local CountryCodeDropdownView = require(AuthCommon.Components.InGame.CountryCodeDropdownView)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags.FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(AuthCommon.Stores.GetCountryCodeListStore)
require(AuthCommon.Common.Types)

local function CountryCodeDropdownContainer(props)
	local v = useRoactService(RoactNetworking)
	local v2 = useDispatch()
	local position = props.position
	local maxHeight = props.maxHeight
	local dropdownVisible = props.dropdownVisible
	local onCountryCodeSelected = props.onCountryCodeSelected
	local countryCodeList

	if FFlagUseSignalsForCountryCodeList then
		countryCodeList = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
	else
		countryCodeList = useSelector(function(p)
			return p.CountryCodeList
		end)
	end

	local function fn(p) -- 1 equivalent call inferred from this helper
		return v2(ApiFetchCountryCodes.Fetch(p))
	end

	React.useEffect(function()
		fn(v):catch(function() end) -- inferred equivalent call
	end, {})

	return React.createElement(CountryCodeDropdownView, {
		dropdownVisible = dropdownVisible,
		countryCodeList = countryCodeList,
		onCountryCodeSelected = onCountryCodeSelected,
		maxHeight = maxHeight,
		position = position
	})
end

return CountryCodeDropdownContainer
