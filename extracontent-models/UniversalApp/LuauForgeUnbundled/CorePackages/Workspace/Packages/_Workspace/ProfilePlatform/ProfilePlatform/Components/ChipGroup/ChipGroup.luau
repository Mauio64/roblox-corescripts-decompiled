local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

local chip = Foundation.Chip
local view = Foundation.View

local udim = UDim2.new(1, 0, 0, 32)

function LUAUFORGE_MODULE_GLOBALS_fkX_ChipGroup(props)
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

	local v5 = React.useMemo(function()
		local children = {}

		for i, chip2 in ipairs(props.chips) do
			local v6 = chip2.text

			if chip2.count then
				v6 = `{chip2.count} {chip2.text}`
			end

			local v7 = {
				text = v6,
				onActivated = chip2.onActivated,
				isDisabled = chip2.isDisabled or false,
				isChecked = false,
				LayoutOrder = chip2.layoutOrder or i,
				size = chip2.size or "Medium",
				leading = chip2.leading,
				trailing = chip2.trailing
			}

			children[i] = React.createElement(chip, v7)
		end

		return children
	end, { props.chips })

	local v6 = React.useCallback(function(p2)
		setState2(p2.AbsoluteSize.X)
	end, {})

	local v7 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
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
			[React.Change.AbsoluteSize] = v6
		}, {
			ChipRow = React.createElement(
				view,
				{
					ref = ref2,
					tag = "row gap-small auto-y size-full-0",
					AutomaticSize = Enum.AutomaticSize.X,
					onAbsoluteSizeChanged = v7
				},
				table.unpack(v5)
			)
		})
	})
end

return LUAUFORGE_MODULE_GLOBALS_fkX_ChipGroup
