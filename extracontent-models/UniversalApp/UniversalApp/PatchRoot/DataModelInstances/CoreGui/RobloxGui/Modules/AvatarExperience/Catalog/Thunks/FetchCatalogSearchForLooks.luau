local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local SetSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.SetSearchInCatalog)
local SetAvatarsTabSearchInfo = require(Modules.AvatarExperience.Catalog.Actions.SetAvatarsTabSearchInfo)

require(Modules.AvatarExperience.Catalog.SearchTypes)
require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Api = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Api
local v11 = game:DefineFastFlag("AXAvatarsTabNoItemsFound", false)

require(CorePackages.Packages.LuauPolyfill)

return function(p1, p2: ((...any) -> ...any)) -- line: 38
	-- upvalues: sendAXCounterV2 (copy), Constants (copy), SetSearchInCatalog (copy), Api (copy), v11 (copy), WebApi (copy), SetHydratedWidgetData (copy), SetAvatarsTabSearchInfo (copy), Logging (copy)
	return function(p3) -- line: 39
		-- upvalues: sendAXCounterV2 (copy), Constants (copy), p1 (copy), SetSearchInCatalog (copy), Api (copy), p2 (copy), v11 (copy), WebApi (copy), SetHydratedWidgetData (copy), SetAvatarsTabSearchInfo (copy), Logging (copy)
		local function showAvatarsTabError() -- line: 40
			-- upvalues: sendAXCounterV2 (copy), Constants (copy), p1 (copy), p3 (copy), SetSearchInCatalog (copy)
			sendAXCounterV2(Constants.Counter.FetchCatalogSearchForLooksError, {
				page = p1.searchKeyword == nil and "Catalog" or "Search"
			})
			p3:dispatch(SetSearchInCatalog(p1.searchUuid, {
				hasMoreEntries = true,
				items = {},
				keyword = p1.searchKeyword
			}))
		end

		assert(Api.getLooksFromWidgetListInfo, "Function exists if Avatars Tab is enabled. Assert can be removed with Avatars Tab Experiment removal")

		local v16, _ = Api.getLooksFromWidgetListInfo(p2, p1.searchUuid, p1.searchKeyword, p1.categoryInfo)

		return v16:andThen(function(p4) -- line: 65
			-- upvalues: v11 (copy), p3 (copy), SetSearchInCatalog (copy), p1 (copy), showAvatarsTabError (copy), WebApi (copy), p2 (copy), SetHydratedWidgetData (copy), SetAvatarsTabSearchInfo (copy), Logging (copy)
			local ok, result = pcall(function() -- line: 66
				-- upvalues: p4 (copy)
				for _, v22 in p4 and p4.widgets or {} do
					return v22.content
				end

				return {}
			end)

			if not ok or #result == 0 then
				if v11 and #result == 0 then
					return p3:dispatch(SetSearchInCatalog(p1.searchUuid, {
						hasMoreEntries = false,
						items = {},
						keyword = p1.searchKeyword
					}))
				end

				return showAvatarsTabError()
			end

			return WebApi.HydrateWidgetContent(p2, result):andThen(function(p5) -- line: 85
				-- upvalues: p1 (copy), result (copy), showAvatarsTabError (copy), p3 (copy), SetHydratedWidgetData (copy), SetSearchInCatalog (copy), SetAvatarsTabSearchInfo (copy)
				local v24 = if not p5 then nil else p5.responseBody
				local v25 = if not v24 then nil else v24.hydratedContent

				if v25 == nil then
					return
				end

				assert(v25, "")

				local t1 = {
					Look = {}
				}

				for _, v28 in v25 do
					local type = v28.type

					assert(type, "Look")

					local str = tostring(v28.id)

					t1[type][str] = v28
				end

				local t2 = {
					hasMoreEntries = false,
					items = {},
					keyword = p1.searchKeyword
				}

				for _, v33 in result do
					local str = tostring(v33.id)

					if t1.Look[str] then
						table.insert(t2.items, {
							id = str,
							type = "Look"
						})
					end
				end

				if #t2.items == 0 then
					return showAvatarsTabError()
				end

				p3:dispatch(SetHydratedWidgetData(t1))
				p3:dispatch(SetSearchInCatalog(p1.searchUuid, t2))

				if p1.searchKeyword then
					p3:dispatch(SetAvatarsTabSearchInfo(p1.searchUuid, p1.searchKeyword))
				end
			end, function(p6) -- line: 127
				-- upvalues: Logging (copy), showAvatarsTabError (copy)
				Logging.warn("WebApi failure in FetchHydratedWidgetContent: " .. tostring(p6))

				return showAvatarsTabError()
			end)
		end)
	end
end
