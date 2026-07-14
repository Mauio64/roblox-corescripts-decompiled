local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)
local ScrollView = require(Foundation.Components.ScrollView)
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
local useSubmenuHover = require(script.Parent.useSubmenuHover)
local DeclarativeBaseMenuContent = require(script.Parent.DeclarativeBaseMenuContent)
local t1 = {
	size = InputSize.Medium
}
local t2 = {
	[Radius.Small] = "radius-small",
	[Radius.Medium] = "radius-medium"
}

local function computeAutomaticSize(t3: {[any]: any}) -- line: 67
	if t3.autoSize then
		if t3.isOverMaxHeight then
			return Enum.AutomaticSize.X
		end

		return Enum.AutomaticSize.XY
	end

	if t3.isOverMaxHeight then
		return Enum.AutomaticSize.None
	end

	return Enum.AutomaticSize.Y
end
local function computeSize(t4: {[any]: any}) -- line: 73
	local v23 = if not t4.isOverMaxHeight or not t4.maxHeight then UDim.new() else UDim.new(0, t4.maxHeight)

	if t4.autoSize then
		return (UDim2.new(UDim.new(), v23))
	end

	return (UDim2.new(t4.width or UDim.new(), v23))
end
local function BaseMenu(p1, p2) -- line: 83
	-- upvalues: React (copy), t1 (copy), withDefaults (copy), useBindable (copy), useScaledValue (copy), useSubmenuHover (copy), Flags (copy), DeclarativeBaseMenuContent (copy), t2 (copy), computeAutomaticSize (copy), ScrollView (copy), withCommonProps (copy), computeSize (copy), View (copy), BaseMenuContext (copy)
	local v26, v27 = React.useBinding(false)
	local v28 = table.clone(t1)

	v28.Visible = v26

	local v29 = withDefaults(p1, v28)
	local v30 = useBindable(v29.width)
	local v31 = useBindable(v29.maxHeight)
	local v32 = useScaledValue(260)
	local v33 = useScaledValue(320)
	local v34, v35 = React.useState(false)
	local v36, v37 = React.useBinding(UDim2.fromScale(0, 1))
	local v38 = useSubmenuHover()

	React.useEffect(function() -- line: 96
		-- upvalues: v27 (copy)
		task.delay(0, function() -- line: 97
			-- upvalues: v27 (copy)
			v27(true)
		end)
	end, {})

	local v39 = React.useCallback(function() -- line: 102
		-- upvalues: v35 (copy)
		v35(true)
	end, {})
	local v40 = React.useMemo(function() -- line: 107
		-- upvalues: v30 (copy), Flags (copy), v32 (copy)
		return v30:map(function(uDim: UDim?) -- line: 108
			-- upvalues: Flags (copy), v32 (copy)
			if uDim then
				return uDim.Offset
			end

			if Flags.FoundationBaseMenuContentSizing then
				return 0
			end

			return v32
		end)
	end, {
		v30,
		v32
	})
	local v41 = React.useMemo(function() -- line: 116
		-- upvalues: v30 (copy), Flags (copy), v29 (copy), v33 (copy)
		return v30:map(function(uDim: UDim?) -- line: 117
			-- upvalues: Flags (copy), v29 (copy), v33 (copy)
			if Flags.FoundationBaseMenuContentSizing then
				return not uDim or v29.couldGrow == true
			end

			return not uDim or v29.couldGrow == true and uDim.Offset < v33
		end)
	end, {
		v30,
		v33,
		v29.couldGrow
	})
	local v42 = React.useMemo(function() -- line: 125
		-- upvalues: React (copy), v41 (copy), v40 (copy), Flags (copy), v33 (copy)
		return {
			MinSize = React.joinBindings({
				v41,
				v40
			}):map(function(p3) -- line: 127
				-- upvalues: Flags (copy)
				local v56 = p3[1]
				local v57 = p3[2]

				if not v56 then
					return nil
				end

				if Flags.FoundationBaseMenuContentSizing and v57 == 0 then
					return nil
				end

				return (Vector2.new(v57, 0))
			end),
			MaxSize = if not Flags.FoundationBaseMenuContentSizing then v41:map(function(p4) -- line: 139
				-- upvalues: v33 (copy)
				if p4 then
					return (Vector2.new(v33, 1e999))
				end

				return nil
			end) else nil
		}
	end, {
		v41,
		v40,
		v33
	})
	local v43 = React.useMemo(function() -- line: 145
		-- upvalues: React (copy), v36 (copy), v31 (copy)
		return React.joinBindings({
			canvasSize = v36,
			maxHeight = v31
		}):map(function(t5: {[any]: any}) -- line: 147
			return t5.maxHeight ~= nil and t5.canvasSize.Y.Offset > t5.maxHeight
		end)
	end, { v31 })
	local v44 = React.useCallback(function(p5) -- line: 152
		-- upvalues: v37 (copy)
		return v37(UDim2.fromOffset(p5.AbsoluteSize.X, p5.AbsoluteSize.Y))
	end, { v37 })
	local v45 = v29.children or (not v29.items or React.createElement(DeclarativeBaseMenuContent, {
		items = v29.items,
		size = v29.size
	}))
	local v46 = v29.radius == nil and "" or t2[v29.radius]

	if v29.maxHeight then
		local v47 = React.joinBindings({
			autoSize = v41,
			isOverMaxHeight = v43
		}):map(computeAutomaticSize)

		return React.createElement(ScrollView, withCommonProps(v29, {
			ref = p2,
			scroll = {
				AutomaticCanvasSize = if not Flags.FoundationBaseMenuAutoYCanvasSizing then nil else Enum.AutomaticSize.Y,
				AutomaticSize = v47,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = v36
			},
			AutomaticSize = v47,
			Size = React.joinBindings({
				autoSize = v41,
				width = v30,
				isOverMaxHeight = v43,
				maxHeight = v31
			}):map(computeSize),
			sizeConstraint = v42,
			tag = `stroke-standard stroke-default { v46 }`
		}), React.createElement(View, {
			tag = not Flags.FoundationBaseMenuAutoYCanvasSizing and "col size-full" or "col size-full-0 auto-y",
			onAbsoluteSizeChanged = v44
		}, React.createElement(BaseMenuContext.Provider, {
			value = {
				depth = 1,
				onActivated = v29.onActivated,
				onNestedLeafActivated = v29.onNestedLeafActivated,
				size = v29.size,
				hasLeading = v34,
				setHasLeading = v39,
				hoverOpenPath = v38.openPath,
				hoverOpenAtDepth = v38.openAtDepth,
				hoverCloseAtDepth = v38.closeAtDepth,
				hoverReset = v38.reset
			}
		}, v45)))
	end

	return React.createElement(View, withCommonProps(v29, {
		tag = `col stroke-standard stroke-default { v46 }`,
		AutomaticSize = v41:map(function(p6) -- line: 222
			if p6 then
				return Enum.AutomaticSize.XY
			end

			return Enum.AutomaticSize.Y
		end),
		Size = React.joinBindings({
			v41,
			v30
		}):map(function(p7) -- line: 225
			local v51 = p7[1]
			local v52 = p7[2]

			if v51 then
				return nil
			end

			return (UDim2.new(v52, UDim.new()))
		end),
		ref = p2,
		sizeConstraint = v42
	}), React.createElement(BaseMenuContext.Provider, {
		value = {
			depth = 1,
			onActivated = v29.onActivated,
			onNestedLeafActivated = v29.onNestedLeafActivated,
			size = v29.size,
			hasLeading = v34,
			setHasLeading = v39,
			hoverOpenPath = v38.openPath,
			hoverOpenAtDepth = v38.openAtDepth,
			hoverCloseAtDepth = v38.closeAtDepth,
			hoverReset = v38.reset
		}
	}, v45))
end

return React.memo(React.forwardRef(BaseMenu))
