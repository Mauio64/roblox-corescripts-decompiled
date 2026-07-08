local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local HelpPageContainer = require(scriptParent.Components.HelpPageContainer)
local KeybindContextProvider = require(scriptParent.Context.KeybindContextProvider)

local function _createPageView() -- line: 10
	-- upvalues: React (copy), KeybindContextProvider (copy), HelpPageContainer (copy)
	return React.createElement(KeybindContextProvider, nil, {
		HelpPageContainer = React.createElement(HelpPageContainer)
	})
end

return _createPageView
