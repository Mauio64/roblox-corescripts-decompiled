local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local BubbleChatBillboards = require(script.Parent.BubbleChatBillboards)

local extended = Roact.Component:extend("App")

extended.validateProps = t.strictInterface({ store = t.table })

function extended.render(p)
	return Roact.createElement(RoactRodux.StoreProvider, { store = p.props.store }, {
		BubbleChatBillboards = Roact.createElement(BubbleChatBillboards)
	})
end

return extended
