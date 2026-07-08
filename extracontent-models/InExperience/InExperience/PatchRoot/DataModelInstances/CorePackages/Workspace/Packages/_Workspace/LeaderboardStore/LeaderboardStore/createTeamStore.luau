local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local createSignalMap = require(ParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap

require(script.Parent.LeaderboardStoreTypes)

local function createTeamStore(p1, _) -- line: 40
	-- upvalues: createSignalMap (copy), Signals (copy)
	local t1 = {}
	local v8 = createSignalMap()
	local v9 = createSignalMap()
	local t2 = {}
	local v11, u13, v14, u16, v17, u19

	if p1 == "Neutral" then
		local v12

		v11, v12 = Signals.createSignal("Neutral")
		u13 = v12

		local v15

		v14, v15 = Signals.createSignal(BrickColor.White().Color)
		u16 = v15

		local v18

		v17, v18 = Signals.createSignal(1000)
		u19 = v18
	else
		local v20

		v11, v20 = Signals.createSignal(p1.Name)
		u13 = v20

		local v21

		v14, v21 = Signals.createSignal(p1.TeamColor.Color)
		u16 = v21

		local v22

		v17, v22 = Signals.createSignal(p1.ChildOrder)
		u19 = v22
		t1.teamPropChanged = p1.Changed:Connect(function(property: string) -- line: 72
			-- upvalues: u13 (ref), p1 (copy), u16 (ref), u19 (ref)
			if property == "Name" then
				u13(p1.Name)

				return
			end

			if property == "TeamColor" then
				u16(p1.TeamColor.Color)

				return
			end

			if property == "ChildOrder" then
				u19(p1.ChildOrder)
			end
		end)
	end

	local function updateAllStats() -- line: 108
		-- upvalues: t2 (ref), Signals (copy), v9 (copy), v8 (copy)
		for k, v in pairs(t2) do
			local v30 = Signals.createComputed(function(p3) -- line: 85
				-- upvalues: v9 (copy), v (copy), k (copy)
				local v49 = nil
				local v50 = v9.getAllData(p3)

				if typeof(v50) == "table" then
					for k2, _ in pairs(v50) do
						local v53 = v(k2, k, p3)

						if v53 and type(v53) == "number" then
							v49 = if not v49 then v53 else v49 + v53
						end
					end
				end

				return v49
			end)

			v8.setData(k, v30, false)
			t2[k] = v
		end
	end

	return {
		getName = v11,
		getColor = v14,
		getOrder = v17,
		getStats = v8,
		getPlayers = v9,
		updateStat = function(s1: string, p4: ((...any) -> ...any)) -- line: 84
			-- upvalues: Signals (copy), v9 (copy), v8 (copy), t2 (ref)
			local v27 = Signals.createComputed(function(p5) -- line: 85
				-- upvalues: v9 (copy), p4 (copy), s1 (copy)
				local v43 = nil
				local v44 = v9.getAllData(p5)

				if typeof(v44) == "table" then
					for k, _ in pairs(v44) do
						local v47 = p4(k, s1, p5)

						if v47 and type(v47) == "number" then
							v43 = if not v43 then v47 else v43 + v47
						end
					end
				end

				return v43
			end)

			v8.setData(s1, v27, false)
			t2[s1] = p4
		end,
		removeStat = function(s2: string) -- line: 115
			-- upvalues: v8 (copy), t2 (ref)
			v8.removeData(s2, false)
			t2[s2] = nil
		end,
		addPlayer = function(p6) -- line: 122
			-- upvalues: v9 (copy), t2 (ref), Signals (copy), v8 (copy)
			v9.setData(p6, p6.UserId, false)

			for k, v in pairs(t2) do
				local v35 = Signals.createComputed(function(p7) -- line: 85
					-- upvalues: v9 (copy), v (copy), k (copy)
					local v55 = nil
					local v56 = v9.getAllData(p7)

					if typeof(v56) == "table" then
						for k3, _ in pairs(v56) do
							local v59 = v(k3, k, p7)

							if v59 and type(v59) == "number" then
								v55 = if not v55 then v59 else v55 + v59
							end
						end
					end

					return v55
				end)

				v8.setData(k, v35, false)
				t2[k] = v
			end
		end,
		removePlayer = function(p8) -- line: 128
			-- upvalues: v9 (copy), t2 (ref), Signals (copy), v8 (copy)
			v9.removeData(p8, false)

			for k, v in pairs(t2) do
				local v39 = Signals.createComputed(function(p9) -- line: 85
					-- upvalues: v9 (copy), v (copy), k (copy)
					local v61 = nil
					local v62 = v9.getAllData(p9)

					if typeof(v62) == "table" then
						for k4, _ in pairs(v62) do
							local v65 = v(k4, k, p9)

							if v65 and type(v65) == "number" then
								v61 = if not v61 then v65 else v61 + v65
							end
						end
					end

					return v61
				end)

				v8.setData(k, v39, false)
				t2[k] = v
			end
		end,
		destroy = function() -- line: 134
			-- upvalues: t1 (ref), t2 (ref)
			for _, v in pairs(t1) do
				if v.Disconnect then
					v:Disconnect()
				end
			end

			t1 = {}
			t2 = {}
		end
	}
end

return createTeamStore
