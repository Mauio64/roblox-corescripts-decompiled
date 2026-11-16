local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local BuildChatPageView = require(script.Parent.BuildChatPageView)
local useBuildChatPageViewModel = require(script.Parent.useBuildChatPageViewModel)
local ChatCardEmphasisProvider = require(BuildExperience.Components.Chat.ChatCardEmphasis.ChatCardEmphasisProvider)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)
local FFlagBuildChatIXPExposure = require(BuildExperience.Flags.FFlagBuildChatIXPExposure)
local FStringBuildChatIXPLayer = require(BuildExperience.Flags.FStringBuildChatIXPLayer)

local function BuildChatPage(p)
	local v = useBuildChatPageViewModel(p)

	if FFlagBuildChatIXPExposure then
		React.useEffect(function()
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringBuildChatIXPLayer)
		end, {})
	end

	if FFlagBuildExperienceChatCardEmphasis then
		return React.createElement(ChatCardEmphasisProvider, nil, React.createElement(BuildChatPageView, v))
	end

	return React.createElement(BuildChatPageView, v)
end

return BuildChatPage
