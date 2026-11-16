local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)

local function AppChatRemoveThirdPartyRestriction(): nil
	local v = useDispatch()
	React.useEffect(function()
		if v then
			v(ThirdPartyChatSettingsLoaded(Enum.ChatRestrictionStatus.NotRestricted))
		end
	end, { v })
	return nil
end

return AppChatRemoveThirdPartyRestriction
