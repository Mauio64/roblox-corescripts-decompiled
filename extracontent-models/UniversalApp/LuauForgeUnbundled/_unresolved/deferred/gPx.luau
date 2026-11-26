local module = require("@luauforge/bundled/dPN")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local fFlagAXItemDetailsSduiActions = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsSduiActions
local module2 = require("@luauforge/bundled/fCE")

return function(p2, p3, p4, onOverlayClosed, onOverlayClosedPostClose, p5, p6)
	return function(object): boolean
		local state = object:getState()

		if state.AvatarExperience.AvatarEditor.Character.AvatarType ~= module.AvatarType.R6 then
			return false
		end

		local v5 = false
		local v6 = nil

		local animations = module.BundleTypeIdStrings.Animations
		local v7 = itemData(state.AvatarExperience.Common, p3, p4)
		local v8 = nil
		local v9 = nil

		if v7 and p4 == module.ItemType.Bundle then
			v9 = v7.bundleType
		elseif v7 and p4 == module.ItemType.Asset then
			v8 = v7.assetType
		end

		if fFlagAXItemDetailsSduiActions and p6 ~= nil then
			if p4 == module.ItemType.Bundle and v9 == nil then
				v9 = p6
			elseif p4 == module.ItemType.Asset and v8 == nil then
				v8 = p6
			end
		end

		if v9 and v9 == animations then
			v5 = true
			v6 = "Feature.Avatar.Message.R15AnimationsPrompt"
		elseif v8 and v8 == module.AssetTypeIdStrings.EmoteAnimation then
			v5 = true

			if p2.state.routeName == avatarScreen.ProfilePictureEditorEmotes then
				v6 = "Feature.Avatar.Label.PPEEmoteR15Warning"
			else
				v6 = "Feature.Avatar.Message.R15EmotesPrompt"
			end
		end

		if not v5 then
			return false
		end

		if p5 then
			object:dispatch(module2(p2))
		end

		p2.navigate(avatarScreen.R15UpgradePrompt, {
			onOverlayClosed = onOverlayClosed,
			onOverlayClosedPostClose = onOverlayClosedPostClose,
			bodyTextKey = v6
		})

		return true
	end
end
