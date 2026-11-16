local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)
require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local DataStatus = DataHydrationTypes.DataStatus

local fetchAvatarBackground = require(script.Parent.fetchAvatarBackground)
local getAvatarBackgroundImageUrl = require(script.Parent.getAvatarBackgroundImageUrl)
require(script.Parent.AvatarBackgroundStoreTypes)

local function createAvatarBackgroundStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }
	local v3 = {}

	local function rejectPending() -- 1 equivalent call inferred from this helper
		local v4 = v3
		v3 = {}

		for _, v5 in v4 do
			v5("avatar background store was cleared")
		end
	end

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchAvatarBackground(p, v2)
	end, {
		cache = { ttlSeconds = v.ttlSeconds },
		resolver = { replaceItems = true, onClear = rejectPending }
	})

	local function getAndFetchAvatarBackground(p) -- 2 equivalent calls inferred from this helper
		return (singleEntityResolver.getAndFetch((tonumber(p))))
	end

	return {
		getAndFetchAvatarBackground = getAndFetchAvatarBackground,
		getAndFetchAvatarBackgroundImageUrl = function(p, p2)
			local data = getAndFetchAvatarBackground(p).data(p2) -- inferred equivalent call
			local assetId = data and data.assetId

			if assetId then
				return (getAvatarBackgroundImageUrl(assetId))
			end

			return nil
		end,
		awaitAvatarBackground = function(p)
			local fetchAvatarBackground2 = getAndFetchAvatarBackground(p) -- inferred equivalent call
			return Promise.new(function(callback, callback2, callback3)
				local flag = false
				local v4 = nil
				local v5 = {}
				local function settle() -- 2 equivalent calls inferred from this helper
					flag = true
					v3[v5] = nil

					if v4 then
						v4()
					end
				end
				v3[v5] = function(p2)
					if flag then
						return
					end

					flag = true
					callback2(p2)
					task.defer(settle)
				end
				v4 = Signals.createEffect(function(p2)
					local status = fetchAvatarBackground2.status(p2)

					if flag or status == DataStatus.NotReady then
						return
					end

					if status == DataStatus.Ready then
						callback(fetchAvatarBackground2.data(false) or {})
					else
						callback2("Avatar background lookup failed")
					end

					settle() -- inferred equivalent call
				end)

				if flag then
					settle() -- inferred equivalent call
				end

				callback3(settle)
			end)
		end,
		clear = singleEntityResolver.clear,
		dispose = function()
			rejectPending() -- inferred equivalent call
			singleEntityResolver.dispose()
		end
	}
end

return createAvatarBackgroundStore
