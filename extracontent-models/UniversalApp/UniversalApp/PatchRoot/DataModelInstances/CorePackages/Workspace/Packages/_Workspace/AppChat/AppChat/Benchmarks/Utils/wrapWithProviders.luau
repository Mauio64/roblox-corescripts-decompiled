local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local MockProviders = require(AppChat.Components.MockProviders)

return function(p1, t1: {[any]: any}?) -- line: 13
	-- upvalues: React (copy), MockProviders (copy)
	local v7 = t1 or {}

	return React.createElement(MockProviders, {
		withLayerCollector = v7.withLayerCollector == nil or v7.withLayerCollector,
		withUiModeSupport = v7.withUiModeSupport,
		themeName = v7.themeName,
		rodux = v7.rodux
	}, p1)
end
