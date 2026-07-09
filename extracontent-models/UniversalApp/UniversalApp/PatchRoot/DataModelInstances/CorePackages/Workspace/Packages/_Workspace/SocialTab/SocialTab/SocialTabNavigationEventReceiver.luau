local SocialTab = script:FindFirstAncestor("SocialTab")
local Roact = require(SocialTab.dependencies).Roact
local v3 = Roact.PureComponent:extend("SocialTabNavigationEventReceiver")

function v3.init(p1) -- line: 7
	p1.skipDidFocusOnMount = true

	function p1.onDidFocusHandler() -- line: 10
		-- upvalues: p1 (copy)
		if p1.skipDidFocusOnMount then
			p1.skipDidFocusOnMount = false
		end
	end
end
function v3.render(p2) -- line: 17
	-- upvalues: Roact (copy)
	return Roact.createElement(p2.props.navigationEventReceiver, {
		onDidFocus = p2.onDidFocusHandler
	})
end

return v3
