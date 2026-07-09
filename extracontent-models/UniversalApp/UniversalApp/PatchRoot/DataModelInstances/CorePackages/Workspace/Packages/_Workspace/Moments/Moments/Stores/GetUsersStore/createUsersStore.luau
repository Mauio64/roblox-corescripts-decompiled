local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local Cryo = require(Parent.Cryo)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createUsersStore() -- line: 31
	-- upvalues: createSignal (copy), createComputed (copy), Cryo (copy)
	local v7, v8 = createSignal({})
	local t1 = {}
	local t2 = {}

	return {
		getUsersByUserId = v7,
		getUserProfile = function(s1: string) -- line: 37
			-- upvalues: t1 (copy), createComputed (copy), v7 (copy), t2 (copy)
			if t1[s1] == nil then
				t1[s1] = createComputed(function(p1) -- line: 39
					-- upvalues: v7 (copy), s1 (copy), t2 (copy)
					return v7(p1)[s1] or t2
				end)
			end

			return t1[s1]
		end,
		updateUsername = function(n1: number, s2: string) -- line: 46
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local str = tostring(n1)
			local v15 = v7(false)
			local v16 = v15[str] or {}

			v8((Cryo.Dictionary.union(v15, {
				[str] = Cryo.Dictionary.union(v16, {
					username = s2
				})
			})))
		end,
		updateAvatar = function(n2: number, s3: string) -- line: 57
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local str = tostring(n2)
			local v20 = v7(false)
			local v21 = v20[str] or {}

			v8((Cryo.Dictionary.union(v20, {
				[str] = Cryo.Dictionary.union(v21, {
					avatarThumbnailUri = s3
				})
			})))
		end,
		updateMomentsCount = function(n3: number, n4: number) -- line: 68
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local str = tostring(n3)
			local v25 = v7(false)
			local v26 = v25[str] or {}

			v8((Cryo.Dictionary.union(v25, {
				[str] = Cryo.Dictionary.union(v26, {
					momentsCount = n4
				})
			})))
		end,
		invalidateMomentsCount = function(n5: number) -- line: 79
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local str = tostring(n5)
			local v29 = v7(false)
			local v30 = v29[str]

			if not v30 then
				return
			end

			v8((Cryo.Dictionary.union(v29, {
				[str] = Cryo.Dictionary.join(v30, {
					momentsCount = Cryo.None
				})
			})))
		end,
		updateUserInfo = function(n6: number, s4: string, b1: boolean) -- line: 93
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local str = tostring(n6)
			local v35 = v7(false)
			local v36 = v35[str] or {}

			v8((Cryo.Dictionary.union(v35, {
				[str] = Cryo.Dictionary.union(v36, {
					displayName = s4,
					hasVerifiedBadge = b1
				})
			})))
		end
	}
end

return createUsersStore
