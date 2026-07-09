local TopicInfoModel = require(script.TopicInfoModel)

return {
	AddTopicInfos = require(script.AddTopicInfos),
	TopicInfoModel = TopicInfoModel,
	TopicInfosReducer = require(script.TopicInfosReducer),
	["jest.config"] = script["jest.config"]
}
