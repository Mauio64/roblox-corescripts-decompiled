local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local Constants2 = AvatarExperienceAnalytics.Constants

return {
	get = function(p1) -- line: 19
		-- upvalues: RoactAnalytics (copy), Constants (copy), GetAvatarEditorCategories (copy), PPEThumbnailType (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy)
		local v12 = RoactAnalytics.get(p1)

		return {
			profilePictureEditorButton = function() -- line: 25
				-- upvalues: v12 (copy), Constants (copy)
				v12.EventStream:sendEventDeferred("ClickProfilePictureEditorButton", "avatarProfilePictureEditTap", {
					entry_point = "dropdown",
					feature = Constants.AnalyticsTag
				})
			end,
			profilePictureEditorOpenedFromLandingPage = function() -- line: 34
				-- upvalues: v12 (copy), Constants (copy)
				v12.EventStream:sendEventDeferred("ProfilePictureEditorLandingPageButtonClicked", "avatarProfilePictureEditTap", {
					entry_point = "home",
					feature = Constants.AnalyticsTag
				})
			end,
			clickShopForMore = function(p2, p3) -- line: 42
				-- upvalues: GetAvatarEditorCategories (copy), v12 (copy), Constants (copy)
				local v15 = GetAvatarEditorCategories()[p2]

				if v15 then
					local v16 = v15.Subcategories and v15.Subcategories[p3]
					local v17 = v15 and v15.Name or ""
					local v18 = v16 and v16.Name or ""

					v12.EventStream:sendEventDeferred("ProfilePictureEditorEmotesPage", "avatarProfilePictureEmoteShop", {
						feature = Constants.AnalyticsTag,
						nav = v17,
						subNav = v18
					})
				end
			end,
			clickFinalSave = function(p4, p5, p6) -- line: 58
				-- upvalues: PPEThumbnailType (copy), v12 (copy), Constants (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy)
				local v22 = p4 ~= PPEThumbnailType.Closeup and "clickFinalSaveFullBody" or "clickFinalSaveCloseup"

				v12.EventStream:sendEventDeferred("ProfilePictureEditorFinalPage", v22, {
					feature = Constants.AnalyticsTag,
					isDefaultPosition = p5,
					emoteAssetId = p6
				})
				reportAvatarEventCounterV1(Constants2.AVATAR_EVENT_COUNTER_NAME.AXUpdateProfilePicture)
			end,
			clickNextFromEmotesPage = function(p7) -- line: 73
				-- upvalues: v12 (copy), Constants (copy)
				v12.EventStream:sendEventDeferred("ProfilePictureEditorEmotesPage", "avatarProfilePictureEmote", {
					feature = Constants.AnalyticsTag,
					asset_id = p7
				})
			end,
			clickNextFromCameraPage = function(p8, p9) -- line: 81
				-- upvalues: v12 (copy), Constants (copy)
				v12.EventStream:sendEventDeferred("ProfilePictureEditorCameraPage", "avatarProfilePictureCrop", {
					feature = Constants.AnalyticsTag,
					zoom = not p8 and 0 or 1,
					rotate = not p9 and 0 or 1
				})
			end,
			clickDefaultPositionsFromCameraPage = function() -- line: 90
				-- upvalues: v12 (copy), Constants (copy)
				v12.EventStream:sendEventDeferred("ProfilePictureEditorCameraPage", "avatarProfilePictureCropDefault", {
					feature = Constants.AnalyticsTag
				})
			end
		}
	end
}
