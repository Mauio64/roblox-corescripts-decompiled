local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local ComposedRecyclableView = require(ViewRecyclerReact.ReactAdapter.Private.ComposedRecyclableView)
require(ViewRecyclerReact.ReactAdapter.Private.CompositionPlacement)
local CompositionPlacementSuspended = require(ViewRecyclerReact.ReactAdapter.Private.CompositionPlacementSuspended)
local React = require(ViewRecyclerReact.Parent.React)

local RecyclableViewContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewContext)
local RecyclableViewReadiness = require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)

local Signals = require(ViewRecyclerReact.Parent.Signals)
local SignalsReact = require(ViewRecyclerReact.Parent.SignalsReact)
local selectViewType = require(ViewRecyclerReact.ReactAdapter.Private.selectViewType)

local v = nil
local v2 = nil
local assignmentSignal = nil
local indexSignal = nil
local placement = nil
local InlineRecyclableView
local v3 = nil
local RecyclableViewComponent

if FFlagViewRecyclerReact08 then
	RecyclableViewComponent = nil
else
	v = Signals.createSignal(true)
	v2 = Signals.createSignal(false)
	assignmentSignal = Signals.createSignal(nil)
	indexSignal = Signals.createSignal(nil)
	placement = Signals.createSignal(nil)

	InlineRecyclableView = function(p)
		local v4 = React.useState(function()
			local signal, set = Signals.createSignal({ get = p.itemSignal })

			local signal2 = Signals.createSignal({})
			return {
				context = {
					placement = placement,
					assignmentSignal = assignmentSignal,
					indexSignal = indexSignal,
					itemSignal = function(p2)
						return signal(p2).get(p2)
					end,
					itemKeySignal = signal2
				},
				set = set,
				source = p.itemSignal
			}
		end)

		if v4.source ~= p.itemSignal then
			v4.source = p.itemSignal
			v4.set({ get = p.itemSignal })
		end

		local v5 = React.useState(function()
			return { binding = React.createBinding(false) }
		end)

		local metadata = RecyclableViewRegistry.getMetadata(p.viewType)
		assert(metadata ~= nil, "createRecyclableView: unknown Recyclable view type")
		return React.createElement(RecyclableViewContext.Provider, { value = v4.context }, {
			Content = React.createElement(metadata.signalComponent, {
				itemSignal = v4.context.itemSignal,
				pending = v5.binding
			})
		})
	end

	local function InlineActiveRecyclableView(p)
		if SignalsReact.useSignalState(p.active) then
			return React.createElement(InlineRecyclableView, p)
		end

		return nil
	end

	v3 = React.memo(InlineActiveRecyclableView)

	RecyclableViewComponent = function(props)
		local v4 = React.useContext(RecyclableViewContext)
		local v5 = v4 == false

		if v5 or v4 == CompositionPlacementSuspended then
			v4 = nil
		end

		local v6

		if v4 == nil then
			v6 = placement
		else
			v6 = v4.placement
		end

		local v7 = React.useState(function()
			return {}
		end)

		local ref = React.useRef(nil)
		local ref2 = React.useRef(nil)
		local ref3 = React.useRef(props.itemSignal)
		ref3.current = props.itemSignal
		local ref4 = React.useRef(props.active)
		ref4.current = props.active
		local viewType = props.viewType

		React.useLayoutEffect(function()
			local v8 = nil
			local effect = Signals.createEffect(function(p)
				local v9 = v6(p)

				if v9 == v8 then
					return
				end

				v8 = v9
				local current = ref2.current

				if current ~= nil then
					ref2.current = nil
					current.unregister()
				end

				if v4 ~= nil and v9 ~= nil then
					ref2.current = v9.register(
						viewType,
						v7,
						v4.assignmentSignal,
						ref3.current,
						ref.current,
						ref4.current
					)
				end
			end)
			return function()
				effect()
				local current = ref2.current

				if current ~= nil then
					ref2.current = nil
					current.unregister()
				end
			end
		end, { v4, v6, v7, viewType })

		local itemSignal = props.itemSignal
		React.useLayoutEffect(function()
			local current = ref2.current

			if current ~= nil then
				current.setItemSignal(itemSignal)
			end
		end, { itemSignal })

		local active = props.active
		React.useLayoutEffect(function()
			local current = ref2.current

			if current ~= nil then
				current.setActive(active)
			end
		end, { active })

		local ref5 = React.useCallback(function(current)
			ref.current = current
			local current2 = ref2.current

			if current2 ~= nil then
				current2.setPlaceholder(current)
			end
		end, {})

		if v5 then
			return React.createElement(v3, {
				active = active,
				itemSignal = itemSignal,
				viewType = viewType
			})
		end

		return React.createElement("Frame", {
			Name = "RecyclableView",
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(),
			ref = ref5
		})
	end
end

local function createRecyclableView(signalComponent, options)
	local v4 = options or {}
	local readiness = v4.readiness or RecyclableViewReadiness.ReadyOnAssignment
	assert(
		readiness == RecyclableViewReadiness.ReadyOnAssignment or readiness == RecyclableViewReadiness.ReadyOnCommit,
		"createRecyclableView: readiness must be ReadyOnAssignment or ReadyOnCommit"
	)

	local fn

	local v5 = not FFlagViewRecyclerReact08 and {} or nil
	local function RecyclableViewFacade(p)
		local active = p.active

		local viewType = nil
		local active2 = nil

		if FFlagViewRecyclerReact08 then
			viewType = React.useMemo(function()
				return selectViewType(active == nil or active, fn)
			end, { active })
		elseif type(active) == "function" then
			active2 = active
		else
			active2 = if active == false then v2 else v
		end

		local createElement = React.createElement
		local v6

		if FFlagViewRecyclerReact08 then
			v6 = ComposedRecyclableView
		else
			v6 = RecyclableViewComponent
		end

		if not FFlagViewRecyclerReact08 then
			viewType = RecyclableViewFacade
		end

		local v7 = {
			viewType = viewType,
			itemSignal = p.itemSignal,
			_definitionIdentity = 0,
			active = 0
		}
		local definitionIdentity

		if not FFlagViewRecyclerReact08 then
			definitionIdentity = v5
		end

		v7._definitionIdentity = definitionIdentity

		if FFlagViewRecyclerReact08 then
			active2 = nil
		end

		v7.active = active2
		return createElement(v6, v7)
	end

	if FFlagViewRecyclerReact08 then
		fn = function(p)
			return if p then RecyclableViewFacade else nil
		end
	end

	RecyclableViewRegistry.register(RecyclableViewFacade, {
		readiness = readiness,
		hideWhilePending = v4.hideWhilePending ~= false,
		signalComponent = signalComponent
	})

	return RecyclableViewFacade
end

return createRecyclableView
