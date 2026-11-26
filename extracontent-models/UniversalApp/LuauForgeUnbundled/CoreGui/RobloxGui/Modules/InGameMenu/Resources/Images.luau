local module = require("@luauforge/bundled/dzP")

local getImageSetData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageSetData

local GuiService = game:GetService("GuiService")

local imageSetData = getImageSetData((GuiService:GetResolutionScale()))

local result = {}

for k, v5 in pairs(imageSetData) do
	module.isType(v5, "table", "value")
	local v6 = {}

	for k2, v7 in pairs(v5) do
		if k2 == "ImageSet" then
			v6.Image = string.format("rbxasset://textures/ui/ImageSet/%s.png", v7)
		else
			v6[k2] = v7
		end
	end

	result[k] = v6
end

setmetatable(result, {
	__index = function(p2, p3)
		error(("%q is not a valid member of Images"):format((tostring(p3))), 2)
	end
})

return result
