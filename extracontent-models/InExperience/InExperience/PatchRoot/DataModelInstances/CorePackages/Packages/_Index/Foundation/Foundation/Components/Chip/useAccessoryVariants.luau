local Foundation = script:FindFirstAncestor("Foundation")

local ChipSize = require(Foundation.Enums.ChipSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	local accessorySize = {}
	accessorySize.Default = {
		[ChipSize.Small] = UDim2.fromOffset(p.Size.Size_300, p.Size.Size_300),
		[ChipSize.Medium] = UDim2.fromOffset(p.Size.Size_400, p.Size.Size_400),
		[ChipSize.Large] = UDim2.fromOffset(p.Size.Size_500, p.Size.Size_500)
	}

	local udims = {
		[ChipSize.Small] = UDim2.fromOffset(p.Size.Size_400, p.Size.Size_400),
		[ChipSize.Medium] = UDim2.fromOffset(p.Size.Size_500, p.Size.Size_500),
		[ChipSize.Large] = UDim2.fromOffset(p.Size.Size_600, p.Size.Size_600)
	}
	accessorySize.Circular = udims

	local accessorySpacing = {}
	accessorySpacing.Circular = {
		[ChipSize.Small] = UDim.new(0, p.Size.Size_150),
		[ChipSize.Medium] = UDim.new(0, p.Size.Size_200),
		[ChipSize.Large] = UDim.new(0, p.Size.Size_250)
	}

	local udims2 = {
		[ChipSize.Small] = UDim.new(0, p.Padding.Small),
		[ChipSize.Medium] = UDim.new(0, p.Padding.Medium),
		[ChipSize.Large] = UDim.new(0, p.Padding.Medium)
	}
	accessorySpacing.Default = udims2

	local iconOnlySpacing = {}
	iconOnlySpacing.Default = {
		[ChipSize.Small] = UDim.new(0, p.Size.Size_150),
		[ChipSize.Medium] = UDim.new(0, p.Size.Size_200),
		[ChipSize.Large] = UDim.new(0, p.Size.Size_250)
	}

	local udims3 = {
		[ChipSize.Small] = UDim.new(0, p.Padding.XSmall),
		[ChipSize.Medium] = UDim.new(0, p.Size.Size_150),
		[ChipSize.Large] = UDim.new(0, p.Padding.Small)
	}
	iconOnlySpacing.Circular = udims3

	local textSpacing = {}
	textSpacing.Leading = {
		[ChipSize.Small] = UDim.new(0, p.Padding.XSmall),
		[ChipSize.Medium] = UDim.new(0, p.Size.Size_150),
		[ChipSize.Large] = UDim.new(0, p.Padding.Small)
	}

	local udims4 = {
		[ChipSize.Small] = UDim.new(0, p.Size.Size_150),
		[ChipSize.Medium] = UDim.new(0, p.Padding.Small),
		[ChipSize.Large] = UDim.new(0, p.Size.Size_250)
	}
	textSpacing.Trailing = udims4

	return {
		textSpacing = textSpacing,
		accessorySpacing = accessorySpacing,
		accessorySize = accessorySize,
		iconOnlySpacing = iconOnlySpacing
	}
end

return function(p, p2, flag: boolean, flag2: boolean, flag3: boolean?)
	local v = VariantsContext.useVariants("ChipAccessory", variantsFactory, p)
	local v2 = flag2 and "Circular" or "Default"
	local v3 = flag and "Leading" or "Trailing"
	local accessory = { Size = v.accessorySize[v2][p2], padding = 0 }
	local padding

	if flag3 then
		padding = { left = v.iconOnlySpacing[v2][p2], right = v.iconOnlySpacing[v2][p2] }
	elseif flag then
		padding = { left = v.accessorySpacing[v2][p2], right = v.textSpacing[v3][p2] }
	else
		padding = { left = v.textSpacing[v3][p2], right = v.accessorySpacing[v2][p2] }
	end

	accessory.padding = padding
	return composeStyleVariant({ accessory = accessory })
end
