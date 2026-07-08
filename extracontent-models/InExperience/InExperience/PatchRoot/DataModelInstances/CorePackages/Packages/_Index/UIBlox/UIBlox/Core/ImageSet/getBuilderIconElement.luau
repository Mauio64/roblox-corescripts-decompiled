local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)

require(ParentParent.React)

local BuilderIcons = require(ParentParent.BuilderIcons)
local migrationSizeExceptions = require(scriptParent.migrationSizeExceptions)
local t1 = {
	ImageLabel = "TextLabel",
	ImageButton = "TextButton"
}
local t2 = {
	["icons/common/goldrobux"] = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.97, 0.93, 0.72)),
		ColorSequenceKeypoint.new(0.6, Color3.new(0.67, 0.58, 0.36)),
		ColorSequenceKeypoint.new(1, Color3.new(0.99, 0.88, 0.64))
	}),
	["icons/common/goldrobux_small"] = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.78, 0.71, 0.43)),
		ColorSequenceKeypoint.new(0.5, Color3.new(0.65, 0.55, 0.32)),
		ColorSequenceKeypoint.new(1, Color3.new(0.83, 0.71, 0.44))
	})
}

local function v8(uDim2: UDim2) -- line: 35
	if uDim2 and ((uDim2.X.Offset == 0 or uDim2.Y.Scale == 0) and (uDim2.Y.Offset == 0 or uDim2.X.Scale == 0)) and (uDim2.X.Offset ~= uDim2.Y.Offset or uDim2.X.Scale ~= uDim2.Y.Scale) then
		if uDim2.X.Offset ~= 0 then
			local v13 = math.min(uDim2.X.Offset, uDim2.Y.Offset)

			return (UDim2.fromOffset(v13, v13))
		end
	end

	return uDim2
end
local function v9(uDim2: UDim2) -- line: 48
	return not uDim2 or (uDim2.X.Offset ~= 0 and uDim2.Y.Scale ~= 0 or uDim2.Y.Offset ~= 0 and uDim2.X.Scale ~= 0) or uDim2.X.Offset == 0
end
local function getBuilderIconElement(p1, s1: string, p2, s2: string, p3, n1: number, n2: number?) -- line: 74
	-- upvalues: v8 (copy), v9 (copy), migrationSizeExceptions (copy), BuilderIcons (copy), t1 (copy), Roact (copy), t2 (copy)
	assert(p1.ImageRectOffset == nil and p1.ImageRectSize == nil, "ImageRect props not supported for migration icons")
	assert(p1.SliceCenter == nil and p1.SliceScale == nil, "Image slices not supported for migration icons")

	local v31 = table.clone(p1)

	if typeof(v31.Size) == "table" then
		local Size = v31.Size

		v31.Size = Size:map(v8)
		v31.TextScaled = Size:map(v9)
		v31.TextSize = Size:map(function(p4) -- line: 97
			-- upvalues: p3 (copy), p2 (copy), n2 (copy), migrationSizeExceptions (copy)
			local v44 = not p4 or (p4.X.Offset ~= 0 and p4.Y.Scale ~= 0 or p4.Y.Offset ~= 0 and p4.X.Scale ~= 0) or p4.X.Offset == 0
			local v45 = p3
			local v46 = p2
			local v47 = n2 or 1
			local YOffset = p4.Y.Offset

			if YOffset ~= 0 and (not v44 and not migrationSizeExceptions[v46.name]) then
				local Size_100 = v45.Size.Size_100
				local Size_600 = v45.Size.Size_600
				local v51 = v47 * 38

				YOffset = if not (Size_600 <= YOffset) or not (YOffset <= v51) then math.round(YOffset / Size_100) * Size_100 else Size_600
			end

			return YOffset
		end)
	else
		local Size = v31.Size

		v31.Size = v8(Size)

		local v34 = not Size or (Size.X.Offset ~= 0 and Size.Y.Scale ~= 0 or Size.Y.Offset ~= 0 and Size.X.Scale ~= 0) or Size.X.Offset == 0

		v31.TextScaled = v34

		local v35 = n2 or 1
		local YOffset = Size.Y.Offset

		if YOffset ~= 0 and not v34 and not migrationSizeExceptions[p2.name] then
			local Size_100 = p3.Size.Size_100
			local Size_600 = p3.Size.Size_600
			local v39 = v35 * 38

			YOffset = if not (Size_600 <= YOffset) or not (YOffset <= v39) then math.round(YOffset / Size_100) * Size_100 else Size_600
		end

		v31.TextSize = YOffset
	end

	v31.Text = p2.name
	v31.FontFace = BuilderIcons.Font[p2.variant]
	v31.TextColor3 = v31.ImageColor3 or p3.Color.Content.Emphasis.Color3
	v31.TextTransparency = v31.ImageTransparency or p3.Color.Content.Emphasis.Transparency
	v31.ImageColor3 = nil
	v31.ImageTransparency = nil
	v31.ResampleMode = nil
	v31.ScaleType = nil
	v31.TileSize = nil
	v31.Image = nil

	local v40 = t1[s1]

	if v40 == nil then
		error("Unsupported inner component for image set icon migration: " .. s1)
	end

	local t3 = nil

	if n1 > 0 then
		if t3 == nil then
			t3 = {}
		end

		t3.UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = v31.TextSize
		})
	end

	local v42 = t2[s2]

	if v42 then
		if t3 == nil then
			t3 = {}
		end

		v31.TextColor3 = Color3.new(1, 1, 1)
		t3.UIGradient = Roact.createElement("UIGradient", {
			Rotation = 90,
			Color = v42
		})
	end

	if t3 ~= nil then
		t3.Children = Roact.createFragment(p1[Roact.Children])

		return Roact.createElement(v40, v31, t3)
	end

	return Roact.createElement(v40, v31)
end

return getBuilderIconElement
