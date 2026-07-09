local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 57
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(false)
	local v5, v6 = createSignal(true)
	local v7, v8 = createSignal(false)
	local v9, v10 = createSignal({})
	local v11, v12 = createSignal(1)
	local v13, v14 = createSignal("")
	local v15, v16 = createSignal("Disabled")
	local v17, v18 = createSignal(nil)
	local v19, v20 = createSignal(nil)
	local v21, v22 = createSignal(0)
	local v23, v24 = createSignal({})

	return {
		getIsEnabled = v3,
		getIsLoading = v5,
		getIsTrayOpen = v7,
		getCategoryGroups = v9,
		getSelectedGroupIndex = v11,
		getVersion = v13,
		getAccessLevel = v15,
		getLayoutModeOverride = v17,
		getPresetCooldownEndsAt = v19,
		getChatWindowBottomY = v21,
		getPresetClickCounts = v23,
		setIsEnabled = v4,
		setIsLoading = v6,
		setIsTrayOpen = v8,
		setCategoryGroups = v10,
		setSelectedGroupIndex = v12,
		setVersion = v14,
		setAccessLevel = v16,
		setLayoutModeOverride = v18,
		setPresetCooldownEndsAt = v20,
		setChatWindowBottomY = v22,
		incrementPresetClickCount = function(s1: string) -- line: 70
			-- upvalues: v23 (copy), v24 (copy)
			local v26 = table.clone(v23(false))

			v26[s1] = not v26[s1] and 1 or v26[s1] + 1
			v24(v26)
		end
	}
end
