local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

require(ViewRecyclerReact.Parent.ViewRecycler)
local Destination = require(script.Parent.Destination)
local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)
local HostPresentationPhase = ViewRecyclerRoblox.HostPresentationPhase

local PlacementKind = require(script.Parent.PlacementKind)
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewReadiness = require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
local RecyclableViewRegistry = require(script.Parent.RecyclableViewRegistry)
local reparentableHost

if FFlagViewRecyclerReact08 then
	reparentableHost = nil
else
	reparentableHost = ViewRecyclerRoblox.ReparentableHost
end

local Signals = require(ViewRecyclerReact.Parent.Signals)
local SignalsExperimental = require(ViewRecyclerReact.Parent.SignalsExperimental)
local SignalsScheduler = require(ViewRecyclerReact.Parent.SignalsScheduler)
local RecyclableView

if FFlagViewRecyclerReact08 then
	RecyclableView = function(id: number, p, p2, p3)
		local metadata = RecyclableViewRegistry.getMetadata(p)
		assert(metadata ~= nil, "RecyclableView: unknown Recyclable view type")
		local readiness = metadata.readiness
		local hideWhilePending = metadata.hideWhilePending
		local signal, v = Signals.createSignal(p2)
		local signal2, v2 = Signals.createSignal(nil)
		local signal3, v3 = Signals.createSignal(p2)

		local signal4, v4 = Signals.createSignal(p2 ~= nil)
		local binding, v5 = React.createBinding(false)
		local v6 = p2 == nil and 0 or 1
		local contentRevision, v7

		if readiness == RecyclableViewReadiness.ReadyOnCommit then
			contentRevision, v7 = Signals.createSignal(v6)
		else
			contentRevision = function(_)
				return v6
			end

			v7 = function(_) end
		end

		local frame = Instance.new("Frame")
		frame.Name = `ListItemViewFrame{id}`
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Position = UDim2.new()
		frame.Size = UDim2.new()

		local destroyingConnection = frame.Destroying:Connect(function() end)

		local v8 = nil
		local v9 = nil

		local v10 = Destination.Kind.List
		local v11 = true
		local v12 = false
		local v13 = nil
		local v14 = nil
		local flag = false
		local v15 = false

		local v16 = nil

		local function detachState(p4) -- 2 equivalent calls inferred from this helper
			if p4 ~= nil then
				local destination = p4.destination
				Destination.behaviors[destination.kind].detach(v16, frame, destination)
			end
		end

		local function resolvePhase() -- 1 equivalent call inferred from this helper
			if not (v9 ~= nil and v12) then
				return HostPresentationPhase.Hidden
			end

			if readiness == RecyclableViewReadiness.ReadyOnAssignment or v11 then
				return HostPresentationPhase.Presented
			end

			if hideWhilePending then
				return HostPresentationPhase.Hidden
			end

			return HostPresentationPhase.Pending
		end

		local function publish(p4, p5) -- 2 equivalent calls inferred from this helper
			local destination = p4.destination
			Destination.behaviors[destination.kind].present(v16, frame, destination, p5)
			v13 = p4
			v14 = p5
		end

		local function fn()
			v15 = false
			local v17 = v9

			if v17 == nil or flag then
				return
			end

			local phase = resolvePhase() -- inferred equivalent call

			if v13 == v17 and v14 == phase then
				return
			end

			publish(v17, phase) -- inferred equivalent call
		end

		local function requestPublication() -- 2 equivalent calls inferred from this helper
			if not v15 then
				v15 = true
				SignalsScheduler.schedule(fn)
			end
		end

		local function sameDestinationOwner(destination, destination2) -- 1 equivalent call inferred from this helper
			return destination.kind == destination2.kind
				and Destination.behaviors[destination.kind].sameOwner(destination, destination2)
		end

		v16 = {
			id = id,
			viewType = p,
			itemViewType = p,
			signal = signal,
			indexSignal = signal2,
			itemSignal = function(p4)
				local v17 = signal3(p4)
				assert(v17 ~= nil, "RecyclableView: item read before first Assignment")
				return Destination.behaviors[v10].readItem(v17.value, p4)
			end,
			itemKeySignal = function(p4)
				local v17 = signal3(p4)
				assert(v17 ~= nil, "RecyclableView: item key read before first Assignment")
				return v17.key
			end,
			hasItem = signal4,
			transition = function(data)
				if flag then
					assert(data == nil, "RecyclableView: cannot transition an occupied state after destroy")
					return
				end

				local v17 = v9
				local assignment

				if v17 ~= nil then
					assignment = v17.assignment
				end

				local assignment2

				if data == nil then
					assignment2 = nil
				else
					assignment2 = data.assignment
				end

				local destination

				if v17 ~= nil then
					destination = v17.destination
				end

				local destination2

				if data ~= nil then
					destination2 = data.destination
				end

				local v18

				if destination == nil then
					v18 = false
				elseif destination2 == nil then
					v18 = true
				else
					v18 = not sameDestinationOwner(destination, destination2) -- inferred equivalent call
				end

				if v18 then
					detachState(v17) -- inferred equivalent call
					v13 = nil
					v14 = nil
				end

				if assignment ~= nil and assignment ~= assignment2 then
					local v19 = v8

					if v19 ~= nil then
						v19.clearSelection()
					end
				end

				v9 = data

				if destination2 ~= nil then
					Destination.behaviors[destination2.kind].attach(frame, destination2)
				end

				if data ~= nil and v13 == nil then
					publish(data, HostPresentationPhase.Hidden) -- inferred equivalent call
				end

				local kind

				if data == nil then
					kind = nil
				else
					kind = data.destination.kind
				end

				local v19

				if assignment2 == nil then
					v19 = false
				else
					v19 = assignment ~= assignment2 or v10 ~= kind
				end

				local v20

				if readiness == RecyclableViewReadiness.ReadyOnCommit and assignment2 ~= nil then
					v20 = assignment ~= assignment2 or not v11
				else
					v20 = false
				end

				if v20 then
					v6 += 1
				end

				local v21

				if assignment2 == nil then
					v21 = false
				elseif readiness == RecyclableViewReadiness.ReadyOnAssignment then
					v21 = true
				else
					v21 = not v20 and v11
				end

				v11 = v21

				SignalsExperimental.batch(function()
					if v19 then
						v10 = kind
						v3(assignment2)

						if not signal4(false) then
							v4(true)
						end
					end

					if v20 then
						v7(v6)
					end

					local v22

					if data ~= nil then
						v22 = data.index
					end

					v2(v22)
					v(assignment2)

					if readiness == RecyclableViewReadiness.ReadyOnCommit and (assignment2 == nil or v20) then
						v5(assignment2 ~= nil)
					end

					if data ~= nil then
						requestPublication() -- inferred equivalent call
					end
				end)
			end,
			pending = binding,
			contentRevision = contentRevision,
			commitContent = function(p4: number): boolean
				if flag or readiness ~= RecyclableViewReadiness.ReadyOnCommit or v9 == nil or p4 ~= v6 then
					return false
				end

				v11 = true
				SignalsExperimental.batch(function()
					v5(false)
					requestPublication() -- inferred equivalent call
				end)
				return true
			end,
			setContentMounted = function(flag2: boolean)
				if flag or v12 == flag2 then
					return
				end

				v12 = flag2

				if flag2 and v9 ~= nil then
					SignalsExperimental.batch(requestPublication)
				end
			end,
			compositionPlacement = function(_)
				return p3
			end,
			portalFrame = function(_)
				return if not flag then frame else nil
			end,
			bindHost = function(p4)
				assert(not flag, "RecyclableView: cannot bind a destroyed host")
				assert(v8 == nil, "RecyclableView: host is already bound")
				v8 = p4
				local v17 = true
				return function()
					if v17 and v8 == p4 then
						v17 = false
						v8 = nil
					end
				end
			end,
			isHostDestroyed = function()
				return flag or not destroyingConnection.Connected
			end,
			destroy = function()
				if flag then
					return
				end

				flag = true
				detachState(v9) -- inferred equivalent call
				v9 = nil
				v8 = nil
				v5(false)
				destroyingConnection:Disconnect()
				frame.Parent = nil
				frame:Destroy()
			end
		}

		return v16
	end
