local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("Responsive").Parent
local GetFFlagApplyResolutionScale = require(Parent.SharedFlags).GetFFlagApplyResolutionScale

function getVirtualResolutionScale() -- line: 8
	-- upvalues: GetFFlagApplyResolutionScale (copy), GuiService (copy)
	if not GetFFlagApplyResolutionScale() then
		return nil
	end

	if GuiService:IsTenFootInterface() then
		return 1.5
	end

	return 1
end

return getVirtualResolutionScale
