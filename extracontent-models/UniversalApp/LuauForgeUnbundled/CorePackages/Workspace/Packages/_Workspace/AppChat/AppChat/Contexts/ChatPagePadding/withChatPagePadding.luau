local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local Context = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/Context")

return function(callback)
	assert(type(callback) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(Context.Consumer, { render = callback })
end
