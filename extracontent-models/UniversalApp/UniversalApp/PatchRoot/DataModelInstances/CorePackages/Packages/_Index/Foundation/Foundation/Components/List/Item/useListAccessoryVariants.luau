local Foundation = script:FindFirstAncestor("Foundation")
local AccessoryType = require(Foundation.Enums.AccessoryType)
local InputSize = require(Foundation.Enums.InputSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 17
	-- upvalues: AccessoryType (copy), InputSize (copy)
	local t1 = {
		[AccessoryType.Icon] = {
			[InputSize.XSmall] = p1.Size.Size_400,
			[InputSize.Small] = p1.Size.Size_500,
			[InputSize.Medium] = p1.Size.Size_600,
			[InputSize.Large] = p1.Size.Size_600
		},
		[AccessoryType.Media] = {
			[InputSize.XSmall] = p1.Size.Size_600,
			[InputSize.Small] = p1.Size.Size_800,
			[InputSize.Medium] = p1.Size.Size_1000,
			[InputSize.Large] = p1.Size.Size_1400
		},
		[AccessoryType.Avatar] = {
			[InputSize.XSmall] = p1.Size.Size_600,
			[InputSize.Small] = p1.Size.Size_800,
			[InputSize.Medium] = p1.Size.Size_1000,
			[InputSize.Large] = p1.Size.Size_1400
		}
	}
	local t2 = {
		[InputSize.XSmall] = p1.Size.Size_600,
		[InputSize.Small] = p1.Size.Size_800,
		[InputSize.Medium] = p1.Size.Size_1000,
		[InputSize.Large] = p1.Size.Size_1400
	}
	local t3 = {
		[InputSize.XSmall] = p1.Radius.Small,
		[InputSize.Small] = p1.Radius.Medium,
		[InputSize.Medium] = p1.Radius.Medium,
		[InputSize.Large] = p1.Radius.Medium
	}

	return {
		accessorySize = t1,
		containerSize = t2,
		cornerRadius = t3
	}
end

return function(p2, p3, p4) -- line: 60
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v14 = VariantsContext.useVariants("ListAccessory", variantsFactory, p2)

	return composeStyleVariant({
		accessory = {
			Size = UDim2.fromOffset(v14.accessorySize[p4][p3], v14.accessorySize[p4][p3]),
			cornerRadius = UDim.new(0, v14.cornerRadius[p3])
		},
		container = {
			Size = UDim2.fromOffset(v14.containerSize[p3], v14.containerSize[p3])
		}
	})
end
