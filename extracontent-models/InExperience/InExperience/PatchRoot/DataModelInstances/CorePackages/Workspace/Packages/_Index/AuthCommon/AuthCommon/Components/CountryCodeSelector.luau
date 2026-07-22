local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local React = require(AuthCommonParent.React)
local RoactRodux = require(AuthCommonParent.RoactRodux)
local RoactServices = require(AuthCommonParent.RoactServices).RoactServices
local RoactNetworking = require(AuthCommonParent.RoactServiceTags).RoactNetworking
local Cryo = require(AuthCommonParent.Cryo)
local useSignalState = require(AuthCommonParent.SignalsReact).useSignalState
local FFlagUseSignalsForCountryCodeList = require(AuthCommonParent.SharedFlags).FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(AuthCommon.Stores.GetCountryCodeListStore)
local ListSearchWidget = require(AuthCommon.Components.ListSearchWidget)
local ApiFetchCountryCodes = require(AuthCommon.Thunks.ApiFetchCountryCodes)
local CountryCodeSelectorButton = require(AuthCommon.Components.CountryCodeSelectorButton)
local v15 = Roact.PureComponent:extend("CountryCodeSelector")

function v15.init(p1) -- line: 21
	p1.props.fetchCountryCodes(p1.props.networking):catch(function() -- line: 22
	end)
end
function v15.render(p2) -- line: 27
	-- upvalues: Roact (copy), ListSearchWidget (copy), CountryCodeSelectorButton (copy)
	return Roact.createElement(ListSearchWidget, {
		Heading = "Authentication.SignUp.Heading.CountryCodeSelector",
		CloseCallback = p2.props.CloseCallback,
		VisibilityTarget = not p2.props.WidgetVisible and 0 or 1,
		List = p2.props.countryCodeList,
		ListButton = CountryCodeSelectorButton,
		SelectionCallback = p2.props.SelectionCallback
	})
end

local v16 = RoactRodux.connect(not FFlagUseSignalsForCountryCodeList and function(p3) -- line: 41
	return {
		countryCodeList = p3.CountryCodeList
	}
end or nil, function(p4) -- line: 46
	-- upvalues: ApiFetchCountryCodes (copy)
	return {
		fetchCountryCodes = function(p5) -- line: 48
			-- upvalues: p4 (copy), ApiFetchCountryCodes (copy)
			return p4(ApiFetchCountryCodes.Fetch(p5))
		end
	}
end)(v15)

if FFlagUseSignalsForCountryCodeList then
	local v17 = v16

	v16 = React.memo(function(p6) -- line: 57
		-- upvalues: useSignalState (copy), GetCountryCodeListStore (copy), Roact (copy), v17 (copy), Cryo (copy)
		local v23 = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)

		return Roact.createElement(v17, Cryo.Dictionary.union(p6, {
			countryCodeList = v23
		}))
	end)
end

return RoactServices.connect({
	networking = RoactNetworking
})(v16)
