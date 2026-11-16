require("@luauforge/bundled/bXw")
local module = require("@luauforge/bundled/dYT")
local module2 = require("@luauforge/bundled/dME")

return {
	get = function(p2)
		local v5 = module.get(p2)

		return {
			avatarRefineButtonTap = function(p3, p4, p5)
				v5.EventStream:sendEventDeferred(p3, "avatarRefineButtonTap", {
					category = p5,
					uid = p4
				})
			end,
			avatarRefineLayersResetTap = function(p3, p4)
				v5.EventStream:sendEventDeferred(p3, "avatarRefineLayersResetTap", {
					uid = p4
				})
			end,
			avatarRefineLayersResetConfirm = function(p3, p4)
				v5.EventStream:sendEventDeferred(p3, "avatarRefineLayersResetConfirm", {
					uid = p4
				})
			end,
			avatarRefineGoBack = function(p3, p4)
				local v6 = p3 == module2.AnalyticsContext.AvatarShop and "Catalog" or "Editor"

				v5.EventStream:sendEventDeferred(p3, "avatarRefineGoBack", {
					page = v6,
					uid = p4
				})
			end,
			avatarRefineAutosaved = function(p3, p4)
				v5.EventStream:sendEventDeferred(p3, "avatarRefineAutosaved", {
					uid = p4
				})
			end
		}
	end
}
