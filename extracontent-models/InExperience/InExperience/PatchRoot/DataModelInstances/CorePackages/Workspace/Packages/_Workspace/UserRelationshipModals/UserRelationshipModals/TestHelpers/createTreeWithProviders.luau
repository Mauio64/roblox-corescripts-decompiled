local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local RoactRodux = require(Parent.RoactRodux)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local Rodux = require(Parent.Rodux)
local mockLocalization = require(script.Parent.mockLocalization)

return function(p1, t1: {[any]: any}?) -- line: 12
	-- upvalues: Rodux (copy), React (copy), LocalizationProvider (copy), mockLocalization (copy), Foundation (copy), RoactRodux (copy)
	local v10 = if t1 == nil then Rodux.Store.new(function() -- line: 15
		return {
			UserRelationshipModals = {
				LocalUserId = 456,
				NetworkStatus = {}
			}
		}
	end, {}, { Rodux.thunkMiddleware }) else t1.store

	return React.createElement(LocalizationProvider, {
		localization = mockLocalization
	}, {
		Provider = React.createElement(Foundation.FoundationProvider, {
			theme = "Dark",
			preferences = {
				reducedMotion = true
			}
		}, { React.createElement(RoactRodux.StoreProvider, {
			store = v10
		}, {
			component = p1
		}) })
	})
end
