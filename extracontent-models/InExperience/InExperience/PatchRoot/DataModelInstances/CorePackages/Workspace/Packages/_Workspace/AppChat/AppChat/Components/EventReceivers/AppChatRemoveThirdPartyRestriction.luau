local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)

local function AppChatRemoveThirdPartyRestriction() -- line: 7
	-- upvalues: useDispatch (copy), React (copy), ThirdPartyChatSettingsLoaded (copy)
	local v7 = useDispatch()

	React.useEffect(function() -- line: 9
		-- upvalues: v7 (copy), ThirdPartyChatSettingsLoaded (copy)
		if v7 then
			v7(ThirdPartyChatSettingsLoaded(Enum.ChatRestrictionStatus.NotRestricted))
		end
	end, { v7 })

	return nil
end

return AppChatRemoveThirdPartyRestriction
