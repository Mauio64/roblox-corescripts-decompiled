require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigationFocus
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")

local function ChatLandingPrompts(p2)
	local v5 = useNavigationFocus()
	local v6 = useChatIsVisible()

	if v5 and v6 then
		return p2.renderPrompts()
	end

	return nil
end

return ChatLandingPrompts
