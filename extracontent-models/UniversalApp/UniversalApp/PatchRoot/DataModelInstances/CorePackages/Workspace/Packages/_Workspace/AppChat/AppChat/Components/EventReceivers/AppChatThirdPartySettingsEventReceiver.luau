local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Responsive = require(AppChatParent.Responsive)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useProperty = require(AppChatParent.GuiObjectUtils).useProperty
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)
local FFlagAppChatIgnoreUnknownThirdPartyChatStatus = require(AppChat.Flags.FFlagAppChatIgnoreUnknownThirdPartyChatStatus)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatThirdPartySettingsEventReceiver() -- line: 12
	-- upvalues: useDispatch (copy), useProperty (copy), ThirdPartyUserService (copy), FFlagAppChatIgnoreUnknownThirdPartyChatStatus (copy), Responsive (copy), React (copy), ThirdPartyChatSettingsLoaded (copy)
	local v11 = useDispatch()
	local v12 = useProperty(ThirdPartyUserService, "FriendCommunicationRestrictionStatus")
	local v13 = if not FFlagAppChatIgnoreUnknownThirdPartyChatStatus then nil else Responsive.usePreferredInput()

	React.useEffect(function() -- line: 16
		-- upvalues: v11 (copy), v12 (copy), FFlagAppChatIgnoreUnknownThirdPartyChatStatus (copy), v13 (copy), Responsive (copy), ThirdPartyChatSettingsLoaded (copy)
		if v11 and v12 then
			local v14 = v12

			if FFlagAppChatIgnoreUnknownThirdPartyChatStatus and v13 ~= Responsive.Input.Directional and v12 == Enum.ChatRestrictionStatus.Unknown then
				v14 = Enum.ChatRestrictionStatus.NotRestricted
			end

			v11(ThirdPartyChatSettingsLoaded(v14))
		end
	end, {
		v11,
		v12,
		v13
	})

	return nil
end

return AppChatThirdPartySettingsEventReceiver
