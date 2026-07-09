local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local CloseAllItemDetails = require(Modules.AvatarExperience.Common.Thunks.CloseAllItemDetails)

return function(p1, p2, p3, p4, p5, p6) -- line: 19
	-- upvalues: Constants (copy), ItemData (copy), AvatarScreen (copy), CloseAllItemDetails (copy)
	return function(p7) -- line: 20
		-- upvalues: Constants (copy), ItemData (copy), p2 (copy), p3 (copy), p1 (copy), AvatarScreen (copy), p6 (copy), CloseAllItemDetails (copy), p4 (copy), p5 (copy)
		local v15 = p7:getState()

		if v15.AvatarExperience.AvatarEditor.Character.AvatarType ~= Constants.AvatarType.R6 then
			return false
		end

		local v16 = false
		local s1 = nil
		local Animations = Constants.BundleTypeIdStrings.Animations
		local v19 = ItemData(v15.AvatarExperience.Common, p2, p3)
		local assetType = nil
		local bundleType = nil

		if v19 and p3 == Constants.ItemType.Bundle then
			bundleType = v19.bundleType
		elseif v19 and p3 == Constants.ItemType.Asset then
			assetType = v19.assetType
		end

		if bundleType and bundleType == Animations then
			v16 = true
			s1 = "Feature.Avatar.Message.R15AnimationsPrompt"
		elseif assetType and assetType == Constants.AssetTypeIdStrings.EmoteAnimation then
			v16 = true
			s1 = p1.state.routeName ~= AvatarScreen.ProfilePictureEditorEmotes and "Feature.Avatar.Message.R15EmotesPrompt" or "Feature.Avatar.Label.PPEEmoteR15Warning"
		end

		if v16 then
			if p6 then
				p7:dispatch(CloseAllItemDetails(p1))
			end

			p1.navigate(AvatarScreen.R15UpgradePrompt, {
				onOverlayClosed = p4,
				onOverlayClosedPostClose = p5,
				bodyTextKey = s1
			})

			return true
		end

		return false
	end
end
