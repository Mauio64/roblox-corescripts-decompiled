local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local selfViewVisibilityUpdatedSignal = require("@game/CoreGui/RobloxGui/Modules/SelfView/selfViewVisibilityUpdatedSignal")

local extended = Roact.Component:extend("TopBarSearchSignalProvider")
local context = Roact.createContext(nil)

function extended:init()
	self.signal = selfViewVisibilityUpdatedSignal.new()
end

function extended.render(p2)
	return Roact.createElement(context.Provider, { value = p2.signal }, p2.props[Roact.Children])
end

return { Provider = extended, Consumer = context.Consumer, Context = context }
