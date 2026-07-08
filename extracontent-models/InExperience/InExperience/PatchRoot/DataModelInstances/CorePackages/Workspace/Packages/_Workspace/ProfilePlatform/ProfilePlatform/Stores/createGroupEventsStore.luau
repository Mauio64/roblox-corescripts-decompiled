local HttpService = game:GetService("HttpService")
local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local UrlBuilder = require(ProfilePlatformParent.UrlBuilder).UrlBuilder
local Signals = require(ProfilePlatformParent.Signals)
local HttpStore = require(ProfilePlatformParent.HttpStore)
local FFlagLuaAppUseAppHttpStore = require(ProfilePlatformParent.SharedFlags).FFlagLuaAppUseAppHttpStore
local InternalHttpStore = require(ProfilePlatformParent.InternalHttpStore)

require(ProfilePlatform.Parent.GraphQLServer)

local v9 = UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/groups/{id}")
local v10 = UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{eventId}/rsvps")
local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)
local t1 = {}

local function createGroupEventsStore(n1: number) -- line: 22
	-- upvalues: InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), v9 (copy), t1 (copy), HttpService (copy), FFlagEnableCommunityProfileLoadingSkeletons (copy), v10 (copy)
	local u15 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		local v16 = HttpStore.Instance.get()

		if v16 then
			u15 = v16
		end
	end

	local v17, v18 = Signals.createSignal(0)
	local t2 = {}
	local v20, v21 = Signals.createSignal(t2)
	local v22 = Signals.createComputed(function(p1) -- line: 45
		-- upvalues: v17 (copy), n1 (copy), v9 (copy), u15 (ref)
		local v30 = v17(p1)
		local v31 = string.format("GetEvents_%d_%d", n1, v30)
		local t3 = {
			Method = "GET",
			Url = v9({
				id = n1
			})
		}

		return u15.fetch(v31, t3)
	end)
	local u23 = t1
	local u24 = nil

	return {
		getEvents = Signals.createComputed(function(p2) -- line: 59
			-- upvalues: v22 (copy), v20 (copy), HttpService (copy), u23 (ref)
			local v34 = v22(p2)(p2)
			local v35 = v20(p2)

			if v34.status == "Success" then
				local t4 = {}
				local ok, result = pcall(HttpService.JSONDecode, HttpService, v34.response.Body)

				if ok then
					for k, v in pairs(result.data) do
						v.universeId = tostring(v.universeId)

						local v41 = v35[v.id]

						if v41 ~= nil then
							v.userRsvpStatus = v41
						end

						t4[k] = v
					end
				end

				u23 = t4

				return t4
			end

			if v34.status == "Failed" then
				return {}
			end

			return u23
		end),
		isLoading = if not FFlagEnableCommunityProfileLoadingSkeletons then nil else Signals.createComputed(function(p3) -- line: 94
			-- upvalues: v22 (copy)
			return v22(p3)(p3).status == "Fetching"
		end),
		updateRsvpStatus = function(p4, p5) -- line: 101
			-- upvalues: v10 (copy), HttpService (copy), u15 (ref), t2 (ref), v21 (copy), u24 (ref), Signals (copy)
			local v45 = string.format("UpdateEventRsvpStatus_%s_%s", p4.id, p5)
			local t5 = {
				Method = "POST",
				Url = v10({
					eventId = p4.id
				}),
				Body = HttpService:JSONEncode({
					rsvpStatus = p5
				}),
				Headers = {
					["Content-Type"] = "application/json"
				}
			}
			local v47 = u15.fetch(v45, t5)
			local v48 = t2[p4.id]
			local id = p4.id
			local v50 = t2
			local v51 = table.clone(v50)

			v51[id] = p5
			v21(v51)
			t2 = v51

			if u24 then
				u24()
			end

			u24 = Signals.createEffect(function(p6) -- line: 118
				-- upvalues: v47 (copy), p4 (copy), v48 (copy), t2 (ref), v21 (copy)
				if v47(p6).status == "Failed" then
					local id2 = p4.id
					local v54 = v48
					local v55 = t2
					local v56 = table.clone(v55)

					v56[id2] = v54
					v21(v56)
					t2 = v56
				end
			end)

			return v47
		end,
		refetch = function() -- line: 129
			-- upvalues: v18 (copy), v21 (copy)
			v18(function(p7) -- line: 131
				return p7 + 1
			end)
			v21(function(_) -- line: 135
				return {}
			end)
		end
	}
end

return createGroupEventsStore
