local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local ChipSize = require(Foundation.Enums.ChipSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 19
	-- upvalues: ChipSize (copy)
	local t1 = {
		Default = {
			[ChipSize.Small] = UDim2.fromOffset(p1.Size.Size_300, p1.Size.Size_300),
			[ChipSize.Medium] = UDim2.fromOffset(p1.Size.Size_400, p1.Size.Size_400),
			[ChipSize.Large] = UDim2.fromOffset(p1.Size.Size_500, p1.Size.Size_500)
		},
		Circular = {
			[ChipSize.Small] = UDim2.fromOffset(p1.Size.Size_400, p1.Size.Size_400),
			[ChipSize.Medium] = UDim2.fromOffset(p1.Size.Size_500, p1.Size.Size_500),
			[ChipSize.Large] = UDim2.fromOffset(p1.Size.Size_600, p1.Size.Size_600)
		}
	}
	local t2 = {
		Circular = {
			[ChipSize.Small] = UDim.new(0, p1.Size.Size_150),
			[ChipSize.Medium] = UDim.new(0, p1.Size.Size_200),
			[ChipSize.Large] = UDim.new(0, p1.Size.Size_250)
		},
		Default = {
			[ChipSize.Small] = UDim.new(0, p1.Padding.Small),
			[ChipSize.Medium] = UDim.new(0, p1.Padding.Medium),
			[ChipSize.Large] = UDim.new(0, p1.Padding.Medium)
		}
	}

	return {
		textSpacing = {
			Leading = {
				[ChipSize.Small] = UDim.new(0, p1.Padding.XSmall),
				[ChipSize.Medium] = UDim.new(0, p1.Size.Size_150),
				[ChipSize.Large] = UDim.new(0, p1.Padding.Small)
			},
			Trailing = {
				[ChipSize.Small] = UDim.new(0, p1.Size.Size_150),
				[ChipSize.Medium] = UDim.new(0, p1.Padding.Small),
				[ChipSize.Large] = UDim.new(0, p1.Size.Size_250)
			}
		},
		accessorySpacing = t2,
		accessorySize = t1
	}
end

return function(p2, p3, b1: boolean, b2: boolean) -- line: 67
	-- upvalues: VariantsContext (copy), variantsFactory (copy), Flags (copy), composeStyleVariant (copy)
	local v14 = VariantsContext.useVariants("ChipAccessory", variantsFactory, p2)
	local v15 = not b2 and "Default" or "Circular"
	local v16 = not (if not Flags.FoundationChipBeta then b2 else b1) and "Trailing" or "Leading"

	return composeStyleVariant({
		accessory = {
			Size = v14.accessorySize[v15][p3],
			padding = if not b1 then {
				left = v14.textSpacing[v16][p3],
				right = v14.accessorySpacing[v15][p3]
			} else {
				left = v14.accessorySpacing[v15][p3],
				right = v14.textSpacing[v16][p3]
			}
		}
	})
end
