local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local Foundation = require(parent3.Foundation)

local ControlState = require(parent.Control.Enum.ControlState)
require(parent.Control.Hooks.useGuiControlState)

local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)

local stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function Interactable(p, ref)
	local clone = table.clone(p)
	clone.isDisabled = clone.isDisabled or clone.userInteractionEnabled == false
	clone.userInteractionEnabled = nil
	clone.ref = ref
	clone.component = clone.component or ImageSetComponent.Button
	clone.stateLayer = stateLayer

	local ref2 = React.useRef(ControlState.Initialize)

	if p.onStateChanged then
		function clone.onStateChanged(p2)
			local current = ControlState[p2]
			p.onStateChanged(ref2.current, current)
			ref2.current = current
		end
	end

	return React.createElement(Foundation.UNSTABLE.Interactable, clone)
end

return (React.forwardRef(Interactable))
