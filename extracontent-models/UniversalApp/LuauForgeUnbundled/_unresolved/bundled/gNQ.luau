local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module2 = require("@luauforge/bundled/dMP")

local module3 = require("@luauforge/bundled/gNO")
local module4 = require("@luauforge/bundled/dSY")
require("@luauforge/bundled/dTN")

require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module5 = require("@luauforge/bundled/dMx")

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local api = AvatarExperienceCatalog.Api

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXUseSignalsForAvatarsTabSearchInfo = AvatarExperienceFlags.FFlagAXUseSignalsForAvatarsTabSearchInfo
local getAvatarsTabSearchInfoStore

if fFlagAXUseSignalsForAvatarsTabSearchInfo then
	getAvatarsTabSearchInfoStore = AvatarExperienceCatalog.Stores.getAvatarsTabSearchInfoStore
else
	getAvatarsTabSearchInfoStore = nil
end

local defineFastFlag = game:DefineFastFlag("AXAvatarsTabNoItemsFound", false)

require(CorePackages.Packages.LuauPolyfill)

return function(data, p2)
	return function(object)
		local function showAvatarsTabError()
			sendAXCounterV2(module5.Counter.FetchCatalogSearchForLooksError, {
				page = data.searchKeyword == nil and "Catalog" or "Search"
			})

			object:dispatch(module3(data.searchUuid, {
				hasMoreEntries = true,
				items = {},
				keyword = data.searchKeyword
			}))
		end

		assert(
			api.getLooksFromWidgetListInfo,
			"Function exists if Avatars Tab is enabled. Assert can be removed with Avatars Tab Experiment removal"
		)

		local looksFromWidgetListInfo, v5 = api.getLooksFromWidgetListInfo(
			p2,
			data.searchUuid,
			data.searchKeyword,
			data.categoryInfo
		)

		return looksFromWidgetListInfo:andThen(function(p3)
			local success, result = pcall(function()
				for k, v6 in p3 and p3.widgets or {} do
					return v6.content
				end

				return {}
			end)

			if success and #result ~= 0 then
				return GetExperienceSourceLanguage.HydrateWidgetContent(p2, result):andThen(function(p4)
					local responseBody = if p4 then p4.responseBody else nil
					local hydratedContent = if responseBody then responseBody.hydratedContent else nil

					if hydratedContent == nil then
						return
					end

					assert(hydratedContent, "")
					local v6 = { Look = {} }

					for k, v7 in hydratedContent do
						if fFlagAXMigrateAllTabToSduiDev then
							if v7.type == "Look" then
								local id = tostring(v7.id)
								v6.Look[id] = v7
							end
						else
							local kind = v7.type
							assert(kind, "Look")
							local id = tostring(v7.id)
							v6[kind][id] = v7
						end
					end

					local v7 = {
						hasMoreEntries = false,
						items = {},
						keyword = data.searchKeyword
					}

					for k, v8 in result do
						local id = tostring(v8.id)

						if v6.Look[id] then
							table.insert(v7.items, { ["id"] = id, type = "Look" })
						end
					end

					if #v7.items == 0 then
						return showAvatarsTabError()
					end

					object:dispatch(module2(v6))
					object:dispatch(module3(data.searchUuid, v7))

					if data.searchKeyword then
						if fFlagAXUseSignalsForAvatarsTabSearchInfo then
							getAvatarsTabSearchInfoStore(false).setAvatarsTabSearchInfo(
								data.searchUuid,
								data.searchKeyword
							)
						else
							object:dispatch(module4(data.searchUuid, data.searchKeyword))
						end
					end
				end, function(p4)
					logging.warn("WebApi failure in FetchHydratedWidgetContent: " .. tostring(p4))

					return showAvatarsTabError()
				end)
			end

			if defineFastFlag and #result == 0 then
				return object:dispatch(module3(data.searchUuid, {
					hasMoreEntries = false,
					items = {},
					keyword = data.searchKeyword
				}))
			end

			return showAvatarsTabError()
		end)
	end
end
