local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local v5 = Roact.PureComponent:extend("RootedConnection")

v5.validateProps = t.strictInterface({
	render = t.callback
})

function v5.init(p1) -- line: 17
	-- upvalues: Roact (copy)
	p1.state = {
		isRooted = false
	}
	p1.rootRef = Roact.createRef()

	function p1.onAncestryChanged(p2) -- line: 24
		-- upvalues: p1 (copy)
		if p2:IsDescendantOf(game) then
			p1:setState({
				isRooted = true
			})
		end
	end
end
function v5.render(p3) -- line: 33
	-- upvalues: Roact (copy)
	return Roact.createFragment({
		Content = p3.props.render(p3.state.isRooted),
		Folder = Roact.createElement("Folder", {
			[Roact.Event.AncestryChanged] = p3.onAncestryChanged,
			[Roact.Ref] = p3.rootRef
		})
	})
end
function v5.didMount(p4) -- line: 43
	if p4.rootRef:getValue():IsDescendantOf(game) then
		p4:setState({
			isRooted = true
		})
	end
end

return v5
