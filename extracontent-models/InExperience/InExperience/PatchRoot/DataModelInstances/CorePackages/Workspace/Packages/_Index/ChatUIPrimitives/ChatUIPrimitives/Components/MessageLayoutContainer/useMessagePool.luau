local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Signals = require(ChatUIPrimitivesParent.Signals)
local SignalsExperimental = require(ChatUIPrimitivesParent.SignalsExperimental)
local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)

local function useMessagePool(t1: {[any]: any}) -- line: 61
	-- upvalues: React (copy), useStableSignal (copy), SignalsExperimental (copy), Signals (copy)
	local v9 = React.useRef({})
	local v10 = React.useRef({})
	local v11 = React.useRef(0)
	local v12 = t1.maxSlots or 50
	local v13, v14 = useStableSignal({})

	local function reconcile(t2: {[any]: any}) -- line: 87
		-- upvalues: SignalsExperimental (copy), v9 (copy), v10 (copy), v12 (copy), v11 (copy), Signals (copy), t1 (copy), v14 (copy)
		SignalsExperimental.batch(function() -- line: 88
			-- upvalues: v9 (copy), v10 (copy), t2 (copy), v12 (copy), v11 (copy), Signals (copy), t1 (copy), v14 (copy)
			local current = v9.current
			local current2 = v10.current
			local v48 = false
			local v49 = #t2
			local v50 = math.max(1, v49 - v12 + 1)
			local t3 = {}

			for i = v50, v49 do
				t3[t2[i]] = true
			end

			for v53, v54 in current do
				if not t3[v53] then
					v54.setMessageId(nil)
					current2[#current2 + 1] = v54
					current[v53] = nil
				end
			end

			for i = v50, v49 do
				local v56 = t2[i]

				if not current[v56] then
					local v57

					if #current2 > 0 then
						v57 = current2[#current2]
						current2[#current2] = nil
						v57.setMessageId(v56)
					else
						local v58 = v11

						v58.current = v58.current + 1

						local v59 = "slot-" .. v11.current
						local v60, v61 = Signals.createSignal(v56)
						local v62, v63 = Signals.createSignal(0)

						v57 = {
							stableKey = v59,
							getMessageId = v60,
							setMessageId = v61,
							getLayoutOrder = v62,
							setLayoutOrder = v63,
							component = t1.createSlotElement({
								getMessageId = v60,
								getLayoutOrder = v62
							})
						}
						v48 = true
					end

					current[v56] = v57
				end
			end

			local n1 = 0

			for i = v50, v49 do
				local v66 = current[t2[i]]

				if v66 ~= nil then
					local v67 = v66.getLayoutOrder(false)

					if v67 <= n1 then
						v67 = n1 + 1
						v66.setLayoutOrder(v67)
					end

					n1 = v67
				end
			end

			if v48 then
				local t4 = {}

				for _, v70 in current do
					t4[v70.stableKey] = v70.component
				end

				for _, v72 in current2 do
					t4[v72.stableKey] = v72.component
				end

				v14(t4)
			end
		end)
	end

	local v16 = React.useRef(false)

	if not v16.current then
		v16.current = true

		local v17 = t1.messageIdsSignal()

		SignalsExperimental.batch(function() -- line: 88
			-- upvalues: v9 (copy), v10 (copy), v17 (copy), v12 (copy), v11 (copy), Signals (copy), t1 (copy), v14 (copy)
			local current = v9.current
			local current3 = v10.current
			local v21 = false
			local v22 = #v17
			local v23 = math.max(1, v22 - v12 + 1)
			local t5 = {}

			for i = v23, v22 do
				t5[v17[i]] = true
			end

			for v26, v27 in current do
				if not t5[v26] then
					v27.setMessageId(nil)
					current3[#current3 + 1] = v27
					current[v26] = nil
				end
			end

			for i = v23, v22 do
				local v29 = v17[i]

				if not current[v29] then
					local v30

					if #current3 > 0 then
						v30 = current3[#current3]
						current3[#current3] = nil
						v30.setMessageId(v29)
					else
						local v31 = v11

						v31.current = v31.current + 1

						local v32 = "slot-" .. v11.current
						local v33, v34 = Signals.createSignal(v29)
						local v35, v36 = Signals.createSignal(0)

						v30 = {
							stableKey = v32,
							getMessageId = v33,
							setMessageId = v34,
							getLayoutOrder = v35,
							setLayoutOrder = v36,
							component = t1.createSlotElement({
								getMessageId = v33,
								getLayoutOrder = v35
							})
						}
						v21 = true
					end

					current[v29] = v30
				end
			end

			local n2 = 0

			for i = v23, v22 do
				local v39 = current[v17[i]]

				if v39 ~= nil then
					local v40 = v39.getLayoutOrder(false)

					if v40 <= n2 then
						v40 = n2 + 1
						v39.setLayoutOrder(v40)
					end

					n2 = v40
				end
			end

			if v21 then
				local t6 = {}

				for _, v43 in current do
					t6[v43.stableKey] = v43.component
				end

				for _, v45 in current3 do
					t6[v45.stableKey] = v45.component
				end

				v14(t6)
			end
		end)
	end

	React.useEffect(function() -- line: 191
		-- upvalues: Signals (copy), t1 (copy), SignalsExperimental (copy), v9 (copy), v10 (copy), v12 (copy), v11 (copy), v14 (copy)
		return (Signals.createEffect(function(p1) -- line: 192
			-- upvalues: t1 (copy), SignalsExperimental (copy), v9 (copy), v10 (copy), v12 (copy), v11 (copy), Signals (copy), v14 (copy)
			local v74 = t1.messageIdsSignal(p1)

			SignalsExperimental.batch(function() -- line: 88
				-- upvalues: v9 (copy), v10 (copy), v74 (copy), v12 (copy), v11 (copy), Signals (copy), t1 (copy), v14 (copy)
				local current = v9.current
				local current4 = v10.current
				local v77 = false
				local v78 = #v74
				local v79 = math.max(1, v78 - v12 + 1)
				local t7 = {}

				for i = v79, v78 do
					t7[v74[i]] = true
				end

				for v82, v83 in current do
					if not t7[v82] then
						v83.setMessageId(nil)
						current4[#current4 + 1] = v83
						current[v82] = nil
					end
				end

				for i = v79, v78 do
					local v85 = v74[i]

					if not current[v85] then
						local v86

						if #current4 > 0 then
							v86 = current4[#current4]
							current4[#current4] = nil
							v86.setMessageId(v85)
						else
							local v87 = v11

							v87.current = v87.current + 1

							local v88 = "slot-" .. v11.current
							local v89, v90 = Signals.createSignal(v85)
							local v91, v92 = Signals.createSignal(0)

							v86 = {
								stableKey = v88,
								getMessageId = v89,
								setMessageId = v90,
								getLayoutOrder = v91,
								setLayoutOrder = v92,
								component = t1.createSlotElement({
									getMessageId = v89,
									getLayoutOrder = v91
								})
							}
							v77 = true
						end

						current[v85] = v86
					end
				end

				local n3 = 0

				for i = v79, v78 do
					local v95 = current[v74[i]]

					if v95 ~= nil then
						local v96 = v95.getLayoutOrder(false)

						if v96 <= n3 then
							v96 = n3 + 1
							v95.setLayoutOrder(v96)
						end

						n3 = v96
					end
				end

				if v77 then
					local t8 = {}

					for _, v99 in current do
						t8[v99.stableKey] = v99.component
					end

					for _, v101 in current4 do
						t8[v101.stableKey] = v101.component
					end

					v14(t8)
				end
			end)
		end))
	end, {
		t1.messageIdsSignal,
		v14,
		v12
	})

	return v13
end

return useMessagePool
