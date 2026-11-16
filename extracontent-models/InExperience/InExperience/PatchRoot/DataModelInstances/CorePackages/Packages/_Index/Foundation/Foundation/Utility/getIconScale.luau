local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local FoundationImages = require(parent.FoundationImages)
local Images = FoundationImages.Images
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)

local IconSize = require(Foundation.Enums.IconSize)

local v = {
	[IconSize.Small] = { Vector2.new(16, 16), Vector2.new(18, 18) },
	[IconSize.Medium] = { Vector2.new(28, 28), Vector2.new(36, 36) },
	[IconSize.Large] = { Vector2.new(48, 48) }
}

local resolutionScale = FoundationImages.getResolutionScale()

local v2 = {
	Small = {
		[IconSize.XSmall] = 0.66667,
		[IconSize.Small] = 0.88889,
		[IconSize.Medium] = 1.11111,
		[IconSize.Large] = 1.33333
	},
	Medium = {
		[IconSize.XSmall] = 0.45,
		[IconSize.Small] = 0.600003,
		[IconSize.Medium] = 0.749997,
		[IconSize.Large] = 0.9
	},
	Large = {
		[IconSize.XSmall] = 0.24545699999999998,
		[IconSize.Small] = 0.327276,
		[IconSize.Medium] = 0.40909500000000004,
		[IconSize.Large] = 0.490905
	}
}

local function useIcon(p: string?, p2)
	if not p or isBuilderIcon(p) then
		return nil, 1
	end

	local image = Images[p]

	if not image then
		return nil, 1
	end

	local vector2 = Vector2.new(image.ImageRectSize.X / resolutionScale, image.ImageRectSize.Y / resolutionScale)

	local v3 = IconSize.Medium

	if Dash.includes(v[IconSize.Small], vector2) then
		v3 = IconSize.Small
	elseif Dash.includes(v[IconSize.Medium], vector2) then
		v3 = IconSize.Medium
	elseif Dash.includes(v[IconSize.Large], vector2) then
		v3 = IconSize.Large
	end

	return vector2, v2[v3][p2]
end

return useIcon
