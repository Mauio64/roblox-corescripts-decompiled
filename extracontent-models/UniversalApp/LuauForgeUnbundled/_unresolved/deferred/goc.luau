local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/dNQ")
local module3 = require("@luauforge/bundled/fwg")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local module4 = require("@luauforge/bundled/dCh")
local module5 = require("@luauforge/bundled/dwB")

return function(p2)
	return performFetch.Single("CreateLook", function(object)
		local look = object:getState().AvatarExperience.AvatarScene.Looks[module.DraftLookId]

		if not look then
			return Promise.reject("Draft look doesn't exist")
		end

		local v5 = {}

		for k, lookAssetInfo in look.lookAssetInfos do
			table.insert(v5, { id = k, meta = lookAssetInfo.meta })
		end

		for k, lookBundleInfo in look.lookBundleInfos do
			for k2, v6 in lookBundleInfo.assetsInBundle do
				if v6.isIncluded then
					table.insert(v5, { id = v6.id, bundleId = k, meta = v6.meta })
				end
			end
		end

		return module3.CreateLook(p2, v5, look):andThen(function(p3)
			if p3 and p3.responseBody then
				return p3.responseBody.id
			end

			return nil
		end):catch(function(p3)
			warn("Failed to create look", p3)
			local success, result = pcall(function()
				local v6 = p3.Body

				if v6 then
					v6 = not (p3.Body == "") and HttpService:JSONDecode(p3.Body)
				end

				return v6
			end)

			if success and result and result.errorDescription then
				object:dispatch(module4({
					toastMessage = result.errorDescription,
					isLocalized = true,
					toastType = module5.InformationMessage
				}))

				sendAXCounterV2(module.Counter.LookComposer.CreateLook, {
					errorCode = result.errorCode
				})
			elseif success and result and result.errorCode then
				sendAXCounterV2(module.Counter.LookComposer.CreateLook, {
					errorCode = result.errorCode
				})

				object:dispatch(module4({
					toastMessage = module2.AvatarShareErrorMessagesKeys[result.errorCode] or "Feature.Avatar.Generic.Error",
					isLocalized = false,
					toastType = module5.InformationMessage
				}))
			else
				sendAXCounterV2(module.Counter.LookComposer.CreateLook, {
					errorCode = "none"
				})
			end
		end)
	end)
end
