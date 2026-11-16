local GuiService = game:GetService("GuiService")

local success, resolutionScale = pcall(GuiService.GetResolutionScale, GuiService)

local parent = script.Parent
local GetImageSetData = require(parent.Generated.GetImageSetData)

local v = GuiService:IsTenFootInterface() and 3 or not success and 1 or resolutionScale

local function getResolutionScale()
	local _, resolutionScale2 = GetImageSetData(v)
	return resolutionScale2
end

return getResolutionScale
