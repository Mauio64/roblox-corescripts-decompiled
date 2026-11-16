local Foundation = script:FindFirstAncestor("Foundation")

local AccessoryType = require(Foundation.Enums.AccessoryType)

local InputSize = require(Foundation.Enums.InputSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	local accessorySize = {
		[AccessoryType.Icon] = {
			[InputSize.XSmall] = p.Size.Size_400,
			[InputSize.Small] = p.Size.Size_500,
			[InputSize.Medium] = p.Size.Size_600,
			[InputSize.Large] = p.Size.Size_600
		}
	}

	local media = AccessoryType.Media
	accessorySize[media] = {
		[InputSize.XSmall] = p.Size.Size_600,
		[InputSize.Small] = p.Size.Size_800,
		[InputSize.Medium] = p.Size.Size_1000,
		[InputSize.Large] = p.Size.Size_1400
	}

	local avatar = AccessoryType.Avatar
	accessorySize[avatar] = {
		[InputSize.XSmall] = p.Size.Size_600,
		[InputSize.Small] = p.Size.Size_800,
		[InputSize.Medium] = p.Size.Size_1000,
		[InputSize.Large] = p.Size.Size_1400
	}

	return {
		accessorySize = accessorySize,
		containerSize = {
			[InputSize.XSmall] = p.Size.Size_600,
			[InputSize.Small] = p.Size.Size_800,
			[InputSize.Medium] = p.Size.Size_1000,
			[InputSize.Large] = p.Size.Size_1400
		},
		cornerRadius = {
			[InputSize.XSmall] = p.Radius.Small,
			[InputSize.Small] = p.Radius.Medium,
			[InputSize.Medium] = p.Radius.Medium,
			[InputSize.Large] = p.Radius.Medium
		}
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("ListAccessory", variantsFactory, p)

	return composeStyleVariant({
		accessory = {
			Size = UDim2.fromOffset(v.accessorySize[p3][p2], v.accessorySize[p3][p2]),
			cornerRadius = UDim.new(0, v.cornerRadius[p2])
		},
		container = {
			Size = UDim2.fromOffset(v.containerSize[p2], v.containerSize[p2])
		}
	})
end
