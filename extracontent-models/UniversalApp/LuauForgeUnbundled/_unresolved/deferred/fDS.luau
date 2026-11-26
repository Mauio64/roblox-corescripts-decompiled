local module = require("@luauforge/bundled/fCW")
local module2 = require("@luauforge/bundled/dWC")

local module3 = require("@luauforge/bundled/ecq")
local module4 = require("@luauforge/bundled/dRz")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local constants = AvatarExperienceAnalytics.Constants

return {
	get = function(p2)
		local v5 = module3.get(p2)

		return {
			profilePictureEditorButton = function()
				v5.EventStream:sendEventDeferred(
					"ClickProfilePictureEditorButton",
					"avatarProfilePictureEditTap",
					{ feature = module.AnalyticsTag, entry_point = "dropdown" }
				)
			end,
			profilePictureEditorOpenedFromLandingPage = function()
				v5.EventStream:sendEventDeferred(
					"ProfilePictureEditorLandingPageButtonClicked",
					"avatarProfilePictureEditTap",
					{ feature = module.AnalyticsTag, entry_point = "home" }
				)
			end,
			clickShopForMore = function(p3, p4)
				local v6 = module4()[p3]

				if v6 then
					local v7 = v6.Subcategories and v6.Subcategories[p4]
					local name = v6 and v6.Name or ""
					local name2 = v7 and v7.Name or ""

					v5.EventStream:sendEventDeferred(
						"ProfilePictureEditorEmotesPage",
						"avatarProfilePictureEmoteShop",
						{ feature = module.AnalyticsTag, nav = name, subNav = name2 }
					)
				end
			end,
			clickFinalSave = function(p3, p4, p5)
				local v6 = p3 == module2.Closeup and "clickFinalSaveCloseup" or "clickFinalSaveFullBody"

				v5.EventStream:sendEventDeferred("ProfilePictureEditorFinalPage", v6, {
					feature = module.AnalyticsTag,
					isDefaultPosition = p4,
					emoteAssetId = p5
				})

				reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXUpdateProfilePicture)
			end,
			clickNextFromEmotesPage = function(p3)
				v5.EventStream:sendEventDeferred(
					"ProfilePictureEditorEmotesPage",
					"avatarProfilePictureEmote",
					{ feature = module.AnalyticsTag, asset_id = p3 }
				)
			end,
			clickNextFromCameraPage = function(p3, p4)
				v5.EventStream:sendEventDeferred(
					"ProfilePictureEditorCameraPage",
					"avatarProfilePictureCrop",
					{
						feature = module.AnalyticsTag,
						zoom = p3 and 1 or 0,
						rotate = p4 and 1 or 0
					}
				)
			end,
			clickDefaultPositionsFromCameraPage = function()
				v5.EventStream:sendEventDeferred(
					"ProfilePictureEditorCameraPage",
					"avatarProfilePictureCropDefault",
					{ feature = module.AnalyticsTag }
				)
			end
		}
	end
}
