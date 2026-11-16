local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local LearnMorePartialModalContainer = require(script.Parent.LearnMorePartialModalContainer)
local Logger = require(script.Parent.Logger)

local v = {}

local function LearnMorePartialModalScreen(p)
	local navigation = Cryo.Dictionary.union(v, p).navigation
	assert(type(navigation) ~= "nil", "LearnMorePartialModalScreen should be wrapped with React Navigation")
	local conversationId = navigation and navigation.getParam and navigation.getParam("conversationId", nil)

	useEffectOnMount(function()
		Logger:info("LearnMorePartialModalScreen mounted")
	end)

	local onDismissed = useCallback(function()
		navigation.goBack()
	end, { navigation })

	return React.createElement(LearnMorePartialModalContainer, {
		conversationId = conversationId,
		onDismissed = onDismissed
	})
end

return LearnMorePartialModalScreen
