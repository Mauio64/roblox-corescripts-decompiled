local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local React = require(AuthCommonParent.React)
local RoactNetworking = require(AuthCommonParent.RoactServiceTags).RoactNetworking
local ApiFetchCountryCodes = require(AuthCommon.Thunks.ApiFetchCountryCodes)
local CountryCodeDropdownView = require(AuthCommon.Components.InGame.CountryCodeDropdownView)
local useRoactService = require(AuthCommonParent.RobloxAppHooks).useRoactService
local RoactUtils = require(AuthCommonParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = require(AuthCommonParent.SignalsReact).useSignalState
local FFlagUseSignalsForCountryCodeList = require(AuthCommonParent.SharedFlags).FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(AuthCommon.Stores.GetCountryCodeListStore)

require(AuthCommon.Common.Types)

local function CountryCodeDropdownContainer(t1: {[any]: any}) -- line: 23
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), ApiFetchCountryCodes (copy), FFlagUseSignalsForCountryCodeList (copy), useSignalState (copy), GetCountryCodeListStore (copy), useSelector (copy), React (copy), CountryCodeDropdownView (copy)
	local v16 = useRoactService(RoactNetworking)
	local v17 = useDispatch()
	local position = t1.position
	local maxHeight = t1.maxHeight
	local dropdownVisible = t1.dropdownVisible
	local onCountryCodeSelected = t1.onCountryCodeSelected
	local v22 = if not FFlagUseSignalsForCountryCodeList then useSelector(function(p1) -- line: 37
		return p1.CountryCodeList
	end) else useSignalState(GetCountryCodeListStore(false).getCountryCodeList)

	React.useEffect(function() -- line: 41
		-- upvalues: v16 (copy), v17 (copy), ApiFetchCountryCodes (copy)
		local v25 = v16

		v17(ApiFetchCountryCodes.Fetch(v25)):catch(function() -- line: 42
		end)
	end, {})

	return React.createElement(CountryCodeDropdownView, {
		dropdownVisible = dropdownVisible,
		countryCodeList = v22,
		onCountryCodeSelected = onCountryCodeSelected,
		maxHeight = maxHeight,
		position = position
	})
end

return CountryCodeDropdownContainer
