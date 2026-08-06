local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local setAppChatVisible = require(AppChat.App.AppChatVisible).setAppChatVisible
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function() -- line: 16
	-- upvalues: React (copy), ParentContainerContext (copy), useDispatch (copy), setAppChatVisible (copy), FFlagExpChatEnableFriendsTab (copy), EnteredChatFromEntryPoint (copy)
	local v10 = React.useContext(ParentContainerContext)
	local visibilitySignal = v10.visibilitySignal
	local getShouldSetAppChatVisible = v10.getShouldSetAppChatVisible
	local entryPoint = v10.entryPoint
	local v14 = useDispatch()

	React.useEffect(function() -- line: 23
		-- upvalues: visibilitySignal (copy), getShouldSetAppChatVisible (copy), setAppChatVisible (copy), FFlagExpChatEnableFriendsTab (copy), entryPoint (copy), v14 (copy), EnteredChatFromEntryPoint (copy)
		local u15 = visibilitySignal:connect(function(p1, p2) -- line: 26
			-- upvalues: getShouldSetAppChatVisible (copy), setAppChatVisible (copy), FFlagExpChatEnableFriendsTab (copy), entryPoint (copy), v14 (copy), EnteredChatFromEntryPoint (copy)
			if getShouldSetAppChatVisible(p1) then
				setAppChatVisible(true)

				local v18 = if not FFlagExpChatEnableFriendsTab then entryPoint else p2 or entryPoint

				v14(EnteredChatFromEntryPoint(v18))

				return
			end

			setAppChatVisible(false)
		end)

		return function() -- line: 38
			-- upvalues: u15 (ref)
			if u15 then
				u15:disconnect()
			end
		end
	end, {
		setAppChatVisible,
		v14,
		visibilitySignal,
		getShouldSetAppChatVisible,
		entryPoint
	})
end
