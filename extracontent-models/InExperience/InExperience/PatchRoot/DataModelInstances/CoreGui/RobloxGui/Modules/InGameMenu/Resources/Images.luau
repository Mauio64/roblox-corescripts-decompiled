local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local v3 = require(script.Parent.GetImageSetData)((game:GetService("GuiService"):GetResolutionScale()))
local t1 = {}

for k, v in pairs(v3) do
	ArgCheck.isType(v, "table", "value")

	local t2 = {}

	for k2, v2 in pairs(v) do
		if k2 == "ImageSet" then
			t2.Image = string.format("rbxasset://textures/ui/ImageSet/%s.png", v2)
		else
			t2[k2] = v2
		end
	end

	t1[k] = t2
end

setmetatable(t1, {
	__index = function(_, p2) -- line: 30
		error(("%q is not a valid member of Images"):format((tostring(p2))), 2)
	end
})

return t1
