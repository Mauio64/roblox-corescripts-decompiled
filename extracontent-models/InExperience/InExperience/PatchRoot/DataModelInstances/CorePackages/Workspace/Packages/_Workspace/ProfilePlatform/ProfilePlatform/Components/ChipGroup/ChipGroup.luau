local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(ProfilePlatform.Common.Types)

local Chip = Foundation.Chip
local View = Foundation.View

local udim = UDim2.new(1, 0, 0, 32)

function ChipGroup(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)

	React.useEffect(function()
		if props.scrollingEnabledOverride == nil then
			setState3(state2 < state)
		else
			setState3(props.scrollingEnabledOverride)
		end
	end, { state, state2, props.scrollingEnabledOverride })

	if #props.chips == 0 then
		return nil
	end

	local v = React.useMemo(function()
		local children = {}

		for i, chip in ipairs(props.chips) do
			local text = chip.text

			if chip.count then
				text = `{chip.count} {chip.text}`
			end

			local v = {
				text = text,
				onActivated = chip.onActivated,
				isDisabled = chip.isDisabled or false,
				isChecked = false,
				LayoutOrder = chip.layoutOrder or i,
				size = chip.size or "Medium",
				leading = chip.leading,
				trailing = chip.trailing
			}

			children[i] = React.createElement(Chip, v)
		end

		return children
	end, { props.chips })

	local v2 = React.useCallback(function(p)
		setState2(p.AbsoluteSize.X)
	end, {})

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.X)
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = props.size or udim
	}, {
		DynamicScrollingFrame = React.createElement("ScrollingFrame", {
			ref = ref,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			CanvasSize = props.size or udim,
			ClipsDescendants = false,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ScrollingEnabled = state3,
			Selectable = false,
			Size = props.size or udim,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = v2
		}, {
			ChipRow = React.createElement(
				View,
				{
					ref = ref2,
					tag = "row gap-small auto-y size-full-0",
					AutomaticSize = Enum.AutomaticSize.X,
					onAbsoluteSizeChanged = onAbsoluteSizeChanged
				},
				table.unpack(v)
			)
		})
	})
end

return ChipGroup
