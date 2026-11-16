local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

local AbsolutePlacement = require(ViewRecyclerRoblox.RobloxAdapter.AbsolutePlacement)
local CanvasItemPlacer = require(ViewRecyclerRoblox.RobloxAdapter.CanvasItemPlacer)
local HostMeasurement = require(ViewRecyclerRoblox.RobloxAdapter.HostMeasurement)
local HostPresentationPhase = require(ViewRecyclerRoblox.RobloxAdapter.HostPresentationPhase)
local ReparentableHost = require(ViewRecyclerRoblox.RobloxAdapter.ReparentableHost)
local StackPlacement = require(ViewRecyclerRoblox.RobloxAdapter.StackPlacement)

local function zero(): number
	return 0
end

return {
	new = function(data)
		local v = {
			container = data.container,
			viewportContainer = data.viewportContainer,
			axis = data.axis,
			selfSizing = data.selfSizing,
			stackedSpacing = data.stackedSpacing
		}

		local v2 = {}
		local v3 = nil
		local v4 = nil
		local v5 = false
		local trackedItemViewCount = 0
		local flag = false
		local getCanvasOriginOffset = data.getCanvasOriginOffset or zero
		local v6 = AbsolutePlacement.new(v.axis, v.selfSizing, getCanvasOriginOffset)

		local function commitStack() -- 2 equivalent calls inferred from this helper
			if v3 ~= nil and not v5 then
				v3.commit()
			end
		end

		local function isUnchanged()
			local v7 = v3
			local v8 = v7 == nil or not v7.takeChanged()

			for _, v9 in v2 do
				local host = v9.host

				if not (v9.measuring and host ~= nil and (v7 == nil or not v7.isStacked(host))) then
					continue
				end

				local absoluteSize = host.AbsoluteSize

				if v9.checkedSize == absoluteSize then
					continue
				end

				v9.checkedSize = absoluteSize
				v8 = false
			end

			return v8
		end

		local v7 = HostMeasurement.new({
			axis = v.axis,
			isUnchanged = isUnchanged,
			onItemMeasurements = data.onItemMeasurements
		})

		local function stopMeasuring(p, state) -- 1 equivalent call inferred from this helper
			state.checkedSize = nil

			if state.measuring then
				state.measuring = false
				v7.measure(p, nil, nil)
			end
		end

		local function detachHost(p, state)
			local host = state.host

			if host ~= nil then
				if v3 ~= nil then
					v3.remove(host)
				end

				ReparentableHost.clearSelection(host)
				CanvasItemPlacer.detachForTransfer(host, state.placerState)
				v6.remove(host)
				state.host = nil
			end

			stopMeasuring(p, state) -- inferred equivalent call
		end

		local function getEntry(p) -- 1 equivalent call inferred from this helper
			local entry = v2[p]

			if entry == nil then
				entry = {
					placerState = CanvasItemPlacer.createState(),
					host = nil,
					physicalState = nil,
					presentedAssignment = nil,
					measuring = false,
					checkedSize = nil
				}

				v2[p] = entry
				trackedItemViewCount += 1
			end

			return entry
		end

		local function reportPresentation(p, state, presentedAssignment) -- 3 equivalent calls inferred from this helper
			if state.presentedAssignment == presentedAssignment then
				return
			end

			state.presentedAssignment = presentedAssignment
			local onItemViewPresentationChanged = data.onItemViewPresentationChanged

			if onItemViewPresentationChanged ~= nil then
				onItemViewPresentationChanged(p, presentedAssignment)
			end
		end

		local function applyPhysical(p, state)
			local physicalState = state.physicalState

			if physicalState == nil then
				detachHost(p, state)
				reportPresentation(p, state) -- inferred equivalent call
			else
				local state2 = physicalState.state
				local host = physicalState.host

				if state.host ~= nil and state.host ~= host then
					detachHost(p, state)
				end

				local v8

				if FFlagViewRecyclerReact08 then
					v8 = state2.viewportPlacement ~= nil
				elseif state2.viewportPlacement == nil then
					v8 = false
				else
					v8 = v.viewportContainer ~= nil
				end

				local v9

				if v8 then
					v9 = v.viewportContainer
				else
					v9 = v.container
				end

				if v9 == nil then
					detachHost(p, state)
					reportPresentation(p, state) -- inferred equivalent call
				else
					local v10 = v3
					local v11

					if v10 == nil or v8 or not StackPlacement.isPlacedFromLayoutOffsets(state2) then
						if v10 ~= nil then
							v10.remove(host)
						end

						v11 = v6.place(host, state.placerState, v9, state2, not v8, physicalState.phase)
					else
						v11 = v10.place(host, state.placerState, state2, physicalState.phase)
						v6.remove(host)
					end

					if not v11 then
						ReparentableHost.clearSelection(host)
					end

					state.host = host
					local v12 = physicalState.phase == HostPresentationPhase.Presented
					local selfSizing = v.selfSizing or state2.pinnedPosition ~= nil
					local measuring = v12 and selfSizing
					state.measuring = measuring

					if selfSizing and not v12 then
						v7.pause(p, host)
					else
						local measure = v7.measure
						local v13

						if measuring then
							v13 = state2
						end

						measure(p, host, v13)
					end

					local v13

					if v12 then
						v13 = state2.assignment
					end

					reportPresentation(p, state, v13) -- inferred equivalent call
				end
			end
		end

		local function syncStack()
			local container = v.container
			local stackedSpacing = v.stackedSpacing
			local v8 = v3
			local v9

			if stackedSpacing == nil then
				v9 = false
			else
				v9 = container ~= nil
			end

			if v8 ~= nil and v9 and v8.matches(container, v.axis, stackedSpacing, v.selfSizing) then
				return
			end

			if v8 ~= nil then
				for k, v10 in v2 do
					if v10.host ~= nil and v8.isStacked(v10.host) then
						detachHost(k, v10)
					end
				end

				v8.destroy()
				v3 = nil
			end

			if v9 then
				local v10 = StackPlacement.new(container, v.axis, stackedSpacing, v.selfSizing)

				if v4 ~= nil then
					v10.setWindow(v4, getCanvasOriginOffset())
				end

				v3 = v10
			end
		end

		local function releaseEntryIfVacant(p, entry) -- 1 equivalent call inferred from this helper
			if entry.physicalState == nil and v2[p] == entry then
				v2[p] = nil
				trackedItemViewCount -= 1
			end
		end

		syncStack()

		return {
			apply = function(p, physicalState)
				assert(not flag, "HostPlacement: cannot apply physical state after destroy")
				local entry = getEntry(p) -- inferred equivalent call
				entry.physicalState = physicalState
				applyPhysical(p, entry)
				releaseEntryIfVacant(p, entry) -- inferred equivalent call
				commitStack() -- inferred equivalent call
			end,
			setConfiguration = function(p)
				if not flag then
					v = p
					v7.setAxis(v.axis)
					v6.setConfiguration(v.axis, v.selfSizing)
					syncStack()

					for k, v8 in v2 do
						applyPhysical(k, v8)
					end

					commitStack() -- inferred equivalent call
				end
			end,
			reposition = function()
				if flag then
					return
				end

				local canvasOriginOffset = getCanvasOriginOffset()
				v6.setOriginOffset(canvasOriginOffset)

				if v3 ~= nil then
					v3.setOriginOffset(canvasOriginOffset)
				end
			end,
			setMountedWindow = function(p, callback)
				if flag then
					callback()
					return
				end

				v4 = p
				local v8 = v3

				if v8 == nil then
					callback()
					return
				end

				v8.setWindow(p, getCanvasOriginOffset())
				v5 = true
				local success, result = pcall(callback)
				v5 = false

				if v3 == v8 then
					local set = {}

					for _, v9 in v8.getStaleHosts() do
						set[v9] = true
					end

					for k, v9 in v2 do
						if v9.host ~= nil and set[v9.host] then
							applyPhysical(k, v9)
						end
					end

					v8.commit()
				end

				if not success then
					error(result, 0)
				end
			end,
			cancelPendingMeasurements = function()
				v7.cancelPending()
			end,
			hasDestroyedHost = FFlagViewRecyclerReact08 and function(): boolean
				for _, v8 in v2 do
					if v8.host ~= nil and v8.host.Parent == nil then
						return true
					end
				end

				return false
			end or nil,
			getTrackedItemViewCount = function()
				return trackedItemViewCount
			end,
			isPrePaintPassConnected = function()
				return v7.isPassConnected()
			end,
			getPrePaintReadCount = function()
				return v7.getPassReadCount()
			end,
			destroy = function()
				if flag then
					return
				end

				flag = true
				v7.destroy()

				for k, v8 in v2 do
					detachHost(k, v8)
				end

				v6.destroy()

				if v3 ~= nil then
					v3.destroy()
					v3 = nil
				end

				table.clear(v2)
				trackedItemViewCount = 0
			end
		}
	end
}