else
	RecyclableView = function(id: number, p, p2, p3, hideWhilePending: boolean?)
		local metadata = RecyclableViewRegistry.getMetadata(p)
		assert(metadata ~= nil, "RecyclableView: unknown Recyclable view type")
		local readiness = p3 or metadata.readiness

		if hideWhilePending == nil then
			hideWhilePending = metadata.hideWhilePending
		end

		local signal, v = Signals.createSignal(p2)
		local signal2, v2 = Signals.createSignal(nil)
		local signal3, v3 = Signals.createSignal(p2)

		local signal4, v4 = Signals.createSignal(p2 ~= nil)
		local signal5, v5 = Signals.createSignal(nil)
		local binding, v6 = React.createBinding(false)
		local v7 = p2 == nil and 0 or 1
		local contentRevision, v8

		if readiness == RecyclableViewReadiness.ReadyOnCommit then
			contentRevision, v8 = Signals.createSignal(v7)
		else
			contentRevision = function(_)
				return v7
			end

			v8 = function(_) end
		end

		local frame = Instance.new("Frame")
		frame.Name = `ListItemViewFrame{id}`
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Position = UDim2.new()
		frame.Size = UDim2.new()

		local v9 = nil
		local v10 = nil
		local v11 = nil
		local v12 = true
		local v13 = false
		local v14 = nil
		local v15 = nil
		local flag = false
		local v16 = false

		local function resetCompositionHost() -- 1 equivalent call inferred from this helper
			reparentableHost.detach(frame)
			frame.AnchorPoint = Vector2.zero
			frame.Position = UDim2.new()
			frame.Size = UDim2.new()
			frame.AutomaticSize = Enum.AutomaticSize.None
		end

		local function detachState(p4) -- 2 equivalent calls inferred from this helper
			if p4 == nil then
				return
			end

			local destination = p4.destination

			if destination.kind == PlacementKind.List then
				destination.sink.apply(nil)
				return
			end

			resetCompositionHost() -- inferred equivalent call
		end

		local function resolvePhase() -- 1 equivalent call inferred from this helper
			if not (v10 ~= nil and v13) then
				return HostPresentationPhase.Hidden
			end

			if readiness == RecyclableViewReadiness.ReadyOnAssignment or v12 then
				return HostPresentationPhase.Presented
			end

			if hideWhilePending then
				return HostPresentationPhase.Hidden
			end

			return HostPresentationPhase.Pending
		end

		local function publish(p4, phase)
			local destination = p4.destination

			if destination.kind == PlacementKind.List then
				destination.sink.apply({ host = frame, phase = phase, state = destination.state })
			else
				if frame.Parent ~= destination.placeholder or frame.AutomaticSize ~= destination.automaticSize then
					reparentableHost.place(frame, destination)
				end

				frame.Visible = phase ~= HostPresentationPhase.Hidden
			end

			v14 = p4
			v15 = phase
		end

		local function fn()
			v16 = false
			local v17 = v10

			if v17 == nil or flag then
				return
			end

			local phase = resolvePhase() -- inferred equivalent call

			if v14 == v17 and v15 == phase then
				return
			end

			publish(v17, phase)
		end

		local function requestPublication() -- 2 equivalent calls inferred from this helper
			if not v16 then
				v16 = true
				SignalsScheduler.schedule(fn)
			end
		end

		return {
			id = id,
			viewType = p,
			itemViewType = p,
			signal = signal,
			indexSignal = signal2,
			itemSignal = function(p4)
				local v17 = signal3(p4)
				assert(v17 ~= nil, "RecyclableView: item read before first Assignment")

				if v11 == PlacementKind.Composition then
					return (v17.value(p4))
				end

				return v17.value
			end,
			itemKeySignal = function(p4)
				local v17 = signal3(p4)
				assert(v17 ~= nil, "RecyclableView: item key read before first Assignment")
				return v17.key
			end,
			hasItem = signal4,
			transition = function(data)
				if flag then
					assert(data == nil, "RecyclableView: cannot transition an occupied state after destroy")
					return
				end

				local v17 = v10
				local assignment

				if v17 ~= nil then
					assignment = v17.assignment
				end

				local assignment2

				if data == nil then
					assignment2 = nil
				else
					assignment2 = data.assignment
				end

				local destination

				if v17 ~= nil then
					destination = v17.destination
				end

				local destination2

				if data ~= nil then
					destination2 = data.destination
				end

				local v18

				if destination == nil then
					v18 = false
				elseif
					destination2 == nil
					or destination.kind ~= destination2.kind
					or destination.kind == PlacementKind.List and destination.sink ~= destination2.sink
				then
					v18 = true
				elseif destination.kind == PlacementKind.Composition then
					v18 = destination.placementId ~= destination2.placementId
				else
					v18 = false
				end

				if v18 then
					detachState(v17) -- inferred equivalent call
					v14 = nil
					v15 = nil
				end

				if assignment ~= nil and assignment ~= assignment2 then
					local v19 = v9

					if v19 ~= nil then
						v19.clearSelection()
					end
				end

				v10 = data

				if data ~= nil and v14 == nil then
					publish(data, HostPresentationPhase.Hidden)
				end

				local kind

				if data == nil then
					kind = nil
				else
					kind = data.destination.kind
				end

				local v19

				if assignment2 == nil then
					v19 = false
				else
					v19 = assignment ~= assignment2 or v11 ~= kind
				end

				local v20

				if readiness == RecyclableViewReadiness.ReadyOnCommit and assignment2 ~= nil then
					v20 = assignment ~= assignment2 or not v12
				else
					v20 = false
				end

				if v20 then
					v7 += 1
				end

				local v21

				if assignment2 == nil then
					v21 = false
				elseif readiness == RecyclableViewReadiness.ReadyOnAssignment then
					v21 = true
				else
					v21 = not v20 and v12
				end

				v12 = v21

				SignalsExperimental.batch(function()
					if v19 then
						v11 = kind
						v3(assignment2)

						if not signal4(false) then
							v4(true)
						end
					end

					if v20 then
						v8(v7)
					end

					local v22

					if data ~= nil then
						v22 = data.index
					end

					v2(v22)
					v(assignment2)
					local v23

					if data ~= nil then
						v23 = data.destination.compositionPlacement
					end

					v5(v23)

					if readiness == RecyclableViewReadiness.ReadyOnCommit and (assignment2 == nil or v20) then
						v6(assignment2 ~= nil)
					end

					if data ~= nil then
						requestPublication() -- inferred equivalent call
					end
				end)
			end,
			pending = binding,
			contentRevision = contentRevision,
			commitContent = function(p4: number): boolean
				if flag or readiness ~= RecyclableViewReadiness.ReadyOnCommit or v10 == nil or p4 ~= v7 then
					return false
				end

				v12 = true
				SignalsExperimental.batch(function()
					v6(false)
					requestPublication() -- inferred equivalent call
				end)
				return true
			end,
			setContentMounted = function(flag2: boolean)
				if flag or v13 == flag2 then
					return
				end

				v13 = flag2

				if flag2 and v10 ~= nil then
					SignalsExperimental.batch(requestPublication)
				end
			end,
			readiness = readiness,
			hideWhilePending = hideWhilePending,
			compositionPlacement = signal5,
			portalFrame = function(_)
				return if not flag then frame else nil
			end,
			bindHost = function(p4)
				assert(not flag, "RecyclableView: cannot bind a destroyed host")
				assert(v9 == nil, "RecyclableView: host is already bound")
				v9 = p4
				local v17 = true
				return function()
					if v17 and v9 == p4 then
						v17 = false
						v9 = nil
					end
				end
			end,
			clearSelection = function()
				local v17 = v9

				if v17 ~= nil then
					v17.clearSelection()
				end
			end,
			detachFromPlaceholder = function(p4)
				local v17 = v9

				if v17 ~= nil then
					v17.detachFromPlaceholder(p4)
				end
			end,
			destroy = function()
				if flag then
					return
				end

				flag = true
				detachState(v10) -- inferred equivalent call
				v10 = nil
				v9 = nil
				v6(false)
				frame.Parent = nil
				frame:Destroy()
			end
		}
	end
end

return RecyclableView
