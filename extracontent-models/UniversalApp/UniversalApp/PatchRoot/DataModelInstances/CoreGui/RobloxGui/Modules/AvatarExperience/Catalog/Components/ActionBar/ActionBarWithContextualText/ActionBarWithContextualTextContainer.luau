local Packages = game:GetService("CorePackages").Packages
local React = require(Packages.React)
local ActionBarWithContextualTextView = require(script.Parent.ActionBarWithContextualTextView)
local useActionBarWithContextualTextViewModel = require(script.Parent.useActionBarWithContextualTextViewModel)

local function ActionBarWithContextualTextContainer(p1) -- line: 10
	-- upvalues: useActionBarWithContextualTextViewModel (copy), React (copy), ActionBarWithContextualTextView (copy)
	local v7 = useActionBarWithContextualTextViewModel(p1)

	return React.createElement(ActionBarWithContextualTextView, v7)
end

return ActionBarWithContextualTextContainer
