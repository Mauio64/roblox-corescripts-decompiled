local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)

local function ChatLandingPrompts(p)
	local v = useNavigationFocus()
	local v2 = useChatIsVisible()

	if v and v2 then
		return p.renderPrompts()
	end

	return nil
end

return ChatLandingPrompts
