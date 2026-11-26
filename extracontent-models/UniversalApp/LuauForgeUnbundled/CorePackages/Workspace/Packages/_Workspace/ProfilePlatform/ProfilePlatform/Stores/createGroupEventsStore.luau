local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")
local HttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/HttpStore")

local fFlagLuaAppUseAppHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagLuaAppUseAppHttpStore
local InternalHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InternalHttpStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GraphQLServer")

local v5 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/groups/{id}")
local v6 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{eventId}/rsvps")

local FFlagEnableCommunityProfileLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableCommunityProfileLoadingSkeletons")

local v7 = {}

local function createGroupEventsStore(p2)
	local v8 = InternalHttpStore.GetHttpStore()

	v8 = fFlagLuaAppUseAppHttpStore and HttpStore.Instance.get() or v8

	local signal, v9 = Signals.createSignal(0)

	local v10 = {}
	local signal2, v11 = Signals.createSignal(v10)

	local computed = Signals.createComputed(function(p3)
		local v12 = signal(p3)
		local v13 = string.format("GetEvents_%d_%d", p2, v12)
		local v14 = {
			Url = v5({ id = p2 }),
			Method = "GET"
		}

		return v8.fetch(v13, v14)
	end)

	local v12 = v7
	local v13 = nil

	local groupEventsStore = {
		getEvents = Signals.createComputed(function(p3)
			local v14 = computed(p3)(p3)
			local v15 = signal2(p3)

			if v14.status == "Success" then
				local result = {}
				local success, result2 = pcall(HttpService.JSONDecode, HttpService, v14.response.Body)

				if success and result2 ~= nil and result2.data ~= nil then
					for k, v16 in pairs(result2.data) do
						v16.universeId = tostring(v16.universeId)

						local v17 = v15[v16.id]

						if v17 ~= nil then
							v16.userRsvpStatus = v17
						end

						result[k] = v16
					end
				end

				v12 = result
				return result
			elseif v14.status == "Failed" then
				return {}
			else
				return v12
			end
		end),
		isLoading = 0,
		updateRsvpStatus = 0,
		refetch = 0
	}
	local v14

	if FFlagEnableCommunityProfileLoadingSkeletons then
		v14 = Signals.createComputed(function(p3): boolean
			return computed(p3)(p3).status == "Fetching"
		end)
	end

	groupEventsStore.isLoading = v14

	function groupEventsStore.updateRsvpStatus(p3, p4)
		local v15 = string.format("UpdateEventRsvpStatus_%s_%s", p3.id, p4)
		local v16 = {
			Url = v6({ eventId = p3.id }),
			Method = "POST",
			Body = HttpService:JSONEncode({ rsvpStatus = p4 }),
			Headers = { ["Content-Type"] = "application/json" }
		}

		local fetched = v8.fetch(v15, v16)

		local v17 = v10[p3.id]
		local id = p3.id
		local v18 = v10
		local clone = table.clone(v18)
		clone[id] = p4
		v11(clone)
		v10 = clone

		if v13 then
			v13()
		end

		v13 = Signals.createEffect(function(p5)
			if fetched(p5).status == "Failed" then
				local id2 = p3.id
				local v20 = v10
				local clone2 = table.clone(v20)
				clone2[id2] = v17
				v11(clone2)
				v10 = clone2
			end
		end)

		return fetched
	end

	function groupEventsStore.refetch()
		v9(function(p3)
			return p3 + 1
		end)

		v11(function(p3)
			return {}
		end)
	end

	return groupEventsStore
end

return createGroupEventsStore
