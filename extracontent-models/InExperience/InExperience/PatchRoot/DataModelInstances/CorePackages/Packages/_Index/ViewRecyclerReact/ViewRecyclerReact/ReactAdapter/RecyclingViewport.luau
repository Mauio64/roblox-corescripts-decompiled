local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local Axis = ViewRecycler.Axis
local React = require(ViewRecyclerReact.Parent.React)
local RecyclingScope = require(ViewRecyclerReact.ReactAdapter.RecyclingScope)

local RecyclingScopeContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclingScopeContext)
local RecyclingViewportContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclingViewportContext)

local createElement = React.createElement
local shallowTable = ViewRecycler.Adapter._Private.ShallowTable
local frozen = table.freeze({ "axis", "activationMargin", "retentionMargin" })

local function assignRef(scrollingFrameRef, current) -- 1 equivalent call inferred from this helper
	if scrollingFrameRef == nil then
		return
	end

	if type(scrollingFrameRef) == "function" then
		scrollingFrameRef(current)
	else
		scrollingFrameRef.current = current
	end
end

local function createRecyclingViewport(p)
	local v = RecyclingScope.create(p)

	local function RecyclingViewport(props)
		local v2

		if not FFlagViewRecyclerReact08 then
			v2 = React.useContext(RecyclingScopeContext)
		end

		local v3 = React.useState(function()
			return {
				axis = props.axis,
				activationMargin = props.activationMargin,
				retentionMargin = props.retentionMargin
			}
		end)

		assert(
			shallowTable.containsEqual(props, v3, frozen),
			"RecyclingViewport: axis and margins cannot change during its lifetime"
		)

		local v4 = React.useState(function()
			return ViewRecyclerRoblox.ViewportCoordinator.new(v3)
		end)

		local v5 = React.useState(function()
			return { register = v4.register }
		end)

		local scrollingFrameRef = props.scrollingFrameRef
		local ref = React.useCallback(function(current)
			v4.setViewport(current)
			assignRef(scrollingFrameRef, current) -- inferred equivalent call
		end, { v4, scrollingFrameRef })

		React.useEffect(function()
			return function()
				v4.destroy()
			end
		end, { v4 })

		local scrollingFrameProps = {
			Size = UDim2.fromScale(1, 1),
			ScrollingDirection = 0,
			ref = 0
		}
		local scrollingDirection

		if props.axis == Axis.X then
			scrollingDirection = Enum.ScrollingDirection.X
		else
			scrollingDirection = Enum.ScrollingDirection.Y
		end

		scrollingFrameProps.ScrollingDirection = scrollingDirection
		scrollingFrameProps.ref = ref

		if props.scrollingFrameProps ~= nil then
			for k, scrollingFrameProp in props.scrollingFrameProps do
				if scrollingFrameProps[k] ~= nil then
					error(`RecyclingViewport: {tostring(k)} is already used by ViewRecycler`)
				end

				scrollingFrameProps[k] = scrollingFrameProp
			end
		end

		local element = createElement(RecyclingViewportContext.Provider, { value = v5 }, {
			Viewport = createElement("ScrollingFrame", scrollingFrameProps, props.children)
		})

		if FFlagViewRecyclerReact08 or v2 == nil then
			return createElement(v, {
				maxPoolSize = props.maxPoolSize,
				diagnostics = props.diagnostics
			}, {
				Viewport = element
			})
		end

		local v6 = props.maxPoolSize == nil and props.diagnostics == nil
		assert(v6, "RecyclingViewport: configure recycling options on the ancestor RecyclingScope")

		return element
	end

	return RecyclingViewport
end

return { create = createRecyclingViewport }
