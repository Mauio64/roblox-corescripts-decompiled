local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local Roact = require(ShareTargetGame.dependencies).Roact
local SendButton = require(ShareTargetGame.Components.SendButton)
local v4 = Roact.PureComponent:extend("SendButtonBase")

function v4.init(p1) -- line: 10
	p1.state = {
		sentStatus = nil
	}

	function p1.send() -- line: 15
		-- upvalues: p1 (copy)
		p1:setState({
			sentStatus = p1.props.sentStatus
		})
	end
end
function v4.render(p2) -- line: 22
	-- upvalues: Roact (copy), SendButton (copy)
	return Roact.createElement(SendButton, {
		sentStatus = p2.state.sentStatus,
		onActivated = p2.send
	})
end

return v4
