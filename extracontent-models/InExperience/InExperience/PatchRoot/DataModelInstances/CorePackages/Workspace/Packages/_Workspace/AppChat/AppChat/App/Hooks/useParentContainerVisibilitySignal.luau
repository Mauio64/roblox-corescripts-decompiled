local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)

local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local AppChatVisible = require(AppChat.App.AppChatVisible)
local setAppChatVisible = AppChatVisible.setAppChatVisible
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function()
	local v = React.useContext(ParentContainerContext)
	local visibilitySignal = v.visibilitySignal
	local getShouldSetAppChatVisible = v.getShouldSetAppChatVisible
	local entryPoint = v.entryPoint
	local v2 = useDispatch()

	React.useEffect(function()
		local connection = visibilitySignal:connect(function(p, p2)
			if not getShouldSetAppChatVisible(p) then
				setAppChatVisible(false)

				return
			end

			setAppChatVisible(true)

			v2(EnteredChatFromEntryPoint(p2 or entryPoint))
		end)

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, { setAppChatVisible, v2, visibilitySignal, getShouldSetAppChatVisible, entryPoint })
end
