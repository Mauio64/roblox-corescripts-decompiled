local module = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores")

local module4 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CreationFlowScreen")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowLocalization")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DialogType")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DragHandle")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makePostMetadata")

local module7 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/publishMomentWithUpload")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Moderation/isTextFiltered")

local function beginCreationFlow(p2)
	require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/beginCreationFlow")(p2)
end

local function publishMomentWithTags(p2, p3, p4, p5, p6, p7, p8)
	return require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/publishMomentWithTags")(p2, p3, p4, p5, p6, p7, p8)
end

local function resetCreationFlow(p2)
	return require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/resetCreationFlow")(p2)
end

local function registerAnalyticsListener(p2)
	return require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/hostAnalyticsListener").register(p2)
end

return {
	Constants = module,
	Enums = module2,
	CreationFlowLocalization = module5,
	Stores = module3,
	CreationFlowScreen = module4,
	publishMomentWithUpload = module7,
	beginCreationFlow = beginCreationFlow,
	publishMomentWithTags = publishMomentWithTags,
	registerAnalyticsListener = registerAnalyticsListener,
	resetCreationFlow = resetCreationFlow,
	isTextFiltered = module8,
	makePostMetadata = module6
}
