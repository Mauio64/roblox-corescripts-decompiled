local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactUtils = require(AppChatParent.RoactUtils)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local setAppChatVisible = require(AppChat.App.AppChatVisible).setAppChatVisible
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function() -- line: 13
	-- upvalues: React (copy), ParentContainerContext (copy), useDispatch (copy), setAppChatVisible (copy), EnteredChatFromEntryPoint (copy)
	local v9 = React.useContext(ParentContainerContext)
	local visibilitySignal = v9.visibilitySignal
	local getShouldSetAppChatVisible = v9.getShouldSetAppChatVisible
	local entryPoint = v9.entryPoint
	local v13 = useDispatch()

	React.useEffect(function() -- line: 20
		-- upvalues: visibilitySignal (copy), getShouldSetAppChatVisible (copy), setAppChatVisible (copy), v13 (copy), EnteredChatFromEntryPoint (copy), entryPoint (copy)
		local u14 = visibilitySignal:connect(function(...) -- line: 23
			-- upvalues: getShouldSetAppChatVisible (copy), setAppChatVisible (copy), v13 (copy), EnteredChatFromEntryPoint (copy), entryPoint (copy)
			if getShouldSetAppChatVisible(...) then
				setAppChatVisible(true)
				v13(EnteredChatFromEntryPoint(entryPoint))

				return
			end

			setAppChatVisible(false)
		end)

		return function() -- line: 32
			-- upvalues: u14 (ref)
			if u14 then
				u14:disconnect()
			end
		end
	end, {
		setAppChatVisible,
		v13,
		visibilitySignal,
		getShouldSetAppChatVisible,
		entryPoint
	})
end
