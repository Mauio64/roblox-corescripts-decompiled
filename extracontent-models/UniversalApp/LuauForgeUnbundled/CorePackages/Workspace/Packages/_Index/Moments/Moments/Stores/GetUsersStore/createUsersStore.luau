local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Cryo")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createUsersStore()
	local signal, v5 = createSignal({})

	local v6 = {}
	local v7 = {}

	local function getUserProfile(p2)
		if v6[p2] == nil then
			v6[p2] = createComputed(function(p3)
				return signal(p3)[p2] or v7
			end)
		end

		return v6[p2]
	end

	local function updateUsername(p2, p3)
		local v8 = tostring(p2)
		local v9 = signal(false)
		local v10 = v9[v8] or {}
		v5(Cryo.Dictionary.union(v9, {
			[v8] = Cryo.Dictionary.union(v10, { username = p3 })
		}))
	end

	local function updateAvatar(p2, p3)
		local v8 = tostring(p2)
		local v9 = signal(false)
		local v10 = v9[v8] or {}
		v5(Cryo.Dictionary.union(v9, {
			[v8] = Cryo.Dictionary.union(v10, { avatarThumbnailUri = p3 })
		}))
	end

	local function updateMomentsCount(p2, p3)
		local v8 = tostring(p2)
		local v9 = signal(false)
		local v10 = v9[v8] or {}
		v5(Cryo.Dictionary.union(v9, {
			[v8] = Cryo.Dictionary.union(v10, { momentsCount = p3 })
		}))
	end

	local function invalidateMomentsCount(p2)
		local v8 = tostring(p2)
		local v9 = signal(false)
		local v10 = v9[v8]

		if not v10 then
			return
		end

		v5(Cryo.Dictionary.union(v9, {
			[v8] = Cryo.Dictionary.join(v10, { momentsCount = Cryo.None })
		}))
	end

	local function updateUserInfo(p2, p3, p4)
		local v8 = tostring(p2)
		local v9 = signal(false)
		local v10 = v9[v8] or {}
		v5(Cryo.Dictionary.union(v9, {
			[v8] = Cryo.Dictionary.union(v10, {
				displayName = p3,
				hasVerifiedBadge = p4
			})
		}))
	end

	return {
		getUsersByUserId = signal,
		getUserProfile = getUserProfile,
		updateUsername = updateUsername,
		updateAvatar = updateAvatar,
		updateMomentsCount = updateMomentsCount,
		invalidateMomentsCount = invalidateMomentsCount,
		updateUserInfo = updateUserInfo
	}
end

return createUsersStore
