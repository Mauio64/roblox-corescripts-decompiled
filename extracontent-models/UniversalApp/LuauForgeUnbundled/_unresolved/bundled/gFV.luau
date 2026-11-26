local module = require("@luauforge/bundled/gFI")

local roact = module.Roact
local roactNavigation = module.RoactNavigation
local roactRodux = module.RoactRodux
local dash = module.Dash
local networkingGames = module.NetworkingGames
local t = module.t

local module2 = require("@luauforge/bundled/gFW")
local module3 = require("@luauforge/bundled/gFX")

local extended = roact.Component:extend("InviteLinkExpiredModalContainer")

extended.validateProps = t.interface({
	navigation = t.table,
	closeModal = t.callback,
	launchGame = t.callback,
	universeId = t.string
})

function extended:init()
	function self.closeModal(p3)
		local props = self.props
		props.closeModal(p3)
		props.navigation.pop()
	end
end

function extended.didMount(p2)
	if #p2.props.universeId > 0 then
		p2.props.getExperiencesDetails(p2.props.universeId)
	end
end

function extended.render(p2)
	return roact.createElement(module2, dash.join(p2.props, {
		closeModal = p2.closeModal
	}))
end

local v5 = roactRodux.connect(module3, function(callback)
	return {
		getExperiencesDetails = function(p2)
			return callback(networkingGames.GetExperiencesDetails.API({ p2 }))
		end
	}
end)(extended)

return roactNavigation.withNavigation(v5)
