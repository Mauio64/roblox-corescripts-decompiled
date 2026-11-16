local GroupPeekSduiConstants = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/GroupPeekSduiConstants")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/SharedFlags")

local function registerGroupAnnouncementActions()
	if SharedFlags.FFlagSduiCustomFormEnabled then
		require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/CustomForms").getSduiCustomFormVerticalRegistry().registerVertical(
			GroupPeekSduiConstants.CUSTOM_FORM_VERTICAL,
			{ submit = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/submitGroupCustomFormResponse"), fetchResults = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/fetchGroupCustomFormResults") }
		)
	end

	if SharedFlags.FFlagSduiReactionsComponent then
		require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/SduiSharedContent").getSduiContentReactionVerticalRegistry().registerVertical(
			GroupPeekSduiConstants.CONTENT_REACTION_VERTICAL,
			{ toggle = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/Reactions/toggleAnnouncementReaction") }
		)
	end
end

return registerGroupAnnouncementActions
