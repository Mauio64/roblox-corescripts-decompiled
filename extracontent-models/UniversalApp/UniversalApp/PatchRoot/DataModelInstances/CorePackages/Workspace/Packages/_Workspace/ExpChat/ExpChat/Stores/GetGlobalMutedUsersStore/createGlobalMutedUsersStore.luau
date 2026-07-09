local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 25
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal({})
	local v5, v6 = createSignal({})
	local v7, v8 = createSignal({})

	return {
		getMutedGlobalUsernames = v3,
		getMutedGlobalDisplayNames = v5,
		getMutedGlobalUserIds = v7,
		muteGlobalUsername = function(s1: string) -- line: 30
			-- upvalues: v3 (copy), v4 (copy)
			local v10 = string.lower(s1)
			local v11 = table.clone(v3(false))

			v11[v10] = true
			v4(v11)
		end,
		unmuteGlobalUsername = function(s2: string) -- line: 37
			-- upvalues: v3 (copy), v4 (copy)
			local v13 = string.lower(s2)
			local v14 = table.clone(v3(false))

			v14[v13] = nil
			v4(v14)
		end,
		muteGlobalDisplayName = function(s3: string) -- line: 44
			-- upvalues: v5 (copy), v6 (copy)
			local v16 = string.lower(s3)
			local v17 = table.clone(v5(false))

			v17[v16] = true
			v6(v17)
		end,
		unmuteGlobalDisplayName = function(s4: string) -- line: 51
			-- upvalues: v5 (copy), v6 (copy)
			local v19 = string.lower(s4)
			local v20 = table.clone(v5(false))

			v20[v19] = nil
			v6(v20)
		end,
		isUsernameMuted = function(s5: string) -- line: 58
			-- upvalues: v3 (copy)
			return v3(false)[string.lower(s5)] == true
		end,
		isDisplayNameMuted = function(s6: string) -- line: 62
			-- upvalues: v5 (copy)
			return v5(false)[string.lower(s6)] == true
		end,
		muteGlobalUserId = function(p1) -- line: 66
			-- upvalues: v7 (copy), v8 (copy)
			local str = tostring(p1)
			local v25 = table.clone(v7(false))

			v25[str] = true
			v8(v25)
		end,
		unmuteGlobalUserId = function(p2) -- line: 73
			-- upvalues: v7 (copy), v8 (copy)
			local str = tostring(p2)
			local v28 = table.clone(v7(false))

			v28[str] = nil
			v8(v28)
		end,
		isUserIdMuted = function(p3) -- line: 80
			-- upvalues: v7 (copy)
			return v7(false)[tostring(p3)] == true
		end
	}
end
