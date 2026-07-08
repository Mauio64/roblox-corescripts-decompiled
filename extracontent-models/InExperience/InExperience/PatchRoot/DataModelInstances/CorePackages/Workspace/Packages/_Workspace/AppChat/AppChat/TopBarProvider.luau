local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local SignalsReact = require(AppChatParent.SignalsReact)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local TopBarContext = require(AppChat.TopBarContext)

local function TopBarFromStore(p1) -- line: 15
	-- upvalues: GetTopBarStore (copy), SignalsReact (copy), React (copy)
	local screenName = p1.screenName
	local render = p1.render
	local v11 = GetTopBarStore(false)
	local v12 = v11.getScreenTopBar(screenName)
	local v13 = SignalsReact.useSignalState(v12)

	return render((React.useMemo(function() -- line: 23
		-- upvalues: screenName (copy), v13 (copy), v11 (copy)
		return {
			getScreenTopBar = function(s1: string) -- line: 25
				-- upvalues: screenName (copy), v13 (copy), v11 (copy)
				if s1 == screenName then
					return v13
				end

				return v11.getScreenTopBar(s1)(false)
			end,
			setScreenTopBar = v11.setScreenTopBar
		}
	end, {
		screenName,
		v13
	})))
end

if require(AppChat.Flags.FFlagAppChatTopBarSignalsStore) then
	return TopBarFromStore
end

return TopBarContext.Consumer
