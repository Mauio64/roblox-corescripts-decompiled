local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Promise = require(CorePackages.Packages.Promise)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

return function(p1) -- line: 20
	-- upvalues: PerformFetch (copy), Constants (copy), Promise (copy), WebApi (copy), HttpService (copy), SetCurrentToastMessage (copy), ToastType (copy), sendAXCounterV2 (copy), Constants2 (copy)
	return PerformFetch.Single("CreateLook", function(p2) -- line: 21
		-- upvalues: Constants (copy), Promise (copy), WebApi (copy), p1 (copy), HttpService (copy), SetCurrentToastMessage (copy), ToastType (copy), sendAXCounterV2 (copy), Constants2 (copy)
		local v14 = p2:getState().AvatarExperience.AvatarScene.Looks[Constants.DraftLookId]

		if not v14 then
			return Promise.reject("Draft look doesn't exist")
		end

		local t1 = {}

		for v16, v17 in v14.lookAssetInfos do
			table.insert(t1, {
				id = v16,
				meta = v17.meta
			})
		end

		for v18, v19 in v14.lookBundleInfos do
			for _, v21 in v19.assetsInBundle do
				if v21.isIncluded then
					table.insert(t1, {
						id = v21.id,
						bundleId = v18,
						meta = v21.meta
					})
				end
			end
		end

		return WebApi.CreateLook(p1, t1, v14):andThen(function(p3) -- line: 50
			if p3 and p3.responseBody then
				return p3.responseBody.id
			end

			return nil
		end):catch(function(p4) -- line: 54
			-- upvalues: HttpService (copy), p2 (copy), SetCurrentToastMessage (copy), ToastType (copy), sendAXCounterV2 (copy), Constants (copy), Constants2 (copy)
			warn("Failed to create look", p4)

			local ok, result = pcall(function() -- line: 56
				-- upvalues: p4 (copy), HttpService (copy)
				return p4.Body and (p4.Body ~= "" and HttpService:JSONDecode(p4.Body))
			end)

			if ok and (result and result.errorDescription) then
				p2:dispatch(SetCurrentToastMessage({
					isLocalized = true,
					toastMessage = result.errorDescription,
					toastType = ToastType.InformationMessage
				}))
				sendAXCounterV2(Constants.Counter.LookComposer.CreateLook, {
					errorCode = result.errorCode
				})

				return
			end

			if ok and result and result.errorCode then
				sendAXCounterV2(Constants.Counter.LookComposer.CreateLook, {
					errorCode = result.errorCode
				})
				p2:dispatch(SetCurrentToastMessage({
					isLocalized = false,
					toastMessage = Constants2.AvatarShareErrorMessagesKeys[result.errorCode] or "Feature.Avatar.Generic.Error",
					toastType = ToastType.InformationMessage
				}))

				return
			end

			sendAXCounterV2(Constants.Counter.LookComposer.CreateLook, {
				errorCode = "none"
			})
		end)
	end)
end
