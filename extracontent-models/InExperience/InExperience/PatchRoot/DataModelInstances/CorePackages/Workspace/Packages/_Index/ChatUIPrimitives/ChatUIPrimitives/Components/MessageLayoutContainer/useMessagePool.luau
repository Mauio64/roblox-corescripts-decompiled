local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Signals = require(ChatUIPrimitivesParent.Signals)
local SignalsExperimental = require(ChatUIPrimitivesParent.SignalsExperimental)
local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)

local function useMessagePool(t1: {[any]: any}) -- line: 66
	-- upvalues: React (copy), useStableSignal (copy), SignalsExperimental (copy), Signals (copy)
	local v9 = React.useRef({})
	local v10 = React.useRef({})
	local v11 = React.useRef(0)
	local v12 = t1.maxSlots or 50
	local v13 = React.useRef(t1.createSlotElement)

	v13.current = t1.createSlotElement

	local v14, v15 = useStableSignal({})

	local function publishChildrenFromCache() -- line: 86
		-- upvalues: v9 (copy), v10 (copy), v15 (copy)
		local t2 = {}

		for _, v24 in v9.current do
			t2[v24.stableKey] = v24.element
		end

		for _, v26 in v10.current do
			t2[v26.stableKey] = v26.element
		end

		v15(t2)
	end
	local function rebuildElementsFromFactory() -- line: 103
		-- upvalues: v13 (copy), v9 (copy), v10 (copy), publishChildrenFromCache (copy)
		local current = v13.current

		for _, v29 in v9.current do
			v29.element = current({
				getMessageId = v29.getMessageId,
				getLayoutOrder = v29.getLayoutOrder
			})
		end

		for _, v31 in v10.current do
			v31.element = current({
				getMessageId = v31.getMessageId,
				getLayoutOrder = v31.getLayoutOrder
			})
		end

		publishChildrenFromCache()
	end
	local function reconcile(t3: {[any]: any}) -- line: 137
		-- upvalues: SignalsExperimental (copy), v9 (copy), v10 (copy), v12 (copy), v11 (copy), Signals (copy), v13 (copy), publishChildrenFromCache (copy)
		SignalsExperimental.batch(function() -- line: 138
			-- upvalues: v9 (copy), v10 (copy), t3 (copy), v12 (copy), v11 (copy), Signals (copy), v13 (copy), publishChildrenFromCache (copy)
			local current = v9.current
			local current2 = v10.current
			local v57 = false
			local v58 = #t3
			local v59 = math.max(1, v58 - v12 + 1)
			local t4 = {}

			for i = v59, v58 do
				t4[t3[i]] = true
			end

			for v62, v63 in current do
				if not t4[v62] then
					v63.setMessageId(nil)
					current2[#current2 + 1] = v63
					current[v62] = nil
				end
			end

			for i = v59, v58 do
				local v65 = t3[i]

				if not current[v65] then
					local v66

					if #current2 > 0 then
						v66 = current2[#current2]
						current2[#current2] = nil
						v66.setMessageId(v65)
					else
						local v67 = v11

						v67.current = v67.current + 1

						local v68 = "slot-" .. v11.current
						local v69, v70 = Signals.createSignal(v65)
						local v71, v72 = Signals.createSignal(0)

						v66 = {
							stableKey = v68,
							getMessageId = v69,
							setMessageId = v70,
							getLayoutOrder = v71,
							setLayoutOrder = v72,
							element = v13.current({
								getMessageId = v69,
								getLayoutOrder = v71
							})
						}
						v57 = true
					end

					current[v65] = v66
				end
			end

			local n1 = 0

			for i = v59, v58 do
				local v75 = current[t3[i]]

				if v75 ~= nil then
					local v76 = v75.getLayoutOrder(false)

					if v76 <= n1 then
						v76 = n1 + 1
						v75.setLayoutOrder(v76)
					end

					n1 = v76
				end
			end

			if v57 then
				publishChildrenFromCache()
			end
		end)
	end

	local v19 = React.useRef(false)

	if not v19.current then
		v19.current = true

		local v20 = t1.messageIdsSignal()

		SignalsExperimental.batch(function() -- line: 138
			-- upvalues: v9 (copy), v10 (copy), v20 (copy), v12 (copy), v11 (copy), Signals (copy), v13 (copy), publishChildrenFromCache (copy)
			local current = v9.current
			local current3 = v10.current
			local v35 = false
			local v36 = #v20
			local v37 = math.max(1, v36 - v12 + 1)
			local t5 = {}

			for i = v37, v36 do
				t5[v20[i]] = true
			end

			for v40, v41 in current do
				if not t5[v40] then
					v41.setMessageId(nil)
					current3[#current3 + 1] = v41
					current[v40] = nil
				end
			end

			for i = v37, v36 do
				local v43 = v20[i]

				if not current[v43] then
					local v44

					if #current3 > 0 then
						v44 = current3[#current3]
						current3[#current3] = nil
						v44.setMessageId(v43)
					else
						local v45 = v11

						v45.current = v45.current + 1

						local v46 = "slot-" .. v11.current
						local v47, v48 = Signals.createSignal(v43)
						local v49, v50 = Signals.createSignal(0)

						v44 = {
							stableKey = v46,
							getMessageId = v47,
							setMessageId = v48,
							getLayoutOrder = v49,
							setLayoutOrder = v50,
							element = v13.current({
								getMessageId = v47,
								getLayoutOrder = v49
							})
						}
						v35 = true
					end

					current[v43] = v44
				end
			end

			local n2 = 0

			for i = v37, v36 do
				local v53 = current[v20[i]]

				if v53 ~= nil then
					local v54 = v53.getLayoutOrder(false)

					if v54 <= n2 then
						v54 = n2 + 1
						v53.setLayoutOrder(v54)
					end

					n2 = v54
				end
			end

			if v35 then
				publishChildrenFromCache()
			end
		end)
	end

	React.useEffect(function() -- line: 234
		-- upvalues: Signals (copy), t1 (copy), SignalsExperimental (copy), v9 (copy), v10 (copy), v12 (copy), v11 (copy), v13 (copy), publishChildrenFromCache (copy)
		return (Signals.createEffect(function(p1) -- line: 235
			-- upvalues: t1 (copy), SignalsExperimental (copy), v9 (copy), v10 (copy), v12 (copy), v11 (copy), Signals (copy), v13 (copy), publishChildrenFromCache (copy)
			local v78 = t1.messageIdsSignal(p1)

			SignalsExperimental.batch(function() -- line: 138
				-- upvalues: v9 (copy), v10 (copy), v78 (copy), v12 (copy), v11 (copy), Signals (copy), v13 (copy), publishChildrenFromCache (copy)
				local current = v9.current
				local current4 = v10.current
				local v81 = false
				local v82 = #v78
				local v83 = math.max(1, v82 - v12 + 1)
				local t6 = {}

				for i = v83, v82 do
					t6[v78[i]] = true
				end

				for v86, v87 in current do
					if not t6[v86] then
						v87.setMessageId(nil)
						current4[#current4 + 1] = v87
						current[v86] = nil
					end
				end

				for i = v83, v82 do
					local v89 = v78[i]

					if not current[v89] then
						local v90

						if #current4 > 0 then
							v90 = current4[#current4]
							current4[#current4] = nil
							v90.setMessageId(v89)
						else
							local v91 = v11

							v91.current = v91.current + 1

							local v92 = "slot-" .. v11.current
							local v93, v94 = Signals.createSignal(v89)
							local v95, v96 = Signals.createSignal(0)

							v90 = {
								stableKey = v92,
								getMessageId = v93,
								setMessageId = v94,
								getLayoutOrder = v95,
								setLayoutOrder = v96,
								element = v13.current({
									getMessageId = v93,
									getLayoutOrder = v95
								})
							}
							v81 = true
						end

						current[v89] = v90
					end
				end

				local n3 = 0

				for i = v83, v82 do
					local v99 = current[v78[i]]

					if v99 ~= nil then
						local v100 = v99.getLayoutOrder(false)

						if v100 <= n3 then
							v100 = n3 + 1
							v99.setLayoutOrder(v100)
						end

						n3 = v100
					end
				end

				if v81 then
					publishChildrenFromCache()
				end
			end)
		end))
	end, {
		t1.messageIdsSignal,
		v15,
		v12
	})

	local v21 = React.useRef(false)

	React.useEffect(function() -- line: 248
		-- upvalues: v21 (copy), rebuildElementsFromFactory (copy)
		if not v21.current then
			v21.current = true

			return
		end

		rebuildElementsFromFactory()
	end, { t1.createSlotElement })

	return v14
end

return useMessagePool
