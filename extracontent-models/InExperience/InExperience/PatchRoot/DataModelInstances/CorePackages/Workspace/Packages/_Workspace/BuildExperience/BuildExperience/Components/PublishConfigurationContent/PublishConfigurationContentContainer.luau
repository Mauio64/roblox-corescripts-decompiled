local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local PublishConfigurationContentView = require(script.Parent.PublishConfigurationContentView)
local usePublishConfigurationContentViewModel = require(script.Parent.usePublishConfigurationContentViewModel)

local function PublishConfigurationContentContainer(p1) -- line: 11
	-- upvalues: usePublishConfigurationContentViewModel (copy), React (copy), PublishConfigurationContentView (copy)
	local v7 = usePublishConfigurationContentViewModel(p1)

	return React.createElement(PublishConfigurationContentView, v7)
end

return PublishConfigurationContentContainer
