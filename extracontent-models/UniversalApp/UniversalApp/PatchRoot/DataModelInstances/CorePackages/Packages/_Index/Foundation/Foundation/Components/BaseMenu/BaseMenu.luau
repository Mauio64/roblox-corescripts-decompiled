local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local v = { size = InputSize.Medium }

local v2 = { [Radius.Small] = "radius-small", [Radius.Medium] = "radius-medium" }

local function BaseMenu(p, ref)
	local visible, v3 = React.useBinding(false)
	local clone = table.clone(v)
	clone.Visible = visible

	local v4 = withDefaults(p, clone)
	local width = useBindable(v4.width)
	local maxHeight = useBindable(v4.maxHeight)
	local v5 = useScaledValue(260)
	local v6 = useScaledValue(320)
	local state, setState = React.useState(false)
	local v7 = useSubmenuHover()
	React.useEffect(function()
		task.delay(0, function()
			v3(true)
		end)
	end, {})

	local setHasLeading = React.useCallback(function()
		setState(true)
	end, {})

	local v8 = React.useMemo(function()
		return width:map(function(udim: UDim?)
			if udim then
				return udim.Offset
			end

			if Flags.FoundationBaseMenuContentSizing then
				return 0
			end

			return v5
		end)
	end, { width, v5 })

	local autoSize = React.useMemo(function()
		return width:map(function(udim: UDim?)
			if Flags.FoundationBaseMenuContentSizing then
				return not udim or v4.couldGrow == true
			end

			local v9 = not udim

			if not v9 then
				if v4.couldGrow == true then
					return udim.Offset < v6
				end

				return false
			end

			return v9
		end)
	end, { width, v6, v4.couldGrow })

	local sizeConstraint = React.useMemo(function()
		local v9 = {
			MinSize = React.joinBindings({ autoSize, v8 }):map(function(list)
				local item = list[1]
				local item2 = list[2]

				if not item or Flags.FoundationBaseMenuContentSizing and item2 == 0 then
					return nil
				end

				return (Vector2.new(item2, 0))
			end),
			MaxSize = 0
		}
		local maxSize

		if not Flags.FoundationBaseMenuContentSizing then
			maxSize = autoSize:map(function(p2)
				if p2 then
					return (Vector2.new(v6, 1e999))
				end

				return nil
			end)
		end

		v9.MaxSize = maxSize
		return v9
	end, { autoSize, v8, v6 })

	local v9 = v4.children

	if not v9 and v4.items then
		v9 = React.createElement(DeclarativeBaseMenuContent, { items = v4.items, size = v4.size })
	end

	local v10 = v4.radius == nil and "" or v2[v4.radius]

	local v11 = React.useMemo(function()
		return {
			onActivated = v4.onActivated,
			onNestedLeafActivated = v4.onNestedLeafActivated,
			size = v4.size,
			hasLeading = state,
			setHasLeading = setHasLeading,
			hoverOpenPath = v7.openPath,
			hoverOpenAtDepth = v7.openAtDepth,
			hoverCloseAtDepth = v7.closeAtDepth,
			hoverReset = v7.reset,
			depth = 1,
			maxHeight = v4.maxHeight
		}
	end, {
		v4.onActivated,
		v4.onNestedLeafActivated,
		v4.size,
		state,
		v7.openPath,
		v7.openAtDepth,
		v7.closeAtDepth,
		v7.reset,
		v4.maxHeight
	})

	local element = React.createElement(BaseMenuContext.Provider, { value = v11 }, v9)

	if v4.maxHeight then
		return React.createElement(BaseMenuScrollContainer, {
			maxHeight = maxHeight,
			autoSize = autoSize,
			width = width,
			scrollViewProps = withCommonProps(v4, {
				ref = ref,
				sizeConstraint = sizeConstraint,
				scrollingFrameRef = v4.scrollingFrameRef,
				tag = `stroke-standard stroke-default {v10}`
			})
		}, element)
	end

	return React.createElement(View, withCommonProps(v4, {
		tag = `col stroke-standard stroke-default {v10}`,
		AutomaticSize = autoSize:map(function(p2)
			if p2 then
				return Enum.AutomaticSize.XY
			end

			return Enum.AutomaticSize.Y
		end),
		Size = React.joinBindings({ autoSize, width }):map(function(list)
			local item = list[1]
			local item2 = list[2]

			if item then
				return nil
			end

			return (UDim2.new(item2, UDim.new()))
		end),
		ref = ref,
		sizeConstraint = sizeConstraint
	}), element)
end

return React.memo(React.forwardRef(BaseMenu))
