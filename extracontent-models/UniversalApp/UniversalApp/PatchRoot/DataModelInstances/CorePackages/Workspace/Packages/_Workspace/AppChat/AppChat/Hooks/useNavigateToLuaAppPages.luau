local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local EnumScreens = require(AppChat.EnumScreens)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useMemo = React.useMemo

return function() -- line: 15
	-- upvalues: useDispatch (copy), useMemo (copy), EnumScreens (copy)
	local v8 = useDispatch()

	return useMemo(function() -- line: 18
		-- upvalues: EnumScreens (copy)
		return {
			[EnumScreens.GameDetail] = function() -- line: 20
			end,
			[EnumScreens.Notifications] = function() -- line: 21
			end,
			[EnumScreens.PrivacySettings] = function() -- line: 22
			end,
			[EnumScreens.ReportAbuse] = function() -- line: 23
			end,
			[EnumScreens.ViewUserProfile] = function() -- line: 24
			end,
			[EnumScreens.Groups] = function() -- line: 25
			end,
			[EnumScreens.Home] = function() -- line: 26
			end
		}
	end, { v8 })
end
