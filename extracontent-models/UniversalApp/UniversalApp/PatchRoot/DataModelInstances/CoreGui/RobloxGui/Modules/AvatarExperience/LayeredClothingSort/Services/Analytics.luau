local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.Analytics)

local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

return {
	get = function(p1) -- line: 14
		-- upvalues: RoactAnalytics (copy), CatalogConstants (copy)
		local v7 = RoactAnalytics.get(p1)

		return {
			avatarRefineButtonTap = function(p2, p3, p4) -- line: 19
				-- upvalues: v7 (copy)
				v7.EventStream:sendEventDeferred(p2, "avatarRefineButtonTap", {
					category = p4,
					uid = p3
				})
			end,
			avatarRefineLayersResetTap = function(p5, p6) -- line: 27
				-- upvalues: v7 (copy)
				v7.EventStream:sendEventDeferred(p5, "avatarRefineLayersResetTap", {
					uid = p6
				})
			end,
			avatarRefineLayersResetConfirm = function(p7, p8) -- line: 34
				-- upvalues: v7 (copy)
				v7.EventStream:sendEventDeferred(p7, "avatarRefineLayersResetConfirm", {
					uid = p8
				})
			end,
			avatarRefineGoBack = function(p9, p10) -- line: 41
				-- upvalues: CatalogConstants (copy), v7 (copy)
				local s1 = "Editor"

				if p9 == CatalogConstants.AnalyticsContext.AvatarShop then
					s1 = "Catalog"
				end

				v7.EventStream:sendEventDeferred(p9, "avatarRefineGoBack", {
					page = s1,
					uid = p10
				})
			end,
			avatarRefineAutosaved = function(p11, p12) -- line: 54
				-- upvalues: v7 (copy)
				v7.EventStream:sendEventDeferred(p11, "avatarRefineAutosaved", {
					uid = p12
				})
			end
		}
	end
}
