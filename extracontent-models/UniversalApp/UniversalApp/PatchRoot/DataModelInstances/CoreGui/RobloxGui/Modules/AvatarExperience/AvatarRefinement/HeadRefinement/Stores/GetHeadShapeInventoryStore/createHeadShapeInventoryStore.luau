local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Signals = require(CorePackages.Packages.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local Modules = CoreGui.RobloxGui.Modules
local HttpStore = require(CorePackages.Workspace.Packages.HttpStore)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppUseAppHttpStore = SharedFlags.FFlagLuaAppUseAppHttpStore
local FFlagLuaAppHeadShapeInventory = SharedFlags.FFlagLuaAppHeadShapeInventory
local FFlagAXInventoryIncludeUnavailableItems = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXInventoryIncludeUnavailableItems
local InternalHttpStore = require(CorePackages.Workspace.Packages.InternalHttpStore)
local isHttpStoreFetchCancelled = HttpStore.isHttpStoreFetchCancelled
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError

local function createHeadShapeInventoryStore() -- line: 39
	-- upvalues: createSignal (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Modules (copy), FFlagAXInventoryIncludeUnavailableItems (copy), Signals (copy), FFlagLuaAppHeadShapeInventory (copy), HttpService (copy), mutedError (copy), isHttpStoreFetchCancelled (copy), createComputed (copy)
	local v17, v18 = createSignal(nil)
	local u19 = false
	local u20 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		local v21 = HttpStore.Instance.get()

		if v21 then
			u20 = v21
		end
	end

	local u22 = nil

	local function fetchInventory() -- line: 59
		-- upvalues: v17 (copy), u19 (ref), Modules (copy), FFlagAXInventoryIncludeUnavailableItems (copy), u20 (ref), u22 (ref), Signals (copy), FFlagLuaAppHeadShapeInventory (copy), HttpService (copy), v18 (copy), mutedError (copy), isHttpStoreFetchCancelled (copy)
		if v17(false) or u19 then
			return
		end

		u19 = true

		local Url = require(Modules.LuaApp.Http.Url)
		local t1 = {
			pageLimit = 100,
			sortOption = "recentAdded",
			pageToken = "",
			includeUnavailableItems = not not FFlagAXInventoryIncludeUnavailableItems or nil,
			["itemCategories[0].itemType"] = "HeadShape",
			["itemCategories[0].itemSubType"] = 1
		}
		local v26 = string.format("%sv1/avatar-inventory?%s", Url.AVATAR_URL, Url:makeQueryString(t1))
		local v27, _ = u20.fetch("HeadShapeInventory", {
			Method = "GET",
			Url = v26
		})

		if u22 then
			u22()
		end

		u22 = Signals.createEffect(function(p1) -- line: 90
			-- upvalues: v27 (copy), FFlagLuaAppHeadShapeInventory (copy), HttpService (copy), u22 (ref), v18 (copy), u19 (ref), mutedError (copy), isHttpStoreFetchCancelled (copy)
			local v32 = v27(p1)

			if v32.status == "Success" then
				local v33 = if not FFlagLuaAppHeadShapeInventory then v32.response.Body else v32.response.Body
				local ok, result = pcall(function() -- line: 96
					-- upvalues: HttpService (copy), v33 (copy)
					return HttpService:JSONDecode(v33)
				end)

				if ok and result then
					if FFlagLuaAppHeadShapeInventory then
						task.defer(function() -- line: 101
							-- upvalues: u22 (ref), v18 (copy), result (copy), u19 (ref)
							local v36 = u22

							if v36 then
								u22 = nil
								v36()
							end

							v18(result)
							u19 = false
						end)

						return
					end

					v18(result)
					u19 = false

					return
				end

				mutedError("Failed to decode HeadShape inventory JSON response")
				u19 = false

				return
			end

			if v32.status == "Failed" then
				if FFlagLuaAppHeadShapeInventory then
					if not isHttpStoreFetchCancelled(v32) then
						mutedError("Failed to fetch HeadShape inventory")
					end
				else
					mutedError("Failed to fetch HeadShape inventory")
				end

				u19 = false
			end
		end)
	end

	return {
		getInventory = createComputed(function(p2) -- line: 133
			-- upvalues: v17 (copy), u19 (ref), fetchInventory (copy)
			local v30 = v17(p2)

			if v30 == nil and not u19 then
				fetchInventory()
			end

			return v30
		end),
		fetchInventory = fetchInventory
	}
end

return createHeadShapeInventoryStore
