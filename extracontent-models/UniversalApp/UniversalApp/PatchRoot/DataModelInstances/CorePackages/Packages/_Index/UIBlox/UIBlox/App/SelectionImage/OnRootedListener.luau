local ParentParent = script.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)
local Roact = require(ParentParent.Roact)
local v4 = Roact.Component:extend("OnRootedListener")

v4.validateProps = t.strictInterface({
	onRooted = t.callback
})

function v4.init(p1) -- line: 16
	function p1.onAncestryChanged(p2) -- line: 17
		-- upvalues: p1 (copy)
		if p2:IsDescendantOf(game) then
			p1.props.onRooted(p2)
		end
	end
end
function v4.render(p3) -- line: 24
	-- upvalues: Roact (copy)
	return Roact.createElement("Folder", {
		[Roact.Event.AncestryChanged] = p3.onAncestryChanged
	})
end

return v4
