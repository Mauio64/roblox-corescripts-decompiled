local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

require(script.Parent.CompositionPlacement)
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewContext = require(script.Parent.RecyclableViewContext)
local RecyclableViewRegistry = require(script.Parent.RecyclableViewRegistry)
local Signals = require(ViewRecyclerReact.Parent.Signals)
local SignalsReact = require(ViewRecyclerReact.Parent.SignalsReact)

local signal = Signals.createSignal(nil)
local signal2 = Signals.createSignal(nil)
local signal3 = Signals.createSignal(nil)

local function InlineRecyclableView(p)
	local v = React.useState(function()
		local signal4, set = Signals.createSignal({ get = p.itemSignal })
		return {
			context = {
				placement = signal3,
				assignmentSignal = signal,
				indexSignal = signal2,
				itemSignal = function(p2)
					return signal4(p2).get(p2)
				end,
				itemKeySignal = Signals.createSignal({})
			},
			set = set,
			source = p.itemSignal
		}
	end)

	if v.source ~= p.itemSignal then
		v.source = p.itemSignal
		v.set({ get = p.itemSignal })
	end

	local v2 = React.useState(function()
		return { binding = React.createBinding(false) }
	end)

	return React.createElement(RecyclableViewContext.Provider, { value = v.context }, {
		Content = React.createElement(p.metadata.signalComponent, {
			itemSignal = v.context.itemSignal,
			pending = v2.binding
		})
	})
end

local function InlineSelectedRecyclableView(p)
	local viewType = p.viewType
	local v = React.useMemo(function()
		return function(p2)
			local v = viewType(p2)

			if v == nil then
				return nil
			end

			local metadata = RecyclableViewRegistry.getMetadata(v)
			assert(metadata ~= nil, "createRecyclableView: unknown Recyclable view type")
			return metadata
		end
	end, { viewType })
	local metadata = SignalsReact.useSignalState(v)

	if metadata == nil then
		return nil
	end

	return React.createElement(InlineRecyclableView, {
		metadata = metadata,
		itemSignal = p.itemSignal
	})
end

local memo = React.memo(InlineSelectedRecyclableView)

local function ComposedRecyclableView(p)
	local v = React.useContext(RecyclableViewContext)
	local v2 = v == false

	if v2 then
		v = nil
	end

	local v3

	if v == nil then
		v3 = signal3
	else
		v3 = v.placement
	end

	local v4 = React.useState(function()
		return {}
	end)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(p.itemSignal)
	ref3.current = p.itemSignal
	local ref4 = React.useRef(p.viewType)
	ref4.current = p.viewType

	React.useLayoutEffect(function()
		local v5 = nil
		local effect = Signals.createEffect(function(p2)
			local v6 = v3(p2)

			if v6 == v5 then
				return
			end

			v5 = v6
			local current = ref2.current

			if current ~= nil then
				ref2.current = nil
				current.unregister()
			end

			if v ~= nil and v6 ~= nil then
				ref2.current = v6.register(ref4.current, v4, v.assignmentSignal, ref3.current, ref.current)
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
	end, { v, v3, v4 })

	local itemSignal = p.itemSignal
	React.useLayoutEffect(function()
		local current = ref2.current

		if current ~= nil then
			current.setItemSignal(itemSignal)
		end
	end, { itemSignal })

	local viewType = p.viewType
	React.useLayoutEffect(function()
		local current = ref2.current

		if current ~= nil then
			current.setViewType(viewType)
		end
	end, { viewType })

	local ref5 = React.useCallback(function(current)
		ref.current = current
		local current2 = ref2.current

		if current2 ~= nil then
			current2.setPlaceholder(current)
		end
	end, {})

	if v2 then
		return React.createElement(memo, { viewType = viewType, itemSignal = itemSignal })
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

return ComposedRecyclableView
