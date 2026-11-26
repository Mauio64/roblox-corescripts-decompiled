local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local Context = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/Context")

local function ChatPagePaddingProvider(p2)
	return React.createElement(Context.Provider, {
		value = Cryo.Dictionary.join({ top = 0, right = 12, bottom = 0, left = 12 }, p2.value)
	}, p2.children)
end

return ChatPagePaddingProvider
