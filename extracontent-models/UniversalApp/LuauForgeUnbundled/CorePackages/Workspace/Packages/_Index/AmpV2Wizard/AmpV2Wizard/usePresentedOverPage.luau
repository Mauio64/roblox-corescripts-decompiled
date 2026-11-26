local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry")
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")

local function usePresentedOverPage(p2, p3, p4)
	local ref = React.useRef(nil)

	if p2 == nil or p3 == nil then
		return nil
	end

	if p2.behavior ~= nil and p2.behavior.presentsOverPrevious == true then
		return ref.current
	end

	ref.current = p4 and { node = p2, component = p3 } or nil

	return nil
end

return usePresentedOverPage
