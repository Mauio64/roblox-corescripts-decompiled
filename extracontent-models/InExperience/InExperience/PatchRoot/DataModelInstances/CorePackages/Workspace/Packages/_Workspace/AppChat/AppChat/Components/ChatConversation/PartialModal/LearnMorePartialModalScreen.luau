local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local useCallback = React.useCallback
local useEffectOnMount = require(Parent.RoactUtils).Hooks.useEffectOnMount
local LearnMorePartialModalContainer = require(script.Parent.LearnMorePartialModalContainer)
local Logger = require(script.Parent.Logger)
local t1 = {}

local function LearnMorePartialModalScreen(t2: {[any]: any}) -- line: 18
	-- upvalues: Cryo (copy), t1 (copy), useEffectOnMount (copy), Logger (copy), useCallback (copy), React (copy), LearnMorePartialModalContainer (copy)
	local navigation = Cryo.Dictionary.union(t1, t2).navigation

	assert(type(navigation) ~= "nil", "LearnMorePartialModalScreen should be wrapped with React Navigation")

	local v12 = navigation and (navigation.getParam and navigation.getParam("conversationId", nil))

	useEffectOnMount(function() -- line: 24
		-- upvalues: Logger (copy)
		Logger:info("LearnMorePartialModalScreen mounted")
	end)

	local v13 = useCallback(function() -- line: 28
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })

	return React.createElement(LearnMorePartialModalContainer, {
		conversationId = v12,
		onDismissed = v13
	})
end

return LearnMorePartialModalScreen
