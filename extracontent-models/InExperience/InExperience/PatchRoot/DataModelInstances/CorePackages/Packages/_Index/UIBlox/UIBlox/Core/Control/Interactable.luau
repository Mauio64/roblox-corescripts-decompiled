local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local Foundation = require(ParentParentParentParent.Foundation)
local ControlState = require(ParentParent.Control.Enum.ControlState)

require(ParentParent.Control.Hooks.useGuiControlState)

local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function Interactable(t2: {[any]: any}, p1) -- line: 49
	-- upvalues: ImageSetComponent (copy), t1 (copy), React (copy), ControlState (copy), Foundation (copy)
	local v12 = table.clone(t2)

	v12.isDisabled = v12.isDisabled or v12.userInteractionEnabled == false
	v12.userInteractionEnabled = nil
	v12.ref = p1
	v12.component = v12.component or ImageSetComponent.Button
	v12.stateLayer = t1

	local v13 = React.useRef(ControlState.Initialize)

	if t2.onStateChanged then
		function v12.onStateChanged(p2) -- line: 59
			-- upvalues: ControlState (copy), t2 (copy), v13 (copy)
			local v15 = ControlState[p2]

			t2.onStateChanged(v13.current, v15)
			v13.current = v15
		end
	end

	return React.createElement(Foundation.UNSTABLE.Interactable, v12)
end

return (React.forwardRef(Interactable))
