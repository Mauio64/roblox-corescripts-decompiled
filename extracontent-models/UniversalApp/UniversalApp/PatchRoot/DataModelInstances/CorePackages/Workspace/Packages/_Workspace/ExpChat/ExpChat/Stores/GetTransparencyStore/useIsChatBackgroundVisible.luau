local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Config = require(ExpChat.Config)
local Parent = require(script.Parent)

local function useIsChatBackgroundVisible() -- line: 12
	-- upvalues: Parent (copy), SignalsReact (copy), React (copy), Config (copy)
	local v8 = Parent(false)
	local v9 = v8.getIsFocused or v8.getIsTextBoxFocused
	local v10 = SignalsReact.useSignalState(v9)
	local v11 = SignalsReact.useSignalState(v8.getLastActivity)
	local v12, v13 = React.useState(true)

	React.useEffect(function() -- line: 20
		-- upvalues: v10 (copy), v13 (copy), Config (copy), v11 (copy)
		if v10 then
			v13(true)

			return nil
		end

		local v14 = Config.ChatWindowBackgroundFadeOutTime - (os.clock() - v11)

		if v14 <= 0 then
			v13(false)

			return nil
		end

		v13(true)

		local thread = task.delay(v14, function() -- line: 32
			-- upvalues: v13 (copy)
			v13(false)
		end)

		return function() -- line: 35
			-- upvalues: thread (copy)
			pcall(task.cancel, thread)
		end
	end, {
		v11,
		v10
	})

	return v12
end

return useIsChatBackgroundVisible
