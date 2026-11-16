local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local extended = Roact.PureComponent:extend("RootedConnection")

extended.validateProps = t.strictInterface({ render = t.callback })

function extended:init()
	self.state = { isRooted = false }

	self.rootRef = Roact.createRef()

	function self.onAncestryChanged(instance)
		if instance:IsDescendantOf(game) then
			self:setState({ isRooted = true })
		end
	end
end

function extended.render(props)
	return Roact.createFragment({
		Content = props.props.render(props.state.isRooted),
		Folder = Roact.createElement("Folder", {
			[Roact.Event.AncestryChanged] = props.onAncestryChanged,
			[Roact.Ref] = props.rootRef
		})
	})
end

function extended.didMount(object)
	if object.rootRef:getValue():IsDescendantOf(game) then
		object:setState({ isRooted = true })
	end
end

return extended
