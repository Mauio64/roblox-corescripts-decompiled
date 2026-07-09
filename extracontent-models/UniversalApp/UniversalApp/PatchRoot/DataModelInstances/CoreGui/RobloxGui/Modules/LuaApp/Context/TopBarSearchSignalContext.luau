local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Signal = require(Modules.Common.Signal)
local v6 = Roact.Component:extend("TopBarSearchSignalProvider")
local v7 = Roact.createContext(nil)
local FFlagAXMigrateCatalogPageInputBindings = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateCatalogPageInputBindings

function v6.init(p1) -- line: 15
	-- upvalues: Signal (copy)
	p1.signal = Signal.new()
end
function v6.render(p2) -- line: 19
	-- upvalues: Roact (copy), v7 (copy)
	return Roact.createElement(v7.Provider, {
		value = p2.signal
	}, p2.props[Roact.Children])
end

return {
	Provider = v6,
	Consumer = v7.Consumer,
	Context = if not FFlagAXMigrateCatalogPageInputBindings then nil else v7
}
