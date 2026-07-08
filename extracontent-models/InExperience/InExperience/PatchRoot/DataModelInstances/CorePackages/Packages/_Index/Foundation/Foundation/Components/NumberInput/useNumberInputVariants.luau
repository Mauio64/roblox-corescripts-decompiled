local Foundation = script:FindFirstAncestor("Foundation")
local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputVariant)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function computeProps(t1: {[any]: any}) -- line: 22
	local v9 = if not t1.width or not t1.horizontalPadding then nil else UDim.new(0, (t1.buttonWidth - t1.horizontalPadding) / 2)

	return {
		container = {
			width = t1.width
		},
		button = {
			tag = "fill size-full",
			width = t1.buttonWidth,
			padding = if not v9 then nil else {
				left = v9,
				right = v9
			}
		},
		upButton = {
			tag = t1.upButtonTag
		},
		downButton = {
			tag = t1.downButtonTag
		},
		splitButton = {
			size = t1.splitButtonSize,
			tag = t1.splitButtonTag
		},
		icon = {
			tag = t1.iconTag
		}
	}
end
local function variantsFactory(p1) -- line: 65
	-- upvalues: InputSize (copy), computeProps (copy), NumberInputControlsVariant (copy)
	local t2 = {
		upButton = {
			tag = "fill size-full padding-bottom-xsmall"
		},
		downButton = {
			tag = "fill size-full padding-top-xsmall"
		},
		icon = {
			tag = "content-default"
		}
	}
	local t3 = {
		[InputSize.XSmall] = computeProps({
			upButtonTag = "padding-top-xxsmall",
			downButtonTag = "padding-bottom-xxsmall",
			splitButtonTag = "radius-small",
			width = p1.Size.Size_3000 * 1.1666666666666667,
			buttonWidth = p1.Size.Size_400,
			horizontalPadding = p1.Size.Size_150,
			splitButtonSize = p1.Size.Size_600
		}),
		[InputSize.Small] = computeProps({
			upButtonTag = "padding-top-xsmall",
			downButtonTag = "padding-bottom-xsmall",
			splitButtonTag = "radius-medium",
			width = p1.Size.Size_3000 * 1.3333333333333333,
			buttonWidth = p1.Size.Size_600,
			horizontalPadding = p1.Size.Size_150,
			splitButtonSize = p1.Size.Size_800
		}),
		[InputSize.Medium] = computeProps({
			upButtonTag = "padding-top-small",
			downButtonTag = "padding-bottom-small",
			splitButtonTag = "radius-medium",
			width = p1.Size.Size_3000 * 1.5,
			buttonWidth = p1.Size.Size_600,
			horizontalPadding = p1.Size.Size_150,
			splitButtonSize = p1.Size.Size_1000
		}),
		[InputSize.Large] = computeProps({
			upButtonTag = "padding-top-medium",
			downButtonTag = "padding-bottom-medium",
			splitButtonTag = "radius-medium",
			width = p1.Size.Size_3000 * 1.6666666666666667,
			buttonWidth = p1.Size.Size_800,
			horizontalPadding = p1.Size.Size_150,
			splitButtonSize = p1.Size.Size_1200
		})
	}
	local t4 = {
		[NumberInputControlsVariant.Stacked] = computeProps({
			iconTag = "size-150-100"
		})
	}

	return {
		common = t2,
		sizes = t3,
		controlVariants = t4
	}
end

return function(p2, p3, p4) -- line: 126
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v17 = VariantsContext.useVariants("NumberInput", variantsFactory, p2)

	return composeStyleVariant(v17.common, v17.sizes[p3], v17.controlVariants[p4])
end
