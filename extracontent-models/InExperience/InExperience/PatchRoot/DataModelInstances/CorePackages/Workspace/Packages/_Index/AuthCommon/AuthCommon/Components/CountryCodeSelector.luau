local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local RoactRodux = require(AuthCommonParent.RoactRodux)
local RoactServices = require(AuthCommonParent.RoactServices).RoactServices
local RoactNetworking = require(AuthCommonParent.RoactServiceTags).RoactNetworking
local ListSearchWidget = require(AuthCommon.Components.ListSearchWidget)
local ApiFetchCountryCodes = require(AuthCommon.Thunks.ApiFetchCountryCodes)
local CountryCodeSelectorButton = require(AuthCommon.Components.CountryCodeSelectorButton)
local v10 = Roact.PureComponent:extend("CountryCodeSelector")

function v10.init(p1) -- line: 16
	p1.props.fetchCountryCodes(p1.props.networking):catch(function() -- line: 17
	end)
end
function v10.render(p2) -- line: 22
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

local v11 = RoactRodux.connect(function(p3) -- line: 33
	return {
		countryCodeList = p3.CountryCodeList
	}
end, function(p4) -- line: 37
	-- upvalues: ApiFetchCountryCodes (copy)
	return {
		fetchCountryCodes = function(p5) -- line: 39
			-- upvalues: p4 (copy), ApiFetchCountryCodes (copy)
			return p4(ApiFetchCountryCodes.Fetch(p5))
		end
	}
end)(v10)

return RoactServices.connect({
	networking = RoactNetworking
})(v11)
