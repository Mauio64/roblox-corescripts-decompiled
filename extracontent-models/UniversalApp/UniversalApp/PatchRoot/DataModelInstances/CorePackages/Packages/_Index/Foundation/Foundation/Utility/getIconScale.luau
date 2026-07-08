local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local FoundationImages = require(FoundationParent.FoundationImages)
local Images = FoundationImages.Images
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)
local IconSize = require(Foundation.Enums.IconSize)
local t1 = {
	[IconSize.Small] = {
		Vector2.new(16, 16),
		Vector2.new(18, 18)
	},
	[IconSize.Medium] = {
		Vector2.new(28, 28),
		Vector2.new(36, 36)
	},
	[IconSize.Large] = { Vector2.new(48, 48) }
}
local v9 = FoundationImages.getResolutionScale()
local t2 = {
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

local function useIcon(s1: string?, p1) -- line: 55
	-- upvalues: isBuilderIcon (copy), Images (copy), v9 (copy), IconSize (copy), Dash (copy), t1 (copy), t2 (copy)
	if not s1 or isBuilderIcon(s1) then
		return nil, 1
	end

	local v14 = Images[s1]

	if not v14 then
		return nil, 1
	end

	local vector2 = Vector2.new(v14.ImageRectSize.X / v9, v14.ImageRectSize.Y / v9)
	local Medium = IconSize.Medium

	if Dash.includes(t1[IconSize.Small], vector2) then
		Medium = IconSize.Small
	elseif Dash.includes(t1[IconSize.Medium], vector2) then
		Medium = IconSize.Medium
	elseif Dash.includes(t1[IconSize.Large], vector2) then
		Medium = IconSize.Large
	end

	return vector2, t2[Medium][p1]
end

return useIcon
