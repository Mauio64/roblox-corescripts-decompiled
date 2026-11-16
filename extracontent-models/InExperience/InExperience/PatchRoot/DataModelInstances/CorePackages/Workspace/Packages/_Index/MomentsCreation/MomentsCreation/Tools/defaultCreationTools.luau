local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)

require(MomentsCreation.Types.CreationFlowTypes)

local trimTool = require(MomentsCreation.Tools.trimTool)
local musicTool = require(MomentsCreation.Tools.musicTool)
local textTool = require(MomentsCreation.Tools.textTool)
local generateTextTool = require(MomentsCreation.Tools.generateTextTool)
local stickerTool = require(MomentsCreation.Tools.stickerTool)
local voiceTool = require(MomentsCreation.Tools.voiceTool)

local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)

local DefaultCreationTools = { trimTool, musicTool, textTool, generateTextTool }

if GetFFlagMomentsStickerButton() then
	table.insert(DefaultCreationTools, stickerTool)
end

if GetFFlagMomentsTTSAudioOverlay and game:GetEngineFeature("TextToSpeechPlatformPreview") then
	table.insert(DefaultCreationTools, voiceTool)
end

return DefaultCreationTools
