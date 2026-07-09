local Parent = script:FindFirstAncestor("AuthCommon").Parent
local FFlagRemoveUnusedLoginResultRoduxSlice = require(Parent.SharedFlags).FFlagRemoveUnusedLoginResultRoduxSlice

return {
	SetCountryCodeList = require(script.SetCountryCodeList),
	SetLoginResult = if FFlagRemoveUnusedLoginResultRoduxSlice then nil else require(script.SetLoginResult),
	SetBackNavigationDisabled = require(script.SetBackNavigationDisabled)
}
