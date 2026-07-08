local GuiService = game:GetService("GuiService")
local CorePackages = script:FindFirstAncestor("CorePackages")
local ok, result = pcall(GuiService.GetResolutionScale, GuiService)
local scriptParent = script.Parent
local GetImageSetData = require(scriptParent.Generated.GetImageSetData)
local FixBlurryImages = require(scriptParent.Flags).FixBlurryImages

if not ok or not FixBlurryImages and not CorePackages then
	result = 1
end

if GuiService:IsTenFootInterface() then
	result = 3
end

local function getResolutionScale() -- line: 21
	-- upvalues: GetImageSetData (copy), result (ref)
	local _, v10 = GetImageSetData(result)

	return v10
end

return getResolutionScale
