local ShareLinkInvalidModal = script:FindFirstAncestor("ShareLinkInvalidModal")
local dependencies = require(ShareLinkInvalidModal.dependencies)
local Roact = dependencies.Roact
local RoactNavigation = dependencies.RoactNavigation
local RoactRodux = dependencies.RoactRodux
local Dash = dependencies.Dash
local t = dependencies.t
local ShareLinkInvalidModal2 = require(script.Parent.ShareLinkInvalidModal)
local v9 = Roact.Component:extend("ShareLinkInvalidModalContainer")

v9.validateProps = t.interface({
	navigation = t.table,
	closeModal = t.optional(t.callback)
})

function v9.init(p1) -- line: 24
	function p1.closeModal() -- line: 25
		-- upvalues: p1 (copy)
		local props = p1.props

		if props.closeModal then
			props.closeModal()
		end

		props.navigation.pop()
	end
end
function v9.render(p2) -- line: 34
	-- upvalues: Roact (copy), ShareLinkInvalidModal2 (copy), Dash (copy)
	return Roact.createElement(ShareLinkInvalidModal2, Dash.join(p2.props, {
		closeModal = p2.closeModal
	}))
end

local v10 = RoactRodux.connect(function(p3) -- line: 43
	return {
		screenSize = p3.ScreenSize
	}
end)(v9)

return RoactNavigation.withNavigation(v10)
