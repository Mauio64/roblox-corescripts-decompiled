local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags.FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(AuthCommon.Stores.GetCountryCodeListStore)

local ListSearchWidget = require(AuthCommon.Components.ListSearchWidget)
local ApiFetchCountryCodes = require(AuthCommon.Thunks.ApiFetchCountryCodes)

local CountryCodeSelectorButton = require(AuthCommon.Components.CountryCodeSelectorButton)

local extended = Roact.PureComponent:extend("CountryCodeSelector")

function extended.init(p)
	p.props.fetchCountryCodes(p.props.networking):catch(function() end)
end

function extended.render(p)
	return Roact.createElement(ListSearchWidget, {
		Heading = "Authentication.SignUp.Heading.CountryCodeSelector",
		CloseCallback = p.props.CloseCallback,
		VisibilityTarget = p.props.WidgetVisible and 1 or 0,
		List = p.props.countryCodeList,
		ListButton = CountryCodeSelectorButton,
		SelectionCallback = p.props.SelectionCallback
	})
end

local v = RoactRodux.connect(not FFlagUseSignalsForCountryCodeList and function(p)
	return { countryCodeList = p.CountryCodeList }
end or nil, function(callback)
	return {
		fetchCountryCodes = function(p)
			return callback(ApiFetchCountryCodes.Fetch(p))
		end
	}
end)(extended)
local v2

if FFlagUseSignalsForCountryCodeList then
	v2 = React.memo(function(p)
		local countryCodeList = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
		return Roact.createElement(v, Cryo.Dictionary.union(p, { countryCodeList = countryCodeList }))
	end)
else
	v2 = v
end

return roactServices.connect({ networking = RoactNetworking })(v2)
