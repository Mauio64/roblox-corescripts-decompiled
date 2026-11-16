local module = require("@game/CorePackages/Workspace/Packages/_Index/TopicInfosRodux/TopicInfosRodux/TopicInfoModel")

return {
	AddTopicInfos = require("@game/CorePackages/Workspace/Packages/_Index/TopicInfosRodux/TopicInfosRodux/AddTopicInfos"),
	TopicInfoModel = module,
	TopicInfosReducer = require("@game/CorePackages/Workspace/Packages/_Index/TopicInfosRodux/TopicInfosRodux/TopicInfosReducer")
}
