local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local GetFFlagAXAnimatedLooksThumbnails = require(Modules.AvatarExperience.Flags.GetFFlagAXAnimatedLooksThumbnails)

return function(p1, p2, p3) -- line: 20
	-- upvalues: PerformFetch (copy), WebApi (copy), GetFFlagAXAnimatedLooksThumbnails (copy), Cryo (copy), SetHydratedWidgetData (copy), Logging (copy), Promise (copy)
	return PerformFetch.Single("hydrateWidgetKey." .. p3, function(p4) -- line: 21
		-- upvalues: WebApi (copy), p1 (copy), p2 (copy), GetFFlagAXAnimatedLooksThumbnails (copy), Cryo (copy), SetHydratedWidgetData (copy), Logging (copy), Promise (copy)
		return WebApi.HydrateWidgetContent(p1, p2):andThen(function(p5) -- line: 22
			-- upvalues: p2 (copy), GetFFlagAXAnimatedLooksThumbnails (copy), Cryo (copy), p4 (copy), SetHydratedWidgetData (copy)
			local v15 = if not p5 then nil else p5.responseBody
			local v16 = if not v15 then nil else v15.hydratedContent

			if v16 == nil then
				return
			end

			assert(v16, "")

			local t1 = {}

			for _, v19 in v16 do
				local type = v19.type
				local str = tostring(v19.id)

				if not t1[type] then
					t1[type] = {}
				end

				t1[type][str] = v19
			end

			for _, v23 in p2 do
				local type = v23.type
				local str = tostring(v23.id)

				if not t1[type] then
					t1[type] = {}
				end

				if not t1[type][str] then
					t1[type][str] = {
						failedToHydrate = true,
						id = v23.id,
						type = type
					}
				elseif GetFFlagAXAnimatedLooksThumbnails() then
					t1[type][str] = Cryo.Dictionary.join(v23, t1[type][str])
				end
			end

			p4:dispatch(SetHydratedWidgetData(t1))
		end, function(p6) -- line: 58
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("WebApi failure in FetchHydratedWidgetContent: " .. tostring(p6))

			return Promise.reject(p6)
		end)
	end)
end
