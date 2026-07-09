local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local Signal = require(AppChatParent.AppCommonLib).Signal
local ArraySet = require(AppChat.DataStructures).ArraySet

local function createSelectedUsersStore() -- line: 35
	-- upvalues: Signals (copy), ArraySet (copy), Signal (copy)
	local v7, v8 = Signals.createSignal(0)
	local v9, v10 = Signals.createSignal(ArraySet.new({}))
	local v11 = Signals.createComputed(function(p1) -- line: 43
		-- upvalues: v9 (copy), v7 (copy)
		local v20 = v9(p1)

		return v7(p1) > v20:size()
	end)
	local v12 = Signals.createComputed(function(p2) -- line: 49
		-- upvalues: v9 (copy)
		return v9(p2):size()
	end)
	local v13 = Signals.createComputed(function(p3) -- line: 54
		-- upvalues: v9 (copy)
		return v9(p3):toArray()
	end)
	local u14 = Signal.new()
	local t1 = {}
	local t2 = {}

	local function emitMaxSizeExceeded() -- line: 66
		-- upvalues: u14 (ref)
		u14:fire()
	end
	local function addUserId(s1: string) -- line: 116
		-- upvalues: v9 (copy), v11 (copy), u14 (ref), v10 (copy)
		if v9(false):has(s1) then
			return true
		end

		if not v11(false) then
			u14:fire()

			return false
		end

		v10(function(p4) -- line: 130
			-- upvalues: s1 (copy)
			local v36 = p4:clone()

			v36:add(s1)

			return v36
		end)

		return true
	end

	return {
		setMaxSize = function(n1: number) -- line: 70
			-- upvalues: v8 (copy)
			v8(function(_) -- line: 71
				-- upvalues: n1 (copy)
				return n1
			end)
		end,
		getSelectedUserIdsCount = function() -- line: 84
			-- upvalues: v12 (copy)
			return v12
		end,
		getSelectedUserIdAtIndex = function(n2: number) -- line: 88
			-- upvalues: t1 (ref), Signals (copy), v9 (copy)
			if not t1[n2] then
				t1[n2] = Signals.createComputed(function(p6) -- line: 90
					-- upvalues: v9 (copy), n2 (copy)
					return v9(p6):at(n2)
				end)
			end

			return t1[n2]
		end,
		getIsUserSelected = function(s2: string) -- line: 98
			-- upvalues: t2 (ref), Signals (copy), v9 (copy)
			if not t2[s2] then
				t2[s2] = Signals.createComputed(function(p7) -- line: 100
					-- upvalues: v9 (copy), s2 (copy)
					return v9(p7):has(s2)
				end)
			end

			return t2[s2]
		end,
		getMaxSize = function() -- line: 108
			-- upvalues: v7 (copy)
			return v7
		end,
		getSelectedUserIdsArray = function() -- line: 112
			-- upvalues: v13 (copy)
			return v13
		end,
		addUserId = addUserId,
		removeUserId = function(s3: string) -- line: 139
			-- upvalues: v10 (copy)
			v10(function(p8) -- line: 140
				-- upvalues: s3 (copy)
				if p8:has(s3) then
					local v38 = p8:clone()

					v38:remove(s3)

					return v38
				end

				return p8
			end)
		end,
		toggleUserId = function(s4: string) -- line: 150
			-- upvalues: v9 (copy), v10 (copy), addUserId (copy)
			if v9(false):has(s4) then
				v10(function(p9) -- line: 140
					-- upvalues: s4 (copy)
					if p9:has(s4) then
						local v40 = p9:clone()

						v40:remove(s4)

						return v40
					end

					return p9
				end)

				return true
			end

			return (addUserId(s4))
		end,
		clearStore = function() -- line: 161
			-- upvalues: u14 (ref), Signal (copy), t1 (ref), t2 (ref), v10 (copy), ArraySet (copy)
			u14 = Signal.new()
			t1 = {}
			t2 = {}
			v10(function(_) -- line: 165
				-- upvalues: ArraySet (copy)
				return ArraySet.new({})
			end)
		end,
		onMaxSizeExceeded = function(p11: ((...any) -> ...any)) -- line: 76
			-- upvalues: u14 (ref)
			local v25 = u14:connect(p11)

			return function() -- line: 79
				-- upvalues: v25 (copy)
				v25:disconnect()
			end
		end,
		hasUserId = function(s5: string) -- line: 170
			-- upvalues: v9 (copy)
			return v9(false):has(s5)
		end,
		getCount = function() -- line: 175
			-- upvalues: v9 (copy)
			return v9(false):size()
		end
	}
end

return createSelectedUsersStore
