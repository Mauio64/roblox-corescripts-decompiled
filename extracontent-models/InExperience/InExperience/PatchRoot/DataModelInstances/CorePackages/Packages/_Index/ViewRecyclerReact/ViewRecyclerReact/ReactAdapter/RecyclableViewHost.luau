local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewContext)
local RecyclableViewReadiness = require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)
local ReparentableHost = ViewRecyclerRoblox.ReparentableHost
require(ViewRecyclerReact.ReactAdapter.Private.RecyclableView)
local SignalsReact = require(ViewRecyclerReact.Parent.SignalsReact)

local createElement = React.createElement

local function CommitObserver(p): nil
	local itemView = p.itemView
	local v = SignalsReact.useSignalState(itemView.contentRevision)
	React.useLayoutEffect(function()
		itemView.commitContent(v)
	end, { v, itemView.commitContent })
	return nil
end

local function RecyclableViewHost(p)
	local itemView = p.itemView
	local signal = itemView.signal
	local portalFrame = itemView.portalFrame(false)
	assert(portalFrame ~= nil, "RecyclableViewHost: view host was destroyed before unmount")
	local v = React.useState(function()
		return {
			placement = itemView.compositionPlacement,
			assignmentSignal = signal,
			indexSignal = itemView.indexSignal,
			itemSignal = itemView.itemSignal,
			itemKeySignal = itemView.itemKeySignal
		}
	end)

	React.useLayoutEffect(function()
		local detachFromPlaceholder = not FFlagViewRecyclerReact08 and function(p2)
			if portalFrame.Parent == p2 then
				ReparentableHost.detach(portalFrame)
			end
		end or nil

		local bindHost = itemView.bindHost
		local v2 = {
			clearSelection = function()
				ReparentableHost.clearSelection(portalFrame)
			end,
			detachFromPlaceholder = 0
		}

		if FFlagViewRecyclerReact08 then
			detachFromPlaceholder = nil
		end

		v2.detachFromPlaceholder = detachFromPlaceholder
		local v3 = bindHost(v2)

		return function()
			ReparentableHost.detach(portalFrame)
			v3()
		end
	end, { itemView, portalFrame })

	local metadata = RecyclableViewRegistry.getMetadata(itemView.itemViewType)
	assert(metadata ~= nil, "RecyclableViewHost: unknown Recyclable view type")
	local content = React.useMemo(function()
		return createElement(metadata.signalComponent, {
			itemSignal = itemView.itemSignal,
			pending = itemView.pending
		})
	end, { itemView, metadata })

	local v2 = SignalsReact.useSignalState(itemView.hasItem)
	React.useLayoutEffect(function()
		if not v2 then
			return nil
		end

		itemView.setContentMounted(true)
		return function()
			itemView.setContentMounted(false)
		end
	end, { v2, itemView })
	local v3 = {}

	if v2 then
		v3.Content = content
	end

	if v2 and metadata.readiness == RecyclableViewReadiness.ReadyOnCommit then
		v3.Observer = createElement(CommitObserver, { itemView = itemView })
	end

	local element = createElement(RecyclableViewContext.Provider, { value = v }, v3)

	return p.createPortal(element, portalFrame)
end

return (React.memo(RecyclableViewHost))
