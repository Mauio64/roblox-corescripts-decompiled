local GroupPeekSduiConstants = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/GroupPeekSduiConstants")

return {
	fetchGroupPeekPage = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/fetchGroupPeekPage"),
	registerGroupAnnouncementActions = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/registerGroupAnnouncementActions"),
	AppPage = GroupPeekSduiConstants.AppPage,
	Identifiers = GroupPeekSduiConstants.Identifiers,
	getConfigKey = GroupPeekSduiConstants.getConfigKey
}
