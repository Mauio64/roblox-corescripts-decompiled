local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local Destination = require(script.Parent.Destination)
local Placement = require(script.Parent.Placement)

local PlacementKind = require(script.Parent.PlacementKind)
require(ViewRecyclerReact.Parent.React)
require(script.Parent.RecyclableView)
require(script.Parent.RecyclableViewRegistry)
local Signals = require(ViewRecyclerReact.Parent.Signals)
local vacantHosts

if FFlagViewRecyclerReact084 then
	local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)
	vacantHosts = ViewRecyclerRoblox.Internal.VacantHosts
else
	vacantHosts = nil
end

local function compositeKey(key: string, p: number) -- 3 equivalent calls inferred from this helper
	return `{#key}:{key}:{p}`
end

return {
	new = function(recyclingScope)
		local vacantHosts2 = nil
		local v = nil
		local v2

		if FFlagViewRecyclerReact084 then
			v2 = Placement.new(recyclingScope, {
				name = "CompositionPlacement",
				namespace = "composition"
			})

			vacantHosts2 = vacantHosts.forScope(recyclingScope)
		else
			v2 = nil
			v = nil

			if FFlagViewRecyclerReact08 then
				v2 = Placement.new(recyclingScope, {
					name = "CompositionPlacement",
					namespace = "composition"
				})
			else
				v = ViewRecycler.Adapter.createSlotBinder({
					recyclingScope = recyclingScope,
					prepareDesiredAssignment = function(p)
						local value = p.value
						return {
							key = compositeKey(value.parentAssignment.key, tonumber(p.key)), -- inferred equivalent call
							value = value.itemSignal
						}
					end
				})
			end
		end

		local v3 = {}
		local v4, v5, v6

		if FFlagViewRecyclerReact084 then
			v4 = {}

			v5 = {}
			v6 = nil
		elseif FFlagViewRecyclerReact08 then
			v4 = {}

			v5 = {}
			v6 = nil
		else
			v4 = nil
			v5 = nil
			v6 = {}
		end

		local object = setmetatable({}, { __mode = "k" })
		local v7 = 1
		local set = {}
		local v8 = false
		local v9 = 0
		local v10

		if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
			v10 = nil
		else
			v10 = false
		end

		local flag = false

		local compositionPlacement = nil

		local desiredFor = nil
		local makeState = nil
		local slotFor

		if FFlagViewRecyclerReact084 then
			slotFor = function(placementId: number)
				local v11 = v3[placementId]

				if v11 == nil then
					return nil
				end

				local parentSignal = v11.parentSignal(false)
				local viewType = v11.viewType(false)
				local placeholder = v11.placeholder

				if viewType == nil or parentSignal == nil or placeholder == nil then
					return nil
				end

				local destination = v4[placementId]

				if destination == nil or destination.placeholder ~= placeholder then
					destination = table.freeze({
						kind = Destination.Kind.Composition,
						placementId = placementId,
						placeholder = placeholder,
						automaticSize = Enum.AutomaticSize.XY,
						vacantHosts = vacantHosts2
					})

					v4[placementId] = destination
				end

				local v12 = v5[placementId]
				return {
					key = tostring(placementId),
					viewType = viewType,
					value = v11.itemSignal,
					assignmentKey = compositeKey(parentSignal.key, placementId), -- inferred equivalent call
					changed = v12 ~= nil and v12 ~= parentSignal,
					destination = destination
				}, parentSignal
			end
		else
			slotFor = nil
			desiredFor = nil
			makeState = nil

			if FFlagViewRecyclerReact08 then
				slotFor = function(placementId: number)
					local v11 = v3[placementId]

					if v11 == nil then
						return nil
					end

					local parentSignal = v11.parentSignal(false)
					local viewType = v11.viewType(false)
					local placeholder = v11.placeholder

					if viewType == nil or parentSignal == nil or placeholder == nil then
						return nil
					end

					local destination = v4[placementId]

					if destination == nil or destination.placeholder ~= placeholder then
						destination = table.freeze({
							kind = Destination.Kind.Composition,
							placementId = placementId,
							placeholder = placeholder,
							automaticSize = Enum.AutomaticSize.XY
						})

						v4[placementId] = destination
					end

					local v12 = v5[placementId]
					return {
						key = tostring(placementId),
						viewType = viewType,
						value = v11.itemSignal,
						assignmentKey = compositeKey(parentSignal.key, placementId), -- inferred equivalent call
						changed = v12 ~= nil and v12 ~= parentSignal,
						destination = destination
					}, parentSignal
				end
			else
				desiredFor = function(placementId: number)
					local placement = v3[placementId]

					if placement == nil then
						return nil
					end

					local parentSignal = placement.parentSignal(false)
					local v11 = placement.active

					if v11 == nil then
						v11 = true
					elseif type(v11) == "function" then
						v11 = v11(false)
					end

					if v11 and parentSignal ~= nil and placement.placeholder ~= nil then
						return {
							placementId = placementId,
							placement = placement,
							parentAssignment = parentSignal,
							placeholder = placement.placeholder
						}
					end

					return nil
				end

				makeState = function(p, assignment)
					local frozen = table.freeze({
						kind = PlacementKind.Composition,
						placementId = p.placementId,
						placeholder = p.placeholder,
						automaticSize = Enum.AutomaticSize.XY,
						compositionPlacement = compositionPlacement
					})

					return table.freeze({
						assignment = assignment,
						index = nil,
						destination = frozen
					})
				end
			end
		end

		local function reconcileDirty()
			local v11 = {}

			for k in set do
				table.insert(v11, k)
			end

			table.sort(v11)

			local v12 = not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) and {} or nil

			local v13 = FFlagViewRecyclerReact084 and {} or FFlagViewRecyclerReact08 and {} or nil
			local v14 = {}
			local v15 = {}

			for _, placementId in v11 do
				local v16, v17

				if FFlagViewRecyclerReact084 then
					v16, v17 = slotFor(placementId)
				end

				local v18

				if FFlagViewRecyclerReact084 then
					v18 = v16 ~= nil
				else
					v18 = FFlagViewRecyclerReact08
				end

				if v18 then
					if FFlagViewRecyclerReact084 then
						table.insert(v14, v16)
						v13[placementId] = v17
					else
						local v19, v20 = slotFor(placementId)

						if v19 == nil then
							v4[placementId] = nil
							table.insert(v15, (tostring(placementId)))
						else
							table.insert(v14, v19)
							v13[placementId] = v20
						end
					end
				elseif FFlagViewRecyclerReact084 then
					v4[placementId] = nil
					table.insert(v15, (tostring(placementId)))
				else
					local v19 = desiredFor(placementId)
					local v20 = v6[placementId]

					if v19 == nil then
						if v20 ~= nil then
							table.insert(v15, (tostring(placementId)))
						end
					else
						v12[placementId] = v19
						local v21

						if
							v20 == nil
							or v20.source.parentAssignment ~= v19.parentAssignment
							or v20.source.itemSignal ~= v19.placement.itemSignal
						then
							v21 = table.freeze({
								parentAssignment = v19.parentAssignment,
								itemSignal = v19.placement.itemSignal
							})
						else
							v21 = v20.source
						end

						table.insert(v14, {
							key = tostring(placementId),
							value = v21,
							viewType = v19.placement.viewType,
							placementId = placementId
						})
					end
				end
			end

			table.clear(set)

			local success = nil
			local result = nil
			local success2, result2

			if FFlagViewRecyclerReact084 then
				success2, result2 = pcall(v2.exchange, v15, v14)
			elseif FFlagViewRecyclerReact08 then
				success2, result2 = pcall(v2.exchange, v15, v14)
			else
				success, result = pcall(v.apply, v15, v14)
			end

			if FFlagViewRecyclerReact084 then
				success = success2
			elseif FFlagViewRecyclerReact08 then
				success = success2
			end

			if not success then
				for _, v16 in v11 do
					set[v16] = true
				end

				if not FFlagViewRecyclerReact084 and not FFlagViewRecyclerReact08 then
					result2 = result
				end

				error(result2, 0)
			end

			for _, v16 in v11 do
				if FFlagViewRecyclerReact084 then
					v5[v16] = v13[v16]
				elseif FFlagViewRecyclerReact08 then
					v5[v16] = v13[v16]
				elseif v12[v16] == nil then
					v6[v16] = nil
				end
			end

			if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
				local viewSet = {}

				for _, v16 in result.entered do
					v6[v16.placementId] = { view = v16.view, source = v16.value, state = nil }

					viewSet[v16.view] = true
				end

				for _, v16 in result.updated do
					v6[v16.placementId].source = v16.value
				end

				v10 = true

				for _, v16 in result.departed do
					v16.transition(nil)
				end

				for _, v16 in v11 do
					local v17 = v12[v16]
					local v18 = v6[v16]

					if not (v17 ~= nil and v18 ~= nil) then
						continue
					end

					local assignment = v.get((tostring(v16))).assignment
					local state = v18.state

					if not (viewSet[v18.view] or state == nil or state.assignment ~= assignment or state.destination.placeholder ~= v17.placeholder) then
						continue
					end

					local state2 = makeState(v17, assignment)
					v18.state = state2
					v18.view.transition(state2)
				end

				v10 = false
			end
		end

		local function fn()
			if flag or v8 then
				return
			end

			if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
				assert(not v10, "CompositionPlacement: cannot flush after a publication failure")
			end

			v8 = true
			local success, result = pcall(function()
				while next(set) ~= nil do
					reconcileDirty()
				end
			end)
			v8 = false

			if not success then
				error(result, 0)
			end
		end

		local function fn2()
			if not flag and next(set) ~= nil and v9 == 0 and not v8 then
				fn()
			end
		end

		local function markDirty(p: number) -- 17 equivalent calls inferred from this helper
			if not flag then
				set[p] = true
				fn2()
			end
		end

		local markDirtyOnChange

		if FFlagViewRecyclerReact084 then
			markDirtyOnChange = function(p: number, callback)
				local v11 = nil
				local v12 = false
				return Signals.createEffect(function(p2)
					local v13 = callback(p2)

					if not v12 or v11 ~= v13 then
						v12 = true
						v11 = v13
						markDirty(p) -- inferred equivalent call
					end
				end)
			end
		else
			markDirtyOnChange = FFlagViewRecyclerReact08 and function(p: number, callback)
				local v11 = nil
				local v12 = false
				return Signals.createEffect(function(p2)
					local v13 = callback(p2)

					if not v12 or v11 ~= v13 then
						v12 = true
						v11 = v13
						markDirty(p) -- inferred equivalent call
					end
				end)
			end or nil
		end

		local function fn3(fn4)
			v9 += 1
			local v11 = table.pack(pcall(fn4))
			v9 -= 1

			if not v11[1] then
				error(v11[2], 0)
			end

			fn2()
			return table.unpack(v11, 2, v11.n)
		end

		local fn4

		if FFlagViewRecyclerReact084 then
			fn4 = function(viewType2, p, parentSignal, itemSignal2, placeholder2)
				return fn3(function()
					assert(not flag, "CompositionPlacement: cannot register after destroy")
					local v11 = object[p]

					if v11 == nil then
						v11 = v7
						v7 += 1
						object[p] = v11
					end

					assert(v3[v11] == nil, "CompositionPlacement: placement is already registered")
					local v12 = {
						viewType = viewType2,
						parentSignal = parentSignal,
						itemSignal = itemSignal2,
						placeholder = placeholder2,
						disposeViewTypeEffect = nil,
						disposeParentAssignmentEffect = nil
					}

					v3[v11] = v12
					v12.disposeViewTypeEffect = markDirtyOnChange(v11, viewType2)
					v12.disposeParentAssignmentEffect = markDirtyOnChange(v11, parentSignal)
					markDirty(v11) -- inferred equivalent call
					local v13 = true
					return {
						setViewType = function(viewType)
							fn3(function()
								if not v13 or flag or v12.viewType == viewType then
									return
								end

								if v12.disposeViewTypeEffect ~= nil then
									v12.disposeViewTypeEffect()
								end

								v12.viewType = viewType
								v12.disposeViewTypeEffect = markDirtyOnChange(v11, viewType)
							end)
						end,
						setPlaceholder = function(placeholder)
							fn3(function()
								if v13 and not flag and v12.placeholder ~= placeholder then
									v12.placeholder = placeholder
									markDirty(v11) -- inferred equivalent call
								end
							end)
						end,
						setItemSignal = function(itemSignal)
							fn3(function()
								if v13 and not flag and v12.itemSignal ~= itemSignal then
									v12.itemSignal = itemSignal
									markDirty(v11) -- inferred equivalent call
								end
							end)
						end,
						unregister = function()
							fn3(function()
								if not v13 then
									return
								end

								v13 = false

								if flag then
									return
								end

								if v12.disposeViewTypeEffect ~= nil then
									v12.disposeViewTypeEffect()
								end

								if v12.disposeParentAssignmentEffect ~= nil then
									v12.disposeParentAssignmentEffect()
								end

								v3[v11] = nil
								markDirty(v11) -- inferred equivalent call
							end)
						end
					}
				end)
			end
		elseif FFlagViewRecyclerReact08 then
			fn4 = function(viewType2, p, parentSignal, itemSignal2, placeholder2)
				return fn3(function()
					assert(not flag, "CompositionPlacement: cannot register after destroy")
					local v11 = object[p]

					if v11 == nil then
						v11 = v7
						v7 += 1
						object[p] = v11
					end

					assert(v3[v11] == nil, "CompositionPlacement: placement is already registered")

					local v12 = {
						viewType = viewType2,
						parentSignal = parentSignal,
						itemSignal = itemSignal2,
						placeholder = placeholder2,
						disposeViewTypeEffect = nil,
						disposeParentAssignmentEffect = nil
					}

					v3[v11] = v12
					v12.disposeViewTypeEffect = markDirtyOnChange(v11, viewType2)
					v12.disposeParentAssignmentEffect = markDirtyOnChange(v11, parentSignal)
					markDirty(v11) -- inferred equivalent call
					local v13 = true
					return {
						setViewType = function(viewType)
							fn3(function()
								if not v13 or flag or v12.viewType == viewType then
									return
								end

								if v12.disposeViewTypeEffect ~= nil then
									v12.disposeViewTypeEffect()
								end

								v12.viewType = viewType
								v12.disposeViewTypeEffect = markDirtyOnChange(v11, viewType)
							end)
						end,
						setPlaceholder = function(placeholder)
							fn3(function()
								if v13 and not flag and v12.placeholder ~= placeholder then
									v12.placeholder = placeholder
									markDirty(v11) -- inferred equivalent call
								end
							end)
						end,
						setItemSignal = function(itemSignal)
							fn3(function()
								if v13 and not flag and v12.itemSignal ~= itemSignal then
									v12.itemSignal = itemSignal
									markDirty(v11) -- inferred equivalent call
								end
							end)
						end,
						unregister = function()
							fn3(function()
								if not v13 then
									return
								end

								v13 = false

								if flag then
									return
								end

								if v12.disposeViewTypeEffect ~= nil then
									v12.disposeViewTypeEffect()
								end

								if v12.disposeParentAssignmentEffect ~= nil then
									v12.disposeParentAssignmentEffect()
								end

								v3[v11] = nil
								markDirty(v11) -- inferred equivalent call
							end)
						end
					}
				end)
			end
		else
			fn4 = function(viewType, p, parentSignal, itemSignal2, placeholder2, active2)
				return fn3(function()
					assert(not flag, "CompositionPlacement: cannot register after destroy")
					local v11 = object[p]

					if v11 == nil then
						v11 = v7
						v7 += 1
						object[p] = v11
					end

					assert(v3[v11] == nil, "CompositionPlacement: placement is already registered")

					local v12 = {
						viewType = viewType,
						parentSignal = parentSignal,
						itemSignal = itemSignal2,
						placeholder = placeholder2,
						active = active2,
						disposeActiveEffect = nil,
						disposeParentAssignmentEffect = nil
					}

					v3[v11] = v12
					local function subscribeActive() -- 2 equivalent calls inferred from this helper
						if type(v12.active) == "function" then
							v12.disposeActiveEffect = Signals.createEffect(function(p2)
								v12.active(p2)
								markDirty(v11) -- inferred equivalent call
							end)
						end
					end

					subscribeActive() -- inferred equivalent call
					local v13 = nil
					local v14 = false
					v12.disposeParentAssignmentEffect = Signals.createEffect(function(p2)
						local v15 = parentSignal(p2)

						if not v14 or v13 ~= v15 then
							v14 = true
							v13 = v15
							markDirty(v11) -- inferred equivalent call
						end
					end)
					markDirty(v11) -- inferred equivalent call
					local v15 = true
					return {
						setActive = function(active)
							fn3(function()
								if not v15 or flag or v12.active == active then
									return
								end

								if v12.disposeActiveEffect ~= nil then
									v12.disposeActiveEffect()
									v12.disposeActiveEffect = nil
								end

								v12.active = active
								subscribeActive() -- inferred equivalent call
								markDirty(v11) -- inferred equivalent call
							end)
						end,
						setPlaceholder = function(placeholder)
							fn3(function()
								if v15 and not flag and v12.placeholder ~= placeholder then
									v12.placeholder = placeholder
									markDirty(v11) -- inferred equivalent call
								end
							end)
						end,
						setItemSignal = function(itemSignal)
							fn3(function()
								if v15 and not flag and v12.itemSignal ~= itemSignal then
									v12.itemSignal = itemSignal
									markDirty(v11) -- inferred equivalent call
								end
							end)
						end,
						unregister = function()
							fn3(function()
								if not v15 then
									return
								end

								v15 = false

								if flag then
									return
								end

								if v12.disposeActiveEffect ~= nil then
									v12.disposeActiveEffect()
								end

								if v12.disposeParentAssignmentEffect ~= nil then
									v12.disposeParentAssignmentEffect()
								end

								v3[v11] = nil
								markDirty(v11) -- inferred equivalent call
							end)
						end
					}
				end)
			end
		end

		local v11 = {
			register = fn4,
			destroy = function()
				if flag then
					return
				end

				flag = true
				table.clear(set)

				if FFlagViewRecyclerReact084 then
					for _, v11 in v3 do
						if v11.disposeViewTypeEffect ~= nil then
							v11.disposeViewTypeEffect()
						end

						if v11.disposeParentAssignmentEffect ~= nil then
							v11.disposeParentAssignmentEffect()
						end
					end

					v2.destroy()
				elseif FFlagViewRecyclerReact08 then
					for _, v11 in v3 do
						if v11.disposeViewTypeEffect ~= nil then
							v11.disposeViewTypeEffect()
						end

						if v11.disposeParentAssignmentEffect ~= nil then
							v11.disposeParentAssignmentEffect()
						end
					end

					v2.destroy()
				else
					for _, v11 in v3 do
						if v11.disposeActiveEffect ~= nil then
							v11.disposeActiveEffect()
						end

						if v11.disposeParentAssignmentEffect ~= nil then
							v11.disposeParentAssignmentEffect()
						end
					end

					for _, v11 in v6 do
						v11.view.transition(nil)
					end

					v.destroy()
				end

				table.clear(v3)
				local v11

				if FFlagViewRecyclerReact084 then
					v11 = v4
				else
					v11 = if FFlagViewRecyclerReact08 then v4 else v6
				end

				table.clear(v11)

				if FFlagViewRecyclerReact084 then
					table.clear(v5)
				elseif FFlagViewRecyclerReact08 then
					table.clear(v5)
				end
			end,
			flush = 0
		}
		local flush

		if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
			flush = fn
		end

		v11.flush = flush
		compositionPlacement = v11

		return compositionPlacement
	end
}
