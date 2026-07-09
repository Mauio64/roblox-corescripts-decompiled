local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local Promise = require(DataHydrationParent.Promise)
local Cryo = require(DataHydrationParent.Cryo)
local Requests = require(DataHydration.TrustedConnections.Requests)
local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)
local createTrustedConnectionEventListener = require(DataHydration.TrustedConnections.createTrustedConnectionEventListener)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local FFlagTCShareLinkReceiverUI = require(DataHydrationParent.SharedFlags).FFlagTCShareLinkReceiverUI
local FFlagConnectionManagementChips = require(DataHydrationParent.SharedFlags).FFlagConnectionManagementChips
local v13 = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)

local function createTrustedConnectionsStore() -- line: 53
	-- upvalues: v13 (copy), createDataCache (copy), FFlagConnectionManagementChips (copy), createDataResolver (copy), Requests (copy), Cryo (copy), createTrustedConnectionEventListener (copy), TrustedConnectionStatus (copy), getLocalPlayerUserId (copy), Promise (copy), FFlagTCShareLinkReceiverUI (copy)
	local v15 = not (v13 > 0) and 1e999 or v13
	local v16 = createDataCache(v15)
	local v17 = createDataCache(v15)
	local v18 = if not FFlagConnectionManagementChips then nil else createDataCache(v15)
	local v19 = if not FFlagConnectionManagementChips then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v18,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(s1: string) -- line: 69
			-- upvalues: Requests (copy), Cryo (copy)
			return Requests.GetUserTrustedConnections(s1):andThen(function(p1) -- line: 70
				-- upvalues: Cryo (copy)
				local v47 = p1.PageItems or {}

				return Cryo.List.map(v47, function(p2) -- line: 72
					return {
						id = tostring(p2.id)
					}
				end)
			end)
		end
	})
	local v20 = createTrustedConnectionEventListener(function(s2: string, p3) -- line: 83
		-- upvalues: v16 (copy), v17 (copy), TrustedConnectionStatus (copy), FFlagConnectionManagementChips (copy), getLocalPlayerUserId (copy), v19 (copy)
		v16.updateItems({
			[s2] = p3
		})
		v17.updateItems({
			[s2] = p3 == TrustedConnectionStatus.TrustedFriends
		})

		if FFlagConnectionManagementChips then
			local v27 = getLocalPlayerUserId()

			if v27 then
				v19.fetchItem((tostring(v27)))
			end
		end
	end)
	local v21 = createDataResolver({
		cache = v17,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t1: {[any]: any}) -- line: 105
			-- upvalues: Cryo (copy), Requests (copy)
			local v29 = Cryo.Dictionary.keys(t1)

			return Requests.MultiGetUsersAreTrustedConnections(v29):andThen(function(p4) -- line: 107
				-- upvalues: Cryo (copy), v29 (copy)
				local v49 = Cryo.List.foldLeft(p4, function(p5, p6) -- line: 108
					p5[tostring(p6)] = true

					return p5
				end, {})

				return Cryo.List.foldLeft(v29, function(p7, p8) -- line: 113
					-- upvalues: v49 (copy)
					p7[tostring(p8)] = v49[p8] or false

					return p7
				end, {})
			end)
		end
	})
	local v22 = createDataResolver({
		cache = v16,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t2: {[any]: any}) -- line: 124
			-- upvalues: Cryo (copy), Requests (copy), Promise (copy)
			local v31 = Cryo.Dictionary.keys(t2)
			local v32 = Cryo.List.foldLeft(v31, function(p9, p10) -- line: 126
				-- upvalues: Requests (copy)
				table.insert(p9, Requests.GetUserTrustedConnectionStatus(p10):andThen(function(p11) -- line: 130
					-- upvalues: p10 (copy)
					return {
						[p10] = p11
					}
				end))

				return p9
			end, {})

			return Promise.all(v32):andThen(function(p12) -- line: 137
				-- upvalues: Cryo (copy)
				return Cryo.Dictionary.join(table.unpack(p12))
			end)
		end
	})
	local v23 = if not FFlagConnectionManagementChips then nil else function() -- line: 152
		-- upvalues: getLocalPlayerUserId (copy), v19 (copy)
		local v35 = getLocalPlayerUserId()

		return v19.getAndFetchItem((tostring(v35)))
	end

	return {
		getStatus = function(s3: string) -- line: 143
			-- upvalues: v22 (copy)
			return v22.getAndFetchItem(s3)
		end,
		getIsTrustedConnection = function(s4: string) -- line: 147
			-- upvalues: v21 (copy)
			return v21.getAndFetchItem(s4)
		end,
		getUserTrustedConnections = if not FFlagConnectionManagementChips then nil else v23,
		sendTrustedConnectionRequest = function(s5: string, s6: string?) -- line: 158
			-- upvalues: Requests (copy), v16 (copy), TrustedConnectionStatus (copy)
			return Requests.PostUserSendTrustedConnectionRequest(s5, s6):andThen(function() -- line: 159
				-- upvalues: v16 (copy), s5 (copy), TrustedConnectionStatus (copy)
				v16.updateItems({
					[s5] = TrustedConnectionStatus.RequestSent
				})
			end)
		end,
		acceptTrustedConnectionRequest = function(s7: string) -- line: 166
			-- upvalues: Requests (copy), v16 (copy), TrustedConnectionStatus (copy), v17 (copy)
			return Requests.PostUserAcceptTrustedConnectionRequest(s7):andThen(function() -- line: 167
				-- upvalues: v16 (copy), s7 (copy), TrustedConnectionStatus (copy), v17 (copy)
				v16.updateItems({
					[s7] = TrustedConnectionStatus.TrustedFriends
				})
				v17.updateItems({
					[s7] = true
				})
			end)
		end,
		ignoreTrustedConnectionRequest = function(s8: string) -- line: 178
			-- upvalues: Requests (copy), v16 (copy), TrustedConnectionStatus (copy)
			return Requests.PostUserIgnoreTrustedConnectionRequest(s8):andThen(function() -- line: 179
				-- upvalues: v16 (copy), s8 (copy), TrustedConnectionStatus (copy)
				v16.updateItems({
					[s8] = TrustedConnectionStatus.RequestIgnored
				})
			end)
		end,
		removeTrustedConnectionRequest = function(s9: string) -- line: 186
			-- upvalues: Requests (copy), v16 (copy), TrustedConnectionStatus (copy), v17 (copy)
			return Requests.PostUserRemoveTrustedConnection(s9):andThen(function() -- line: 187
				-- upvalues: v16 (copy), s9 (copy), TrustedConnectionStatus (copy), v17 (copy)
				v16.updateItems({
					[s9] = TrustedConnectionStatus.RequestReceived
				})
				v17.updateItems({
					[s9] = false
				})
			end)
		end,
		createTrustedFriendLink = function(s10: string) -- line: 198
			-- upvalues: Requests (copy)
			return Requests.PostUserCreateTrustedFriendLink(s10)
		end,
		validateTrustedFriendLink = if not FFlagTCShareLinkReceiverUI then nil else function(s11: string, t3: {[any]: any}) -- line: 202
			-- upvalues: Requests (copy)
			return Requests.PostUserValidateTrustedFriendLink(s11, t3)
		end,
		addTrustedFriendFromLink = if not FFlagTCShareLinkReceiverUI then nil else function(s12: string, t4: {[any]: any}) -- line: 206
			-- upvalues: Requests (copy)
			return Requests.PostUserAddTrustedFriendFromLink(s12, t4)
		end,
		clear = function() -- line: 210
			-- upvalues: v16 (copy), v17 (copy), v21 (copy), v22 (copy), FFlagConnectionManagementChips (copy), v18 (copy), v19 (copy)
			v16.clear()
			v17.clear()
			v21.clear()
			v22.clear()

			if FFlagConnectionManagementChips then
				v18.clear()
				v19.clear()
			end
		end,
		dispose = function() -- line: 222
			-- upvalues: v16 (copy), v17 (copy), v21 (copy), v22 (copy), v20 (copy), FFlagConnectionManagementChips (copy), v18 (copy), v19 (copy)
			v16.dispose()
			v17.dispose()
			v21.dispose()
			v22.dispose()
			v20()

			if FFlagConnectionManagementChips then
				v18.dispose()
				v19.dispose()
			end
		end
	}
end

return createTrustedConnectionsStore
