local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Config = require(ExpChat.Config)
local parentModule = require(script.Parent)

local function useIsChatBackgroundVisible()
	local v = parentModule(false)

	local getIsFocused = v.getIsFocused or v.getIsTextBoxFocused
	local v2 = SignalsReact.useSignalState(getIsFocused)
	local v3 = SignalsReact.useSignalState(v.getLastActivity)

	local state, setState = React.useState(true)
	React.useEffect(function()
		if v2 then
			setState(true)
			return nil
		end

		local v4 = Config.ChatWindowBackgroundFadeOutTime - (os.clock() - v3)

		if v4 <= 0 then
			setState(false)
			return nil
		end

		setState(true)
		local thread = task.delay(v4, function()
			setState(false)
		end)
		return function()
			pcall(task.cancel, thread)
		end
	end, { v3, v2 })

	return state
end

return useIsChatBackgroundVisible
