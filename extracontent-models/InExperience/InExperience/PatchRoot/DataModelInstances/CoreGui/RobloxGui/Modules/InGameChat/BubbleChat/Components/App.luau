local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local BubbleChatBillboards = require(script.Parent.BubbleChatBillboards)
local v6 = Roact.Component:extend("App")

v6.validateProps = t.strictInterface({
	store = t.table
})

function v6.render(p1) -- line: 19
	-- upvalues: Roact (copy), RoactRodux (copy), BubbleChatBillboards (copy)
	return Roact.createElement(RoactRodux.StoreProvider, {
		store = p1.props.store
	}, {
		BubbleChatBillboards = Roact.createElement(BubbleChatBillboards)
	})
end

return v6
