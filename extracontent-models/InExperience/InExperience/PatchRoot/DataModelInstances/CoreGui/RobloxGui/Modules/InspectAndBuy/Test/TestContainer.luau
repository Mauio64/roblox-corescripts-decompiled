local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local InspectAndBuyReducer = require(ParentParent.Reducers.InspectAndBuyReducer)
local Constants = require(ParentParent.Constants)
local CompactView = require(ParentParent.CompactView)
local WideView = require(ParentParent.WideView)
local renderWithCoreScriptsStyleProvider = require(ParentParentParent.Common.renderWithCoreScriptsStyleProvider)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local v13 = Roact.Component:extend("TestContainer")

function v13.init(p1) -- line: 23
	-- upvalues: Rodux (copy), InspectAndBuyReducer (copy), Constants (copy), CompactView (copy), WideView (copy)
	p1.store = p1.props.overrideStore or Rodux.Store.new(InspectAndBuyReducer, {}, { Rodux.thunkMiddleware })
	p1.views = {}
	p1.views[Constants.View.Compact] = CompactView
	p1.views[Constants.View.Wide] = WideView
end
function v13.render(p2) -- line: 33
	-- upvalues: Roact (copy), InspectAndBuyContext (copy), RoactRodux (copy), renderWithCoreScriptsStyleProvider (copy)
	local n1 = 0

	for _, _ in p2.props[Roact.Children] do
		n1 += 1
	end

	assert(n1 > 0, "TestContainer: no children provided, nothing will be tested")

	return Roact.createElement(InspectAndBuyContext.Provider, {
		value = p2.views
	}, { Roact.createElement(RoactRodux.StoreProvider, {
		store = p2.store
	}, {
		ThemeProvider = renderWithCoreScriptsStyleProvider({
			InspectMenu = Roact.createElement("ScreenGui", {}, p2.props[Roact.Children])
		})
	}) })
end

return v13
