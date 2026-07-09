local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Signals = require(SduiCoreSystemParent.Signals)
local CollectionViews = require(SduiCoreSystemParent.CollectionViews)
local FFlagLuaAppEnableNxMRoduxApportioning = require(SduiCoreSystemParent.SharedFlags).FFlagLuaAppEnableNxMRoduxApportioning

require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)

local SduiPoolStoreLayout = require(SduiCoreSystem.ClientBinding.SduiPoolStoreLayout)
local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore
local processOneGrid = CollectionViews.processOneGrid
local makePoolGetSpanConfig = SduiPoolStoreLayout.makePoolGetSpanConfig
local layoutToCells = SduiPoolStoreLayout.layoutToCells
local cellsEqual = SduiPoolStoreLayout.cellsEqual
local EMPTY_CELLS = SduiPoolStoreLayout.EMPTY_CELLS
local v13 = table.freeze({})

local function sectionConfigsEqual(t1: {[any]: any}?, t2: {[any]: any}?) -- line: 69
	if t1 == t2 then
		return true
	end

	if t1 == nil or t2 == nil then
		return false
	end

	return t1.poolId == t2.poolId and (t1.numberOfRows == t2.numberOfRows and (t1.prevSectionInPoolId == t2.prevSectionInPoolId and t1.prevSectionId == t2.prevSectionId))
