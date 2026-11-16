local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local GetImageSetData = require(script.Parent.GetImageSetData)

local GuiService = game:GetService("GuiService")

local imageSetData = GetImageSetData((GuiService:GetResolutionScale()))

local Images = {}

for k, v in pairs(imageSetData) do
	ArgCheck.isType(v, "table", "value")
	local v2 = {}

	for k2, v3 in pairs(v) do
		if k2 == "ImageSet" then
			v2.Image = string.format("rbxasset://textures/ui/ImageSet/%s.png", v3)
		else
			v2[k2] = v3
		end
	end

	Images[k] = v2
end

setmetatable(Images, {
	__index = function(_, p)
		error(("%q is not a valid member of Images"):format((tostring(p))), 2)
	end
})

return Images
