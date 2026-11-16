local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module2 = require("@luauforge/bundled/dMP")

local module3 = require("@luauforge/bundled/gos")

return function(p2, items, p3)
	return performFetch.Single("hydrateWidgetKey." .. p3, function(object)
		return GetExperienceSourceLanguage.HydrateWidgetContent(p2, items):andThen(function(p4)
			local responseBody = if p4 then p4.responseBody else nil
			local hydratedContent = if responseBody then responseBody.hydratedContent else nil

			if hydratedContent == nil then
				return
			end

			assert(hydratedContent, "")
			local v5 = {}

			for k, v6 in hydratedContent do
				local kind = v6.type
				local id = tostring(v6.id)

				if not v5[kind] then
					v5[kind] = {}
				end

				v5[kind][id] = v6
			end

			for k, item in items do
				local kind = item.type
				local id = tostring(item.id)

				if not v5[kind] then
					v5[kind] = {}
				end

				if v5[kind][id] then
					if module3() then
						v5[kind][id] = Cryo.Dictionary.join(item, v5[kind][id])
					end
				else
					v5[kind][id] = { id = item.id, type = kind, failedToHydrate = true }
				end
			end

			object:dispatch(module2(v5))
		end, function(p4)
			logging.warn("WebApi failure in FetchHydratedWidgetContent: " .. tostring(p4))
			return Promise.reject(p4)
		end)
	end)
end
