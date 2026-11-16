local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local PublishConfigurationContentView = require(script.Parent.PublishConfigurationContentView)
local usePublishConfigurationContentViewModel = require(script.Parent.usePublishConfigurationContentViewModel)

local function PublishConfigurationContentContainer(p)
	local v = usePublishConfigurationContentViewModel(p)
	return React.createElement(PublishConfigurationContentView, v)
end

return PublishConfigurationContentContainer
