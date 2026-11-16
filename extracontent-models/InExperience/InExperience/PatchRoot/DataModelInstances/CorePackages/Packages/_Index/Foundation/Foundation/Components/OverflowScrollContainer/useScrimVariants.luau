local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Icon = BuilderIcons.Icon

local getBuilderIconForKeycode = require(Foundation.Utility.getBuilderIconForKeycode)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.25, 0),
	NumberSequenceKeypoint.new(1, 1)
})

local numberSequence2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.4, 0),
	NumberSequenceKeypoint.new(1, 1)
})

local numberSequence3 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.75, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local numberSequence4 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.6, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function variantsFactory(p)
	local size_1000 = p.Size.Size_1000

	local gradient = {
		[Enum.HorizontalAlignment.Right] = { [true] = numberSequence4, [false] = numberSequence3 },
		[Enum.HorizontalAlignment.Left] = { [true] = numberSequence2, [false] = numberSequence }
	}

	local directionIcon = {
		[Enum.HorizontalAlignment.Right] = {
			[Enum.PreferredInput.Gamepad] = getBuilderIconForKeycode(Enum.KeyCode.ButtonR1) or Icon.ChevronSmallRight,
			[Enum.PreferredInput.KeyboardAndMouse] = Icon.ChevronSmallRight,
			[Enum.PreferredInput.Touch] = Icon.ChevronSmallRight
		}
	}

	local left = Enum.HorizontalAlignment.Left
	directionIcon[left] = {
		[Enum.PreferredInput.Gamepad] = getBuilderIconForKeycode(Enum.KeyCode.ButtonL1) or Icon.ChevronSmallLeft,
		[Enum.PreferredInput.KeyboardAndMouse] = Icon.ChevronSmallLeft,
		[Enum.PreferredInput.Touch] = Icon.ChevronSmallLeft
	}

	return {
		fade = size_1000,
		directionIcon = directionIcon,
		gradient = gradient,
		iconAlignmentTag = {
			[Enum.HorizontalAlignment.Right] = "anchor-center-right position-center-right",
			[Enum.HorizontalAlignment.Left] = "anchor-center-left position-center-left"
		}
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("OverflowScrollContainerScrim", variantsFactory, p)

	return {
		fade = v.fade,
		gradient = v.gradient[p2][false],
		hoverGradient = v.gradient[p2][true],
		directionIcon = v.directionIcon[p2][p3],
		iconAlignmentTag = v.iconAlignmentTag[p2]
	}
end
