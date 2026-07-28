local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreation.Types.CreationFlowTypes)

local trimTool = require(MomentsCreation.Tools.trimTool)
local musicTool = require(MomentsCreation.Tools.musicTool)
local textTool = require(MomentsCreation.Tools.textTool)
local generateTextTool = require(MomentsCreation.Tools.generateTextTool)
local stickerTool = require(MomentsCreation.Tools.stickerTool)
local t1 = {
	trimTool,
	musicTool,
	textTool,
	generateTextTool
}

if MomentsCommon.Flags.GetFFlagMomentsStickerButton() then
	table.insert(t1, stickerTool)
end

return t1
