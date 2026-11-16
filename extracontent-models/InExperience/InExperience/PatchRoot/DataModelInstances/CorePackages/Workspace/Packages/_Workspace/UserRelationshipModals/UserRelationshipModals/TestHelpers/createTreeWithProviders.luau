local parent = script:FindFirstAncestor("UserRelationshipModals").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RoactRodux = require(parent.RoactRodux)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local Rodux = require(parent.Rodux)

local mockLocalization = require(script.Parent.mockLocalization)

return function(component, p)
	local store

	if p == nil then
		store = Rodux.Store.new(function()
			return {
				UserRelationshipModals = { LocalUserId = 456, NetworkStatus = {} }
			}
		end, {}, { Rodux.thunkMiddleware })
	else
		store = p.store
	end

	return React.createElement(LocalizationProvider, { localization = mockLocalization }, {
		Provider = React.createElement(Foundation.FoundationProvider, {
			colorMode = "Dark",
			preferences = { reducedMotion = true }
		}, { React.createElement(RoactRodux.StoreProvider, { store = store }, {
				component = component
			}) })
	})
end
