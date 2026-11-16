local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createUsersStore()
	local signal, v = createSignal({})

	local v2 = {}
	local v3 = {}

	local function getUserProfile(p: string)
		if v2[p] == nil then
			v2[p] = createComputed(function(p2)
				return signal(p2)[p] or v3
			end)
		end

		return v2[p]
	end

	local function updateUsername(p: number, username: string)
		local v4 = tostring(p)
		local v5 = signal(false)
		local v6 = v5[v4] or {}
		v((Cryo.Dictionary.union(v5, {
			[v4] = Cryo.Dictionary.union(v6, { username = username })
		})))
	end

	local function updateAvatar(p: number, avatarThumbnailUri: string)
		local v4 = tostring(p)
		local v5 = signal(false)
		local v6 = v5[v4] or {}
		v((Cryo.Dictionary.union(v5, {
			[v4] = Cryo.Dictionary.union(v6, { avatarThumbnailUri = avatarThumbnailUri })
		})))
	end

	local function updateMomentsCount(p: number, momentsCount: number)
		local v4 = tostring(p)
		local v5 = signal(false)
		local v6 = v5[v4] or {}
		v((Cryo.Dictionary.union(v5, {
			[v4] = Cryo.Dictionary.union(v6, { momentsCount = momentsCount })
		})))
	end

	local function invalidateMomentsCount(p: number)
		local v4 = tostring(p)
		local v5 = signal(false)
		local v6 = v5[v4]

		if not v6 then
			return
		end

		v((Cryo.Dictionary.union(v5, {
			[v4] = Cryo.Dictionary.join(v6, { momentsCount = Cryo.None })
		})))
	end

	local function updateUserInfo(p: number, displayName: string, hasVerifiedBadge: boolean)
		local v4 = tostring(p)
		local v5 = signal(false)
		local v6 = v5[v4] or {}
		v((Cryo.Dictionary.union(v5, {
			[v4] = Cryo.Dictionary.union(v6, {
				displayName = displayName,
				hasVerifiedBadge = hasVerifiedBadge
			})
		})))
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