end
local function createSduiPoolStore() -- line: 82
	-- upvalues: Signals (copy), sectionConfigsEqual (copy), getMainCollectionLayoutStore (copy), v13 (copy), EMPTY_CELLS (copy), makePoolGetSpanConfig (copy), processOneGrid (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), layoutToCells (copy), cellsEqual (copy)
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local v25, v26 = Signals.createSignal(nil)

	local function getOrCreatePoolSignal(s1: string) -- line: 96
		-- upvalues: t3 (copy), Signals (copy)
		local v36 = t3[s1]

		if v36 == nil then
			local v37, v38 = Signals.createSignal(nil)

			v36 = {
				get = v37,
				set = v38
			}
			t3[s1] = v36
		end

		return v36
	end
	local function getOrCreateSectionConfigSignal(s2: string) -- line: 106
		-- upvalues: t4 (copy), Signals (copy), sectionConfigsEqual (copy)
		local v40 = t4[s2]

		if v40 == nil then
			local v41, v42 = Signals.createSignal(nil, sectionConfigsEqual)

			v40 = {
				get = v41,
				set = v42
			}
			t4[s2] = v40
		end

		return v40
	end
	local function u29(s3: string) -- line: 119
		-- upvalues: t5 (copy), Signals (copy), t4 (copy), sectionConfigsEqual (copy), t3 (copy), v25 (copy), getMainCollectionLayoutStore (copy), v13 (copy), u29 (ref), EMPTY_CELLS (copy), makePoolGetSpanConfig (copy), processOneGrid (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), layoutToCells (copy)
		local v44 = t5[s3]

		if v44 ~= nil then
			return v44
		end

		local v45 = Signals.createComputed(function(p1) -- line: 124
			-- upvalues: s3 (copy), t4 (copy), Signals (copy), sectionConfigsEqual (copy), t3 (copy), v25 (copy), getMainCollectionLayoutStore (copy), v13 (copy), u29 (ref), EMPTY_CELLS (copy), makePoolGetSpanConfig (copy), processOneGrid (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), layoutToCells (copy)
			local v75 = s3
			local v76 = t4[v75]

			if v76 == nil then
				local v77, v78 = Signals.createSignal(nil, sectionConfigsEqual)

				v76 = {
					get = v77,
					set = v78
				}
				t4[v75] = v76
			end

			local v79 = v76.get(p1)

			if v79 == nil or v79.poolId == nil then
				return nil
			end

			local poolId = v79.poolId
			local v81 = t3[poolId]

			if v81 == nil then
				local v82, v83 = Signals.createSignal(nil)

				v81 = {
					get = v82,
					set = v83
				}
				t3[poolId] = v81
			end

			local v84 = v81.get(p1)

			if v84 == nil or #v84.items == 0 then
				return nil
			end

			local v85 = v25(p1) or getMainCollectionLayoutStore(p1)
			local v86 = (typeof(v84.collectionItemSize) ~= "string" or v85.getItemsPerRow[v84.collectionItemSize] == nil) and "Medium" or v84.collectionItemSize
			local v87 = v85.getItemsPerRow[v86](p1)

			if v87 <= 0 then
				return nil
			end

			local n1 = 1
			local v89 = v13

			if v79.prevSectionInPoolId ~= nil then
				local v90 = u29(v79.prevSectionInPoolId)(p1)

				if v90 == nil then
					return nil
				end

				n1 = v90.nextStartIndex
				v89 = v90.pendingSpanTiles
			end

			local numberOfRows = v79.numberOfRows

			if numberOfRows <= 0 then
				numberOfRows = 1e999
			end

			if v84.layouts == nil and #v89 == 0 then
				local v92 = math.max(0, #v84.items - n1 + 1)
				local v93 = math.min(if numberOfRows ~= 1e999 then numberOfRows * v87 else v92, v92)

				if v93 == 0 then
					return {
						actualRowCount = 0,
						cells = EMPTY_CELLS,
						nextStartIndex = n1,
						pendingSpanTiles = v13
					}
				end

				local v94 = math.ceil(v93 / v87)
				local t9 = {}

				for i = 0, v93 - 1 do
					local v97 = n1 + i

					t9[i + 1] = {
						item = v84.items[v97],
						realIndex = v97
					}
				end

				for i = v93 + 1, v94 * v87 do
					t9[i] = {}
				end

				return {
					cells = t9,
					actualRowCount = v94,
					nextStartIndex = n1 + v93,
					pendingSpanTiles = v13
				}
			end

			local v99 = if v84.layouts == nil then nil else makePoolGetSpanConfig(v84.layouts)
			local v100 = processOneGrid(v84.items, n1, v89, v87, numberOfRows, v99, not FFlagLuaAppEnableNxMRoduxApportioning)
			local v101, v102 = layoutToCells(v100.layout, v87, v84.items, v84.layouts)

			return {
				cells = v101,
				actualRowCount = v102,
				nextStartIndex = v100.nextStartIndex,
				pendingSpanTiles = v100.pendingSpanTiles
			}
		end)

		t5[s3] = v45

		return v45
	end
	local function getRowCountComputed(s4: string) -- line: 217
		-- upvalues: t6 (copy), Signals (copy), t4 (copy), sectionConfigsEqual (copy), u29 (ref)
		local v47 = t6[s4]

		if v47 ~= nil then
			return v47
		end

		local v48 = Signals.createComputed(function(p2) -- line: 222
			-- upvalues: s4 (copy), t4 (copy), Signals (copy), sectionConfigsEqual (copy), u29 (ref)
			local v104 = s4
			local v105 = t4[v104]

			if v105 == nil then
				local v106, v107 = Signals.createSignal(nil, sectionConfigsEqual)

				v105 = {
					get = v106,
					set = v107
				}
				t4[v104] = v105
			end

			local v108 = v105.get(p2)

			if v108 == nil then
				return 0
			end

			if v108.poolId == nil or v108.numberOfRows > 0 then
				return v108.numberOfRows
			end

			local v109 = u29(s4)(p2)

			if v109 ~= nil then
				return v109.actualRowCount
			end

			return 0
		end)

		t6[s4] = v48

		return v48
	end
	local function u31(s5: string) -- line: 241
		-- upvalues: t7 (copy), Signals (copy), t4 (copy), sectionConfigsEqual (copy), u31 (ref), t6 (copy), u29 (ref)
		local v50 = t7[s5]

		if v50 ~= nil then
			return v50
		end

		local v51 = Signals.createComputed(function(p3) -- line: 246
			-- upvalues: s5 (copy), t4 (copy), Signals (copy), sectionConfigsEqual (copy), u31 (ref), t6 (copy), u29 (ref)
			local v111 = s5
			local v112 = t4[v111]

			if v112 == nil then
				local v113, v114 = Signals.createSignal(nil, sectionConfigsEqual)

				v112 = {
					get = v113,
					set = v114
				}
				t4[v111] = v112
			end

			local v115 = v112.get(p3)

			if v115 == nil or v115.prevSectionId == nil then
				return 1
			end

			local v116 = u31(v115.prevSectionId)(p3)
			local prevSectionId = v115.prevSectionId
			local v118 = t6[prevSectionId]

			if v118 ~= nil then
			else
				v118 = Signals.createComputed(function(p4) -- line: 222
					-- upvalues: prevSectionId (copy), t4 (copy), Signals (copy), sectionConfigsEqual (copy), u29 (ref)
					local v132 = prevSectionId
					local v133 = t4[v132]

					if v133 == nil then
						local v134, v135 = Signals.createSignal(nil, sectionConfigsEqual)

						v133 = {
							get = v134,
							set = v135
						}
						t4[v132] = v133
					end

					local v136 = v133.get(p4)

					if v136 == nil then
						return 0
					end

					if v136.poolId == nil or v136.numberOfRows > 0 then
						return v136.numberOfRows
					end

					local v137 = u29(prevSectionId)(p4)

					if v137 ~= nil then
						return v137.actualRowCount
					end

					return 0
				end)
				t6[prevSectionId] = v118
			end

			return v116 + v118(p3)
		end)

		t7[s5] = v51

		return v51
	end

	return {
		getSectionInfo = function(s6: string) -- line: 279
			-- upvalues: Signals (copy), t4 (copy), sectionConfigsEqual (copy), t8 (copy), u29 (ref), EMPTY_CELLS (copy), cellsEqual (copy), u31 (ref), t6 (copy)
			return Signals.createComputed(function(p5) -- line: 280
				-- upvalues: s6 (copy), t4 (copy), Signals (copy), sectionConfigsEqual (copy), t8 (copy), u29 (ref), EMPTY_CELLS (copy), cellsEqual (copy), u31 (ref), t6 (copy)
				local v122 = s6
				local v123 = t4[v122]

				if v123 == nil then
					local v124, v125 = Signals.createSignal(nil, sectionConfigsEqual)

					v123 = {
						get = v124,
						set = v125
					}
					t4[v122] = v123
				end

				if v123.get(p5) == nil then
					return nil
				end

				local t10 = {}
				local v127 = s6
				local v128 = t8[v127]

				if v128 ~= nil then
				else
					v128 = Signals.createComputed(function(p6) -- line: 267
						-- upvalues: u29 (ref), v127 (copy), EMPTY_CELLS (copy)
						local v139 = u29(v127)(p6)

						if v139 ~= nil then
							return v139.cells
						end

						return EMPTY_CELLS
					end, cellsEqual)
					t8[v127] = v128
				end

				t10.cells = v128(p5)
				t10.startRow = u31(s6)(p5)

				local v129 = s6
				local v130 = t6[v129]

				if v130 ~= nil then
				else
					v130 = Signals.createComputed(function(p7) -- line: 222
						-- upvalues: v129 (copy), t4 (copy), Signals (copy), sectionConfigsEqual (copy), u29 (ref)
						local v141 = v129
						local v142 = t4[v141]

						if v142 == nil then
							local v143, v144 = Signals.createSignal(nil, sectionConfigsEqual)

							v142 = {
								get = v143,
								set = v144
							}
							t4[v141] = v142
						end

						local v145 = v142.get(p7)

						if v145 == nil then
							return 0
						end

						if v145.poolId == nil or v145.numberOfRows > 0 then
							return v145.numberOfRows
						end

						local v146 = u29(v129)(p7)

						if v146 ~= nil then
							return v146.actualRowCount
						end

						return 0
					end)
					t6[v129] = v130
				end

				t10.actualRowCount = v130(p5)

				return t10
			end)
		end,
		getSectionStartRow = u31,
		getSectionCells = function(s7: string) -- line: 262
			-- upvalues: t8 (copy), Signals (copy), u29 (ref), EMPTY_CELLS (copy), cellsEqual (copy)
			local v53 = t8[s7]

			if v53 ~= nil then
				return v53
			end

			local v54 = Signals.createComputed(function(p8) -- line: 267
				-- upvalues: u29 (ref), s7 (copy), EMPTY_CELLS (copy)
				local v120 = u29(s7)(p8)

				if v120 ~= nil then
					return v120.cells
				end

				return EMPTY_CELLS
			end, cellsEqual)

			t8[s7] = v54

			return v54
		end,
		setPools = function(t11: {[any]: any}) -- line: 297
			-- upvalues: t3 (copy), Signals (copy)
			for v57, v58 in t11 do
				local v59 = t3[v57]

				if v59 == nil then
					local v60, v61 = Signals.createSignal(nil)

					v59 = {
						get = v60,
						set = v61
					}
					t3[v57] = v59
				end

				v59.set(v58)
			end
		end,
		setSections = function(t12: {[any]: any}) -- line: 304
			-- upvalues: t4 (copy), Signals (copy), sectionConfigsEqual (copy)
			local t13 = {}
			local v64 = nil

			for _, v66 in t12 do
				local sectionId = v66.sectionId
				local poolId = v66.poolId
				local v69 = nil

				if poolId ~= nil then
					v69 = t13[poolId]
					t13[poolId] = sectionId
				end

				local v70 = t4[sectionId]

				if v70 == nil then
					local v71, v72 = Signals.createSignal(nil, sectionConfigsEqual)

					v70 = {
						get = v71,
						set = v72
					}
					t4[sectionId] = v70
				end

				v70.set({
					poolId = poolId,
					numberOfRows = v66.numberOfRows,
					prevSectionInPoolId = v69,
					prevSectionId = v64
				})
				v64 = sectionId
			end
		end,
		setLayoutStore = function(p9) -- line: 332
			-- upvalues: v26 (copy)
			v26(p9)
		end
	}
end

local self = setmetatable({}, {
	__mode = "v"
})

return {
	getSduiPoolStore = function(s8: string) -- line: 341
		-- upvalues: self (copy), createSduiPoolStore (copy)
		local v33 = self[s8]

		if v33 ~= nil then
			return v33
		end

		local v34 = createSduiPoolStore()

		self[s8] = v34

		return v34
	end
}
