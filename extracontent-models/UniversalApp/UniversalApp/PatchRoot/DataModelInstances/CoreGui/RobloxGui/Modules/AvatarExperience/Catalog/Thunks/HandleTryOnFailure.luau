local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local RemoveFromTryOn = AvatarExperienceRodux.Actions.RemoveFromTryOn
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local t1 = {
	toastMessage = "Feature.Avatar.Label.TryOnFail",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p1) -- line: 25
	-- upvalues: ArgCheck (copy), getTryOnItemReducerKey (copy), Constants (copy), RemoveFromTryOn (copy), SetCurrentToastMessage (copy), t1 (copy)
	ArgCheck.isType(p1, "string", "HandleTryOnFailure request expects bundleId")

	return function(p2) -- line: 27
		-- upvalues: getTryOnItemReducerKey (copy), p1 (copy), Constants (copy), RemoveFromTryOn (copy), SetCurrentToastMessage (copy), t1 (copy)
		local v14 = p2:getState()
		local v15 = getTryOnItemReducerKey(p1, Constants.ItemType.Bundle)

		if v14.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[v15] then
			p2:dispatch(RemoveFromTryOn(p1))
			p2:dispatch(SetCurrentToastMessage(t1))
		end
	end
end
