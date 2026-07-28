local Foundation = script:FindFirstAncestor("Foundation")
local ChipSize = require(Foundation.Enums.ChipSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 17
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

return function(p2, p3, b1: boolean, b2: boolean) -- line: 65
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v13 = VariantsContext.useVariants("ChipAccessory", variantsFactory, p2)
	local v14 = not b2 and "Default" or "Circular"
	local v15 = not b1 and "Trailing" or "Leading"

	return composeStyleVariant({
		accessory = {
			Size = v13.accessorySize[v14][p3],
			padding = if not b1 then {
				left = v13.textSpacing[v15][p3],
				right = v13.accessorySpacing[v14][p3]
			} else {
				left = v13.accessorySpacing[v14][p3],
				right = v13.textSpacing[v15][p3]
			}
		}
	})
end
