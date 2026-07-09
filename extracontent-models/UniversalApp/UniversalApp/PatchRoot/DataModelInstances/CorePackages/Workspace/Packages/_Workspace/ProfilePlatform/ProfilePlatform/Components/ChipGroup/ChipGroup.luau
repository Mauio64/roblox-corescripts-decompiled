local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)

require(ProfilePlatform.Common.Types)

local Chip = Foundation.Chip
local View = Foundation.View
local uDim2 = UDim2.new(1, 0, 0, 32)

function ChipGroup(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), Chip (copy), uDim2 (copy), View (copy)
	local v9 = React.useRef(nil)
	local v10 = React.useRef(nil)
	local v11, v12 = React.useState(0)
	local v13, v14 = React.useState(0)
	local v15, v16 = React.useState(false)

	React.useEffect(function() -- line: 31
		-- upvalues: t1 (copy), v16 (copy), v11 (copy), v13 (copy)
		if t1.scrollingEnabledOverride ~= nil then
			v16(t1.scrollingEnabledOverride)

			return
		end

		v16(v11 > v13)
	end, {
		v11,
		v13,
		t1.scrollingEnabledOverride
	})

	if #t1.chips == 0 then
		return nil
	end

	local v17 = React.useMemo(function() -- line: 43
		-- upvalues: t1 (copy), React (copy), Chip (copy)
		local t2 = {}

		for i, v in ipairs(t1.chips) do
			local text = v.text

			if v.count then
				text = `{ v.count } { v.text }`
			end

			local t3 = {
				isChecked = false,
				text = text,
				onActivated = v.onActivated,
				isDisabled = v.isDisabled or false,
				LayoutOrder = v.layoutOrder or i,
				size = v.size or "Medium",
				leading = v.leading,
				trailing = v.trailing
			}

			t2[i] = React.createElement(Chip, t3)
		end

		return t2
	end, { t1.chips })
	local v18 = React.useCallback(function(p1) -- line: 68
		-- upvalues: v14 (copy)
		v14(p1.AbsoluteSize.X)
	end, {})
	local v19 = React.useCallback(function(p2) -- line: 72
		-- upvalues: v12 (copy)
		v12(p2.AbsoluteSize.X)
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = t1.size or uDim2
	}, {
		DynamicScrollingFrame = React.createElement("ScrollingFrame", {
			ref = v9,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			CanvasSize = t1.size or uDim2,
			ClipsDescendants = false,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ScrollingEnabled = v15,
			Selectable = false,
			Size = t1.size or uDim2,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = v18
		}, {
			ChipRow = React.createElement(View, {
				tag = "row gap-small auto-y size-full-0",
				ref = v10,
				AutomaticSize = Enum.AutomaticSize.X,
				onAbsoluteSizeChanged = v19
			}, table.unpack(v17))
		})
	})
end

return ChipGroup
