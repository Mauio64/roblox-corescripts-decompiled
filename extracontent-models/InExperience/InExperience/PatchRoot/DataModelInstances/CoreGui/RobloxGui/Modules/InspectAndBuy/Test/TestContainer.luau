local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent
local parent2 = parent.Parent
local InspectAndBuyReducer = require(parent.Reducers.InspectAndBuyReducer)
local Constants = require(parent.Constants)
local CompactView = require(parent.CompactView)
local WideView = require(parent.WideView)
local renderWithCoreScriptsStyleProvider = require(parent2.Common.renderWithCoreScriptsStyleProvider)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)

local extended = Roact.Component:extend("TestContainer")

function extended:init()
	self.store = self.props.overrideStore or Rodux.Store.new(InspectAndBuyReducer, {}, { Rodux.thunkMiddleware })

	self.views = {}
	self.views[Constants.View.Compact] = CompactView
	self.views[Constants.View.Wide] = WideView
end

function extended.render(props)
	local count = 0

	for _, _ in props.props[Roact.Children] do
		count += 1
	end

	assert(count > 0, "TestContainer: no children provided, nothing will be tested")

	return Roact.createElement(InspectAndBuyContext.Provider, { value = props.views }, {
		Roact.createElement(RoactRodux.StoreProvider, { store = props.store }, {
			ThemeProvider = renderWithCoreScriptsStyleProvider({
				InspectMenu = Roact.createElement("ScreenGui", {}, props.props[Roact.Children])
			})
		})
	})
end

return extended
