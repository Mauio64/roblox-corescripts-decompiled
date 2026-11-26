local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local trimTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/trimTool")
local musicTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/musicTool")
local textTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/textTool")
local generateTextTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/generateTextTool")
local stickerTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/stickerTool")
local voiceTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/voiceTool")

local getFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")

local modules = { trimTool, musicTool, textTool, generateTextTool }

if getFFlagMomentsStickerButton() then
	table.insert(modules, stickerTool)
end

if GetFFlagMomentsTTSAudioOverlay and game:GetEngineFeature("TextToSpeechPlatformPreview") then
	table.insert(modules, voiceTool)
end

return modules
