local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useCallback = React.useCallback
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount

local LearnMorePartialModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/LearnMorePartialModalContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/Logger")

local v5 = {}

local function LearnMorePartialModalScreen(p2)
	local navigation = Cryo.Dictionary.union(v5, p2).navigation
	assert(type(navigation) ~= "nil", "LearnMorePartialModalScreen should be wrapped with React Navigation")
	local v6 = navigation and navigation.getParam and navigation.getParam("conversationId", nil)

	useEffectOnMount(function()
		Logger:info("LearnMorePartialModalScreen mounted")
	end)

	local v7 = useCallback(function()
		navigation.goBack()
	end, { navigation })

	return React.createElement(LearnMorePartialModalContainer, { conversationId = v6, onDismissed = v7 })
end

return LearnMorePartialModalScreen
