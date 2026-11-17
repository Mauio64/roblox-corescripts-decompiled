local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

require(AmpV2Wizard.ComponentRegistry)
require(AmpV2Wizard.Types)

local function usePresentedOverPage(node, component, flag: boolean)
	local ref = React.useRef(nil)

	if node == nil or component == nil then
		return nil
	end

	if node.behavior ~= nil and node.behavior.presentsOverPrevious == true then
		return ref.current
	end

	ref.current = flag and { node = node, component = component } or nil

	return nil
end

return usePresentedOverPage
