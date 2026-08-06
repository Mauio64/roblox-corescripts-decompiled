local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)
local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useBindable = require(Foundation.Utility.useBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Enums.ControlState)

local Radius = require(Foundation.Enums.Radius)

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)
local BaseMenuContext = require(script.Parent.BaseMenuContext)
local BaseMenuScrollContainer = require(script.Parent.BaseMenuScrollContainer)
local useSubmenuHover = require(script.Parent.useSubmenuHover)
local DeclarativeBaseMenuContent = require(script.Parent.DeclarativeBaseMenuContent)
local t1 = {
	size = InputSize.Medium
}
local t2 = {
	[Radius.Small] = "radius-small",
	[Radius.Medium] = "radius-medium"
}

local function BaseMenu(p1, p2) -- line: 69
	-- upvalues: React (copy), t1 (copy), withDefaults (copy), useBindable (copy), useScaledValue (copy), useSubmenuHover (copy), Flags (copy), DeclarativeBaseMenuContent (copy), t2 (copy), BaseMenuContext (copy), BaseMenuScrollContainer (copy), withCommonProps (copy), View (copy)
	local v21, v22 = React.useBinding(false)
	local v23 = table.clone(t1)

	v23.Visible = v21

	local v24 = withDefaults(p1, v23)
	local v25 = useBindable(v24.width)
	local v26 = useBindable(v24.maxHeight)
	local v27 = useScaledValue(260)
	local v28 = useScaledValue(320)
	local v29, v30 = React.useState(false)
	local v31 = useSubmenuHover()

	React.useEffect(function() -- line: 81
		-- upvalues: v22 (copy)
		task.delay(0, function() -- line: 82
			-- upvalues: v22 (copy)
			v22(true)
		end)
	end, {})

	local v32 = React.useCallback(function() -- line: 87
		-- upvalues: v30 (copy)
		v30(true)
	end, {})
	local v33 = React.useMemo(function() -- line: 92
		-- upvalues: v25 (copy), Flags (copy), v27 (copy)
		return v25:map(function(uDim: UDim?) -- line: 93
			-- upvalues: Flags (copy), v27 (copy)
			if uDim then
				return uDim.Offset
			end

			if Flags.FoundationBaseMenuContentSizing then
				return 0
			end

			return v27
		end)
	end, {
		v25,
		v27
	})
	local v34 = React.useMemo(function() -- line: 101
		-- upvalues: v25 (copy), Flags (copy), v24 (copy), v28 (copy)
		return v25:map(function(uDim: UDim?) -- line: 102
			-- upvalues: Flags (copy), v24 (copy), v28 (copy)
			if Flags.FoundationBaseMenuContentSizing then
				return not uDim or v24.couldGrow == true
			end

			return not uDim or v24.couldGrow == true and uDim.Offset < v28
		end)
	end, {
		v25,
		v28,
		v24.couldGrow
	})
	local v35 = React.useMemo(function() -- line: 110
		-- upvalues: React (copy), v34 (copy), v33 (copy), Flags (copy), v28 (copy)
		return {
			MinSize = React.joinBindings({
				v34,
				v33
			}):map(function(p3) -- line: 112
				-- upvalues: Flags (copy)
				local v46 = p3[1]
				local v47 = p3[2]

				if not v46 then
					return nil
				end

				if Flags.FoundationBaseMenuContentSizing and v47 == 0 then
					return nil
				end

				return (Vector2.new(v47, 0))
			end),
			MaxSize = if not Flags.FoundationBaseMenuContentSizing then v34:map(function(p4) -- line: 124
				-- upvalues: v28 (copy)
				if p4 then
					return (Vector2.new(v28, 1e999))
				end

				return nil
			end) else nil
		}
	end, {
		v34,
		v33,
		v28
	})
	local v36 = v24.children or (not v24.items or React.createElement(DeclarativeBaseMenuContent, {
		items = v24.items,
		size = v24.size
	}))
	local v37 = v24.radius == nil and "" or t2[v24.radius]
	local v38 = React.createElement(BaseMenuContext.Provider, {
		value = {
			depth = 1,
			onActivated = v24.onActivated,
			onNestedLeafActivated = v24.onNestedLeafActivated,
			size = v24.size,
			hasLeading = v29,
			setHasLeading = v32,
			hoverOpenPath = v31.openPath,
			hoverOpenAtDepth = v31.openAtDepth,
			hoverCloseAtDepth = v31.closeAtDepth,
			hoverReset = v31.reset,
			maxHeight = v24.maxHeight
		}
	}, v36)

	if v24.maxHeight then
		return React.createElement(BaseMenuScrollContainer, {
			maxHeight = v26,
			autoSize = v34,
			width = v25,
			scrollViewProps = withCommonProps(v24, {
				ref = p2,
				sizeConstraint = v35,
				scrollingFrameRef = v24.scrollingFrameRef,
				tag = `stroke-standard stroke-default { v37 }`
			})
		}, v38)
	end

	return React.createElement(View, withCommonProps(v24, {
		tag = `col stroke-standard stroke-default { v37 }`,
		AutomaticSize = v34:map(function(p5) -- line: 173
			if p5 then
				return Enum.AutomaticSize.XY
			end

			return Enum.AutomaticSize.Y
		end),
		Size = React.joinBindings({
			v34,
			v25
		}):map(function(p6) -- line: 176
			local v41 = p6[1]
			local v42 = p6[2]

			if v41 then
				return nil
			end

			return (UDim2.new(v42, UDim.new()))
		end),
		ref = p2,
		sizeConstraint = v35
	}), v38)
end

return React.memo(React.forwardRef(BaseMenu))
