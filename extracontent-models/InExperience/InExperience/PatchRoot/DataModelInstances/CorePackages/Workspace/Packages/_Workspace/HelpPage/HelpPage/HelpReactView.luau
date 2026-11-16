local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local HelpPageContainer = require(parent.Components.HelpPageContainer)
local KeybindContextProvider = require(parent.Context.KeybindContextProvider)

local function _createPageView()
	return React.createElement(KeybindContextProvider, nil, {
		HelpPageContainer = React.createElement(HelpPageContainer)
	})
end

return _createPageView
