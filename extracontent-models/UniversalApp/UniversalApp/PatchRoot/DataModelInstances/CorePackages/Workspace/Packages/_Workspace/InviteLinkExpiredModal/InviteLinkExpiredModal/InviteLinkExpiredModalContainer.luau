local InviteLinkExpiredModal = script:FindFirstAncestor("InviteLinkExpiredModal")
local dependencies = require(InviteLinkExpiredModal.dependencies)
local Roact = dependencies.Roact
local RoactNavigation = dependencies.RoactNavigation
local RoactRodux = dependencies.RoactRodux
local Dash = dependencies.Dash
local NetworkingGames = dependencies.NetworkingGames
local t = dependencies.t
local InviteLinkExpiredModal2 = require(script.Parent.InviteLinkExpiredModal)
local inviteLinkExpiredMapStateToProps = require(script.Parent.inviteLinkExpiredMapStateToProps)
local v11 = Roact.Component:extend("InviteLinkExpiredModalContainer")

v11.validateProps = t.interface({
	navigation = t.table,
	closeModal = t.callback,
	launchGame = t.callback,
	universeId = t.string
})

function v11.init(p1) -- line: 32
	function p1.closeModal(b1: boolean) -- line: 33
		-- upvalues: p1 (copy)
		local props = p1.props

		props.closeModal(b1)
		props.navigation.pop()
	end
end
function v11.didMount(p2) -- line: 40
	if #p2.props.universeId > 0 then
		p2.props.getExperiencesDetails(p2.props.universeId)
	end
end
function v11.render(p3) -- line: 46
	-- upvalues: Roact (copy), InviteLinkExpiredModal2 (copy), Dash (copy)
	return Roact.createElement(InviteLinkExpiredModal2, Dash.join(p3.props, {
		closeModal = p3.closeModal
	}))
end

local v12 = RoactRodux.connect(inviteLinkExpiredMapStateToProps, function(p4) -- line: 55
	-- upvalues: NetworkingGames (copy)
	return {
		getExperiencesDetails = function(s1: string) -- line: 57
			-- upvalues: p4 (copy), NetworkingGames (copy)
			return p4(NetworkingGames.GetExperiencesDetails.API({ s1 }))
		end
	}
end)(v11)

return RoactNavigation.withNavigation(v12)
