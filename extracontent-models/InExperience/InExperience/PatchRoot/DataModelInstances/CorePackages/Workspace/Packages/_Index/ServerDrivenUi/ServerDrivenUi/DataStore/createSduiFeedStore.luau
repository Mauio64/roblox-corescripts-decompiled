local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local Signals = require(ServerDrivenUiParent.Signals)

require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)

local DiscoveryEventErrorLogger = require(ServerDrivenUiParent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagSduiGetItemCollectionKeys = require(ServerDrivenUi.Flags).FFlagSduiGetItemCollectionKeys
local FFlagLuaAppRfySignalApportioning = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppRfySignalApportioning
local v7 = game:DefineFastFlag("LuaAppNilApportionedItems", false)
local FFlagLuaAppAddRequestIdToRfySignalApportioning = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppAddRequestIdToRfySignalApportioning
local v9 = game:DefineFastInt("SduiCreateSduiFeedStoreLogDelayMs", 1000) / 1000

local function createSduiFeedStore() -- line: 29
	-- upvalues: Signals (copy), FFlagSduiGetItemCollectionKeys (copy), FFlagLuaAppRfySignalApportioning (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v9 (copy), DiscoveryEventErrorLogger (copy), v7 (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local v14, v15 = Signals.createSignal({})
	local v16, v17 = Signals.createSignal(0)
	local v18 = nil
	local u19 = nil

	if FFlagSduiGetItemCollectionKeys then
		local v20

		v18, v20 = Signals.createSignal({})
		u19 = v20
	end

	local function createItemCollectionSignal(s1: string, p1) -- line: 61
		-- upvalues: Signals (copy), t1 (copy)
		local v33, v34 = Signals.createSignal(p1)

		t1[s1] = {
			get = v33,
			set = v34
		}

		return t1[s1]
	end
	local function setItemCollections(t4: {[any]: any}) -- line: 97
		-- upvalues: t1 (copy), Signals (copy)
		for v44, v45 in t4 do
			if t1[v44] then
				t1[v44].set(v45)
			else
				local v46, v47 = Signals.createSignal(v45)

				t1[v44] = {
					get = v46,
					set = v47
				}

				local _ = t1[v44]
			end
		end
	end

	local setApportioningData = nil
	local updateApportioningCapacity = nil
	local getSingleGridApportioningMetadata = nil
	local getApportionedItems = nil

	if FFlagLuaAppRfySignalApportioning then
		local v27 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else function(s2: string, s3: string?) -- line: 110
			if s3 then
				return s2 .. "_" .. s3
			end

			return s2
		end

		local function createApportioningDataSignals(s4: string, t5: {[any]: any}, s5: string?) -- line: 119
			-- upvalues: FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v27 (copy), Signals (copy), t2 (copy), t3 (copy)
			local v54 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then s4 else v27(s4, s5)
			local v55, v56 = Signals.createSignal(t5.items)
			local v57, v58 = Signals.createSignal(t5.gridApportioningMetadata)
			local t6 = {
				isCapacityUpdateScheduled = false,
				capacityUpdateCoroutine = nil,
				getItems = v55,
				setItems = v56,
				getGridApportioningMetadata = v57,
				setGridApportioningMetadata = v58,
				scheduledCapacityUpdates = {}
			}
			local v60, v61 = Signals.createSignal(t6)

			t2[v54] = {
				get = v60,
				set = v61
			}

			if FFlagLuaAppAddRequestIdToRfySignalApportioning then
				local v62 = t3[s4] and t3[s4].previousKey
				local v63 = t3[s4] and t3[s4].currentKey

				if v62 then
					t2[v62] = nil
				end

				t3[s4] = {
					previousKey = v63,
					currentKey = v54
				}
			end
		end
		local function v29(s6: string, s7: string?) -- line: 167
			-- upvalues: FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v27 (copy), t2 (copy), createApportioningDataSignals (copy)
			local v66 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then s6 else v27(s6, s7)

			if not t2[v66] then
				createApportioningDataSignals(s6, {
					items = {},
					gridApportioningMetadata = {}
				}, if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s7)
			end

			return t2[v66].get
		end

		function setApportioningData(t7: {[any]: any}, s8: string?) -- line: 185
			-- upvalues: FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v27 (copy), t2 (copy), createApportioningDataSignals (copy)
			for v69, v70 in t7 do
				local v71 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then v69 else v27(v69, s8)

				if t2[v71] then
					local v72 = t2[v71].get(false)

					v72.setItems(v70.items)
					v72.setGridApportioningMetadata(v70.gridApportioningMetadata)
					v72.scheduledCapacityUpdates = {}
					v72.isCapacityUpdateScheduled = false

					if v72.capacityUpdateCoroutine then
						task.cancel(v72.capacityUpdateCoroutine)
						v72.capacityUpdateCoroutine = nil
					end
				else
					createApportioningDataSignals(v69, v70, if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s8)
				end
			end
		end

		local function updateGridApportioningMetadata(s9: string, s10: string?) -- line: 220
			-- upvalues: v29 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v27 (copy), v9 (copy), t2 (copy), DiscoveryEventErrorLogger (copy)
			local v75 = v29(s9, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s10))(false)
			local v76 = v75.getGridApportioningMetadata(false)
			local scheduledCapacityUpdates = v75.scheduledCapacityUpdates

			if #v76 == 0 then
				local v78 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then s9 else v27(s9, s10)

				task.delay(v9, function() -- line: 236
					-- upvalues: t2 (copy), v78 (copy), DiscoveryEventErrorLogger (copy)
					local v99 = t2[v78].get(false)

					if #(v99 and v99.getGridApportioningMetadata(false) or {}) == 0 then
						DiscoveryEventErrorLogger.reportError("ApportioningEmptyGridMetadata", `Apportioning grid metadata is empty for { v78 } in updateGridApportioningMetadata`, {
							apportioningKey = v78
						})
					end
				end)

				return
			end

			local n1 = 1
			local t8 = {}

			for _, v82 in v76 do
				local v83 = if not scheduledCapacityUpdates[v82.sortIndex] then v82.capacity else scheduledCapacityUpdates[v82.sortIndex]

				table.insert(t8, {
					sortIndex = v82.sortIndex,
					startingItemIndex = n1,
					capacity = v83
				})
				n1 += v83
			end

			v75.setGridApportioningMetadata(t8)
		end

		function updateApportioningCapacity(s11: string, n2: number, n3: number, s12: string?) -- line: 276
			-- upvalues: v29 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), updateGridApportioningMetadata (copy)
			local v88 = v29(s11, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s12))(false)

			v88.scheduledCapacityUpdates[n2] = n3

			if not v88.isCapacityUpdateScheduled then
				v88.isCapacityUpdateScheduled = true
				v88.capacityUpdateCoroutine = task.defer(function() -- line: 291
					-- upvalues: updateGridApportioningMetadata (copy), s11 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), s12 (copy), v88 (copy)
					updateGridApportioningMetadata(s11, if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s12)
					v88.scheduledCapacityUpdates = {}
					v88.isCapacityUpdateScheduled = false
					v88.capacityUpdateCoroutine = nil
				end)
			end
		end
		function getSingleGridApportioningMetadata(s13: string, n4: number, s14: string?) -- line: 303
			-- upvalues: Signals (copy), v29 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v9 (copy), v27 (copy), t2 (copy), DiscoveryEventErrorLogger (copy)
			return Signals.createComputed(function(p2) -- line: 304
				-- upvalues: v29 (copy), s13 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), s14 (copy), v9 (copy), v27 (copy), t2 (copy), DiscoveryEventErrorLogger (copy), n4 (copy)
				local v101 = v29(s13, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s14))(p2).getGridApportioningMetadata(p2)

				if #v101 == 0 then
					task.delay(v9, function() -- line: 315
						-- upvalues: FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v27 (copy), s13 (copy), s14 (copy), t2 (copy), DiscoveryEventErrorLogger (copy), n4 (copy)
						local v113 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then s13 else v27(s13, s14)
						local v114 = t2[v113].get(false)

						if #(v114 and v114.getGridApportioningMetadata(false) or {}) == 0 then
							DiscoveryEventErrorLogger.reportError("ApportioningEmptyGridMetadata", `Apportioning grid metadata is empty for { v113 } in getSingleGridApportioningMetadata`, {
								apportioningKey = v113,
								sortIndex = n4
							})
						end
					end)

					return nil
				end

				for _, v103 in v101 do
					if v103.sortIndex == n4 then
						return v103
					end
				end

				return nil
			end)
		end
		function getApportionedItems(s15: string, n5: number, s16: string?) -- line: 346
			-- upvalues: Signals (copy), v29 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), getSingleGridApportioningMetadata (ref), v27 (copy), v9 (copy), t2 (copy), DiscoveryEventErrorLogger (copy), v7 (copy)
			return Signals.createComputed(function(p3) -- line: 347
				-- upvalues: v29 (copy), s15 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), s16 (copy), getSingleGridApportioningMetadata (ref), n5 (copy), v27 (copy), v9 (copy), t2 (copy), DiscoveryEventErrorLogger (copy), v7 (copy)
				local v105 = v29(s15, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s16))(p3)
				local v106 = v105.getItems(p3)
				local v107 = getSingleGridApportioningMetadata(s15, n5, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s16))(p3)

				if #v106 == 0 and #v105.getGridApportioningMetadata(false) == 0 then
					local v108 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then s15 else v27(s15, s16)

					task.delay(v9, function() -- line: 365
						-- upvalues: t2 (copy), v108 (copy), DiscoveryEventErrorLogger (copy), n5 (copy)
						local v115 = t2[v108].get(false)
						local v116 = v115 and v115.getItems(false) or {}
						local v117 = v115 and v115.getGridApportioningMetadata(false) or {}

						if #v116 == 0 and #v117 == 0 then
							DiscoveryEventErrorLogger.reportError("ApportioningEmptyData", `All apportioning data is empty for { v108 } in getApportionedItems`, {
								apportioningKey = v108,
								sortIndex = n5
							})
						end
					end)

					if v7 then
						return nil
					end

					return {}
				end

				if not v107 then
					local u109 = nil

					task.delay(v9, function() -- line: 386
						-- upvalues: FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), v27 (copy), s15 (copy), s16 (copy), getSingleGridApportioningMetadata (ref), n5 (copy), t2 (copy), u109 (ref), DiscoveryEventErrorLogger (copy)
						local v118 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning then s15 else v27(s15, s16)

						if not getSingleGridApportioningMetadata(s15, n5, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s16))(false) then
							local v119 = t2[v118].get(false)
							local t9 = {}

							for _, v122 in v119 and v119.getGridApportioningMetadata(false) or {} do
								table.insert(t9, v122.sortIndex)
							end

							u109 = not (#t9 > 0) and "none" or table.concat(t9, ",")
							DiscoveryEventErrorLogger.reportError("ApportioningSortIndexNotFound", `Sort index { n5 } not found in apportioning data for { v118 }`, {
								apportioningKey = v118,
								sortIndex = n5,
								availableSortIndices = u109
							})
						end
					end)

					return {}
				end

				local startingItemIndex = v107.startingItemIndex
				local t10 = {}

				for i = startingItemIndex, math.min(startingItemIndex + v107.capacity - 1, #v106) do
					table.insert(t10, v106[i])
				end

				return t10
			end)
		end
	end

	return {
		getFirstItemCollectionWithFilter = function(p4: ((...any) -> ...any)) -- line: 85
			-- upvalues: t1 (copy)
			for _, v42 in t1 do
				if p4(v42.get(false)) then
					return v42.get
				end
			end

			return nil
		end,
		getItemCollection = function(s17: string, b1: boolean?) -- line: 70
			-- upvalues: t1 (copy), Signals (copy)
			local v37 = t1[s17]

			if v37 == nil then
				if b1 then
					local v38, v39 = Signals.createSignal(nil)

					t1[s17] = {
						get = v38,
						set = v39
					}
					v37 = t1[s17]
				else
					error(`createSduiFeedStore missing item collection for feedItemKey { s17 }`)
				end
			end

			return v37.get
		end,
		getTemplates = v14,
		getDataUpdatedTimestamp = v16,
		getItemCollectionKeys = if not FFlagSduiGetItemCollectionKeys then nil else v18,
		updateApportioningCapacity = if not FFlagLuaAppRfySignalApportioning then nil else updateApportioningCapacity,
		getSingleGridApportioningMetadata = if not FFlagLuaAppRfySignalApportioning then nil else getSingleGridApportioningMetadata,
		getApportionedItems = if not FFlagLuaAppRfySignalApportioning then nil else getApportionedItems,
		updateData = function(p5, s18: string?) -- line: 435
			-- upvalues: v15 (copy), v17 (copy), setItemCollections (copy), FFlagSduiGetItemCollectionKeys (copy), u19 (ref), FFlagLuaAppRfySignalApportioning (copy), setApportioningData (ref), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy)
			if p5.templates then
				v15(p5.templates)
			end

			if p5.dataUpdatedTimestamp then
				v17(p5.dataUpdatedTimestamp)
			end

			if p5.itemCollections then
				setItemCollections(p5.itemCollections)

				if FFlagSduiGetItemCollectionKeys then
					local t11 = {}

					for v98 in p5.itemCollections do
						table.insert(t11, v98)
					end

					u19(t11)
				end
			end

			if FFlagLuaAppRfySignalApportioning and p5.apportioningData then
				setApportioningData(p5.apportioningData, if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else s18)
			end
		end
	}
end

return createSduiFeedStore
