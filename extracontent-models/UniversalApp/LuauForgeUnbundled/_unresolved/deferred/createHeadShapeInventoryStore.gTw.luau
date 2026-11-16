local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local Signals = require(CorePackages.Packages.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local module = require("@luauforge/bundled/fBN")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppUseAppHttpStore = SharedFlags.FFlagLuaAppUseAppHttpStore
local fFlagLuaAppHeadShapeInventory = SharedFlags.FFlagLuaAppHeadShapeInventory
local fFlagAXInventoryIncludeUnavailableItems = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXInventoryIncludeUnavailableItems

local module3 = require("@luauforge/deferred/gTx")
local isHttpStoreFetchCancelled = module.isHttpStoreFetchCancelled

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local function createHeadShapeInventoryStore()
	local signal, v5 = createSignal(nil)
	local v6 = false

	local v7 = module3.GetHttpStore()

	v7 = fFlagLuaAppUseAppHttpStore and module.Instance.get() or v7

	local v8 = nil

	local function fetchInventory()
		if signal(false) or v6 then
			return
		end

		v6 = true

		local module4 = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
		local v9 = {
			pageLimit = 100,
			sortOption = "recentAdded",
			pageToken = "",
			includeUnavailableItems = fFlagAXInventoryIncludeUnavailableItems and true or nil
		}

		v9["itemCategories[0].itemType"] = "HeadShape"
		v9["itemCategories[0].itemSubType"] = 1

		local v10 = string.format(
			"%sv1/avatar-inventory?%s",
			module4.AVATAR_URL,
			module4:makeQueryString(v9)
		)
		local fetched, v11 = v7.fetch("HeadShapeInventory", {
			Url = v10,
			Method = "GET"
		})

		if v8 then
			v8()
		end

		v8 = Signals.createEffect(function(p2)
			local v12 = fetched(p2)

			if v12.status == "Success" then
				if fFlagLuaAppHeadShapeInventory then
				end

				local body = v12.response.Body

				local success, result = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				if success and result then
					if fFlagLuaAppHeadShapeInventory then
						task.defer(function()
							local v13 = v8

							if v13 then
								v8 = nil
								v13()
							end

							v5(result)
							v6 = false
						end)
						return
					end

					v5(result)
				else
					mutedError("Failed to decode HeadShape inventory JSON response")
				end

				v6 = false
			elseif v12.status == "Failed" then
				if fFlagLuaAppHeadShapeInventory then
					if not isHttpStoreFetchCancelled(v12) then
						mutedError("Failed to fetch HeadShape inventory")
					end
				else
					mutedError("Failed to fetch HeadShape inventory")
				end

				v6 = false
			end
		end)
	end

	return {
		getInventory = createComputed(function(p2)
			local v9 = signal(p2)

			if v9 == nil and not v6 then
				fetchInventory()
			end

			return v9
		end),
		fetchInventory = fetchInventory
	}
end

return createHeadShapeInventoryStore
