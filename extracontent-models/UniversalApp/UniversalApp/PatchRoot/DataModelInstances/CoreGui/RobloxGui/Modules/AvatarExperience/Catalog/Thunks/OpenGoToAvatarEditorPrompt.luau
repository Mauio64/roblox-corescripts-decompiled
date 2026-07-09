local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local t1 = {
	toastMessage = "Feature.Avatar.Message.AlreadyAcquired",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p1, p2, p3, p4, p5) -- line: 27
	-- upvalues: ItemData (copy), Constants (copy), AvatarScreen (copy), SetCurrentToastMessage (copy), t1 (copy), NavigateWithLock (copy)
	return function(p6) -- line: 28
		-- upvalues: p3 (copy), ItemData (copy), p4 (copy), p5 (copy), Constants (copy), AvatarScreen (copy), SetCurrentToastMessage (copy), t1 (copy), p2 (copy), p1 (copy), NavigateWithLock (copy)
		local v17 = p6:getState()
		local name = p3.opaque.name
		local assetType = nil
		local v20 = ItemData(v17.AvatarExperience.Common, p4, p5)

		if p5 == Constants.ItemType.Asset then
			assetType = v20.assetType
		elseif p5 == Constants.ItemType.Bundle then
			assetType = v20.bundleType
		end

		if name == AvatarScreen.AvatarEditor then
			return p6:dispatch(SetCurrentToastMessage(t1))
		end

		p6:dispatch(NavigateWithLock(function() -- line: 44
			-- upvalues: p2 (copy), AvatarScreen (copy), p5 (copy), assetType (ref), p1 (copy)
			p2.navigate(AvatarScreen.LeaveCatalogToAvatarPrompt, {
				itemType = p5,
				itemSubType = assetType,
				onOverlayClosed = p1
			})
		end))
	end
end
