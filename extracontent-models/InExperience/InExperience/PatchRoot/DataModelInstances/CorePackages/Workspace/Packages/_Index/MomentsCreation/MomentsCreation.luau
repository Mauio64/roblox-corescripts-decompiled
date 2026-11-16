local Constants = require(script.Constants)
local Enums = require(script.Enums)
local Stores = require(script.Stores)

local CreationFlowScreen = require(script.Components.CreationFlowScreen)

require(script.Enums.CreationFlowState)
local CreationFlowLocalization = require(script.Enums.CreationFlowLocalization)
require(script.Enums.DialogType)
require(script.Enums.DragHandle)
local makePostMetadata = require(script.Utils.makePostMetadata)

return {
	Constants = Constants,
	Enums = Enums,
	CreationFlowLocalization = CreationFlowLocalization,
	Stores = Stores,
	CreationFlowScreen = CreationFlowScreen,
	publishMomentWithUpload = require(script.Upload.publishMomentWithUpload),
	beginCreationFlow = function(p: string)
		local beginCreationFlow = require(script.Analytics.beginCreationFlow)
		beginCreationFlow(p)
	end,
	publishMomentWithTags = function(p, p2, p3: string, p4: string?, p5: number?, flag: boolean?, callback)
		local publishMomentWithTags = require(script.Upload.publishMomentWithTags)
		return publishMomentWithTags(p, p2, p3, p4, p5, flag, callback)
	end,
	registerAnalyticsListener = function(callback)
		local hostAnalyticsListener = require(script.Analytics.hostAnalyticsListener)
		return hostAnalyticsListener.register(callback)
	end,
	resetCreationFlow = function(p)
		local resetCreationFlow = require(script.resetCreationFlow)
		return resetCreationFlow(p)
	end,
	isTextFiltered = require(script.Moderation.isTextFiltered),
	makePostMetadata = makePostMetadata,
	["jest.config"] = script["jest.config"]
}
