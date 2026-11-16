local HttpService = game:GetService("HttpService")

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Signals = require(parent.Signals)
local HttpStore = require(parent.HttpStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUseAppHttpStore = SharedFlags.FFlagLuaAppUseAppHttpStore
local InternalHttpStore = require(parent.InternalHttpStore)

require(ProfilePlatform.Parent.GraphQLServer)

local v = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/groups/{id}")
local v2 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{eventId}/rsvps")

local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)

local v3 = {}

local function createGroupEventsStore(id2: number)
	local v4 = InternalHttpStore.GetHttpStore()

	v4 = FFlagLuaAppUseAppHttpStore and HttpStore.Instance.get() or v4

	local signal, v5 = Signals.createSignal(0)

	local v6 = {}
	local signal2, v7 = Signals.createSignal(v6)

	local computed = Signals.createComputed(function(p)
		local v8 = signal(p)
		local v9 = string.format("GetEvents_%d_%d", id2, v8)
		local v10 = {
			Url = v({ id = id2 }),
			Method = "GET"
		}

		return v4.fetch(v9, v10)
	end)

	local v8 = v3
	local v9 = nil

	local groupEventsStore = {
		getEvents = Signals.createComputed(function(p)
			local v10 = computed(p)(p)
			local v11 = signal2(p)

			if v10.status == "Success" then
				local result = {}
				local success, result2 = pcall(HttpService.JSONDecode, HttpService, v10.response.Body)

				if success and result2 ~= nil and result2.data ~= nil then
					for k, v12 in pairs(result2.data) do
						v12.universeId = tostring(v12.universeId)

						local userRsvpStatus = v11[v12.id]

						if userRsvpStatus ~= nil then
							v12.userRsvpStatus = userRsvpStatus
						end

						result[k] = v12
					end
				end

				v8 = result
				return result
			elseif v10.status == "Failed" then
				return {}
			else
				return v8
			end
		end),
		isLoading = 0,
		updateRsvpStatus = 0,
		refetch = 0
	}
	local isLoading

	if FFlagEnableCommunityProfileLoadingSkeletons then
		isLoading = Signals.createComputed(function(p): boolean
			return computed(p)(p).status == "Fetching"
		end)
	end

	groupEventsStore.isLoading = isLoading

	local function fn(id, p) -- 2 equivalent calls inferred from this helper
		local v10 = v6
		local clone = table.clone(v10)
		clone[id] = p
		v7(clone)
		v6 = clone
	end

	function groupEventsStore.updateRsvpStatus(p, rsvpStatus)
		local v10 = string.format("UpdateEventRsvpStatus_%s_%s", p.id, rsvpStatus)
		local v11 = {
			Url = v2({ eventId = p.id }),
			Method = "POST",
			Body = HttpService:JSONEncode({ rsvpStatus = rsvpStatus }),
			Headers = { ["Content-Type"] = "application/json" }
		}

		local fetched = v4.fetch(v10, v11)

		local v12 = v6[p.id]
		fn(p.id, rsvpStatus) -- inferred equivalent call

		if v9 then
			v9()
		end

		v9 = Signals.createEffect(function(p2)
			if fetched(p2).status == "Failed" then
				fn(p.id, v12) -- inferred equivalent call
			end
		end)

		return fetched
	end

	function groupEventsStore.refetch()
		v5(function(p)
			return p + 1
		end)

		v7(function(_)
			return {}
		end)
	end

	return groupEventsStore
end

return createGroupEventsStore
