local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/IxpServiceWrapper").IXPServiceWrapper

local BuildChatPageView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/BuildChatPageView")
local useBuildChatPageViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/useBuildChatPageViewModel")
local ChatCardEmphasisProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisProvider")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")
local FFlagBuildChatIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildChatIXPExposure")
local FStringBuildChatIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FStringBuildChatIXPLayer")

local function BuildChatPage(p2)
	local v5 = useBuildChatPageViewModel(p2)

	if FFlagBuildChatIXPExposure then
		React.useEffect(function()
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringBuildChatIXPLayer)
		end, {})
	end

	if FFlagBuildExperienceChatCardEmphasis then
		return React.createElement(ChatCardEmphasisProvider, nil, React.createElement(BuildChatPageView, v5))
	end

	return React.createElement(BuildChatPageView, v5)
end

return BuildChatPage
