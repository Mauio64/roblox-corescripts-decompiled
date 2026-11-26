local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactRodux")
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags").RoactNetworking
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SignalsReact").useSignalState
local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/GetCountryCodeListStore")

local ListSearchWidget = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/ListSearchWidget")
local ApiFetchCountryCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/ApiFetchCountryCodes")

local CountryCodeSelectorButton = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/CountryCodeSelectorButton")

local extended = Roact.PureComponent:extend("CountryCodeSelector")

function extended.init(p2)
	p2.props.fetchCountryCodes(p2.props.networking):catch(function() end)
end

function extended.render(p2)
	return Roact.createElement(ListSearchWidget, {
		Heading = "Authentication.SignUp.Heading.CountryCodeSelector",
		CloseCallback = p2.props.CloseCallback,
		VisibilityTarget = p2.props.WidgetVisible and 1 or 0,
		List = p2.props.countryCodeList,
		ListButton = CountryCodeSelectorButton,
		SelectionCallback = p2.props.SelectionCallback
	})
end

local v5 = RoactRodux.connect(not fFlagUseSignalsForCountryCodeList and function(p2)
	return { countryCodeList = p2.CountryCodeList }
end or nil, function(callback)
	return {
		fetchCountryCodes = function(p2)
			return callback(ApiFetchCountryCodes.Fetch(p2))
		end
	}
end)(extended)
local v6

if fFlagUseSignalsForCountryCodeList then
	v6 = React.memo(function(p2)
		local v7 = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
		return Roact.createElement(v5, Cryo.Dictionary.union(p2, {
			countryCodeList = v7
		}))
	end)
else
	v6 = v5
end

return roactServices.connect({ networking = roactNetworking })(v6)
