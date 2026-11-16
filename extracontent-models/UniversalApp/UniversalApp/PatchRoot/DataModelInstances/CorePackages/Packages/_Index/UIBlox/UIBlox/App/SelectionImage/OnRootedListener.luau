local parent = script.Parent.Parent.Parent.Parent
local t = require(parent.t)
local Roact = require(parent.Roact)

local extended = Roact.Component:extend("OnRootedListener")
extended.validateProps = t.strictInterface({ onRooted = t.callback })

function extended:init()
	function self.onAncestryChanged(instance)
		if instance:IsDescendantOf(game) then
			self.props.onRooted(instance)
		end
	end
end

function extended.render(p)
	return Roact.createElement("Folder", { [Roact.Event.AncestryChanged] = p.onAncestryChanged })
end

return extended
