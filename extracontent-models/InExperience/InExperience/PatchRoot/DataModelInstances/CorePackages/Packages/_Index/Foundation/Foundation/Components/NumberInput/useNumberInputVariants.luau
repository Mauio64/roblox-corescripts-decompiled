local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local InputSize = require(Foundation.Enums.InputSize)
local IconSize = require(Foundation.Enums.IconSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function computeProps(t1: {[any]: any}) -- line: 23
	local v11 = if not t1.width or not t1.horizontalPadding then nil else UDim.new(0, (t1.buttonWidth - t1.horizontalPadding) / 2)

	return {
		container = {
			width = t1.width
		},
		button = {
			tag = "fill size-full",
			width = t1.buttonWidth,
			padding = if not v11 then nil else {
				left = v11,
				right = v11
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
local function variantsFactory(p1) -- line: 66
	-- upvalues: Flags (copy), InputSize (copy), IconSize (copy), computeProps (copy), NumberInputControlsVariant (copy)
	local v13 = if not Flags.FoundationNumberInputBeta then {
		upButton = {
			tag = "fill size-full padding-bottom-xsmall"
		},
		downButton = {
			tag = "fill size-full padding-top-xsmall"
		},
		icon = {
			tag = "content-default"
		}
	} else {
		controls = {
			tag = "row align-y-center bg-action-standard"
		}
	}
	local v14 = if not Flags.FoundationNumberInputBeta then {
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
	} else {
		[InputSize.XSmall] = {
			controls = {
				tag = "radius-small",
				width = p1.Size.Size_1200,
				buttonSize = p1.Size.Size_600,
				iconSize = IconSize.XSmall,
				radius = p1.Radius.Small
			}
		},
		[InputSize.Small] = {
			controls = {
				tag = "radius-medium",
				width = p1.Size.Size_1600,
				buttonSize = p1.Size.Size_800,
				iconSize = IconSize.Small,
				radius = p1.Radius.Medium
			}
		},
		[InputSize.Medium] = {
			controls = {
				tag = "radius-medium",
				width = p1.Size.Size_2000,
				buttonSize = p1.Size.Size_1000,
				iconSize = IconSize.Medium,
				radius = p1.Radius.Medium
			}
		},
		[InputSize.Large] = {
			controls = {
				tag = "radius-medium",
				width = p1.Size.Size_2400,
				buttonSize = p1.Size.Size_1200,
				iconSize = IconSize.Large,
				radius = p1.Radius.Medium
			}
		}
	}
	local v15 = if not Flags.FoundationNumberInputBeta then {
		[NumberInputControlsVariant.Stacked] = computeProps({
			iconTag = "size-150-100"
		})
	} else nil

	return {
		common = v13,
		sizes = v14,
		controlVariants = v15
	}
end

return function(p2, p3, p4) -- line: 174
	-- upvalues: VariantsContext (copy), variantsFactory (copy), Flags (copy), composeStyleVariant (copy)
	local v19 = VariantsContext.useVariants("NumberInput", variantsFactory, p2)

	if Flags.FoundationNumberInputBeta then
		return composeStyleVariant(v19.common, v19.sizes[p3])
	end

	return composeStyleVariant(v19.common, v19.sizes[p3], v19.controlVariants[p4])
end
