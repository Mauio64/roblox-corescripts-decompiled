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

require(AuthCommon.Common.Types)

local function CountryCodeDropdownContainer(t1: {[any]: any}) -- line: 20
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), ApiFetchCountryCodes (copy), useSelector (copy), React (copy), CountryCodeDropdownView (copy)
	local v13 = useRoactService(RoactNetworking)
	local v14 = useDispatch()
	local position = t1.position
	local maxHeight = t1.maxHeight
	local dropdownVisible = t1.dropdownVisible
	local onCountryCodeSelected = t1.onCountryCodeSelected
	local v19 = useSelector(function(p1) -- line: 32
		return p1.CountryCodeList
	end)

	React.useEffect(function() -- line: 36
		-- upvalues: v13 (copy), v14 (copy), ApiFetchCountryCodes (copy)
		local v22 = v13

		v14(ApiFetchCountryCodes.Fetch(v22)):catch(function() -- line: 37
		end)
	end, {})

	return React.createElement(CountryCodeDropdownView, {
		dropdownVisible = dropdownVisible,
		countryCodeList = v19,
		onCountryCodeSelected = onCountryCodeSelected,
		maxHeight = maxHeight,
		position = position
	})
end

return CountryCodeDropdownContainer
