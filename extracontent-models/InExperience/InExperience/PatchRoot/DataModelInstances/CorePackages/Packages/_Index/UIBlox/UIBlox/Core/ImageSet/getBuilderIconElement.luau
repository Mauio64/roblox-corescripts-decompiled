local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local Roact = require(parent2.Roact)
require(parent2.React)
local BuilderIcons = require(parent2.BuilderIcons)
local migrationSizeExceptions = require(parent.migrationSizeExceptions)

local v = { ImageLabel = "TextLabel", ImageButton = "TextButton" }

local v2 = {
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

local function fn(size: UDim2)
	local v3

	if size and (size.X.Offset == 0 or size.Y.Scale == 0) then
		if size.Y.Offset == 0 then
			v3 = false
		else
			v3 = size.X.Scale ~= 0
		end
	else
		v3 = true
	end

	if v3 or size.X.Offset == size.Y.Offset and size.X.Scale == size.Y.Scale or size.X.Offset == 0 then
		return size
	end

	local v4 = math.min(size.X.Offset, size.Y.Offset)
	return (UDim2.fromOffset(v4, v4))
end

local function fn2(udim: UDim2) -- 2 equivalent calls inferred from this helper
	local v3

	if udim and (udim.X.Offset == 0 or udim.Y.Scale == 0) then
		if udim.Y.Offset == 0 then
			v3 = false
		else
			v3 = udim.X.Scale ~= 0
		end
	else
		v3 = true
	end

	return not v3 and udim.X.Offset == 0 or v3
end

local function fn3(udim: UDim2, flag: boolean, p, p2, p3: number) -- 2 equivalent calls inferred from this helper
	local offset = udim.Y.Offset

	if offset == 0 or flag or migrationSizeExceptions[p2.name] then
		return offset
	end

	local size_100 = p.Size.Size_100
	local size_600 = p.Size.Size_600
	local v3 = p3 * 38

	if size_600 <= offset and offset <= v3 then
		return size_600
	end

	return math.round(offset / size_100) * size_100
end

local function getBuilderIconElement(props, p: string, p2, p3: string, p4, p5: number, value: number?)
	local v3 = props.ImageRectOffset == nil and props.ImageRectSize == nil
	assert(v3, "ImageRect props not supported for migration icons")

	local v4 = props.SliceCenter == nil and props.SliceScale == nil
	assert(v4, "Image slices not supported for migration icons")

	local clone = table.clone(props)

	if typeof(clone.Size) == "table" then
		local size = clone.Size
		clone.Size = size:map(fn)
		clone.TextScaled = size:map(fn2)
		clone.TextSize = size:map(function(p6)
			return fn3(p6, fn2(p6), p4, p2, value or 1) -- inferred equivalent call
		end)
	else
		local size = clone.Size
		clone.Size = fn(size)
		local textScaled = fn2(size) -- inferred equivalent call
		clone.TextScaled = textScaled
		clone.TextSize = fn3(size, textScaled, p4, p2, value or 1) -- inferred equivalent call
	end

	clone.Text = p2.name
	clone.FontFace = BuilderIcons.Font[p2.variant]

	clone.TextColor3 = clone.ImageColor3 or p4.Color.Content.Emphasis.Color3
	clone.TextTransparency = clone.ImageTransparency or p4.Color.Content.Emphasis.Transparency

	clone.ImageColor3 = nil
	clone.ImageTransparency = nil
	clone.ResampleMode = nil
	clone.ScaleType = nil
	clone.TileSize = nil
	clone.Image = nil

	local v5 = v[p]

	if v5 == nil then
		error("Unsupported inner component for image set icon migration: " .. p)
	end

	local children = nil

	if p5 > 0 then
		children = children == nil and {} or children

		children.UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = clone.TextSize
		})
	end

	local color = v2[p3]

	if color then
		children = children == nil and {} or children

		clone.TextColor3 = Color3.new(1, 1, 1)
		children.UIGradient = Roact.createElement("UIGradient", { Color = color, Rotation = 90 })
	end

	if children == nil then
		return Roact.createElement(v5, clone)
	end

	children.Children = Roact.createFragment(props[Roact.Children])
	return Roact.createElement(v5, clone, children)
end

return getBuilderIconElement
