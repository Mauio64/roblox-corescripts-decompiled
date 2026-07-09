local GuiService = game:GetService("GuiService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Config = require(ExpChat.Config)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)

local function getTopbarInsetTop() -- line: 27
	-- upvalues: GuiService (copy)
	return GuiService.TopbarInset.Height
end
local function computeHeight(n1: number, n2: number, n3: number) -- line: 31
	-- upvalues: Config (copy)
	return (math.clamp(n1 - n2 - n3 - Config.PresetTray.ChatWindowPadding, Config.PresetTray.MinHeight, Config.PresetTray.MaxHeight))
end
local function useAutoTrayHeight() -- line: 36
	-- upvalues: GetPresetChatStore (copy), SignalsReact (copy), React (copy), getTopbarInsetTop (copy), GuiService (copy), Config (copy)
	local v14 = GetPresetChatStore(false)
	local v15 = SignalsReact.useSignalState(v14.getChatWindowBottomY)
	local v16, v17 = React.useState(0)
	local v18, v19 = React.useState(getTopbarInsetTop)

	React.useEffect(function() -- line: 43
		-- upvalues: GuiService (copy), v19 (copy)
		local connection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 44
			-- upvalues: v19 (copy), GuiService (copy)
			v19(GuiService.TopbarInset.Height)
		end)

		return function() -- line: 47
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v20 = React.useCallback(function(p1) -- line: 52
		-- upvalues: v17 (copy)
		v17(p1.AbsoluteSize.Y)
	end, {})

	return math.clamp(v16 - v18 - v15 - Config.PresetTray.ChatWindowPadding, Config.PresetTray.MinHeight, Config.PresetTray.MaxHeight), v20
end

return useAutoTrayHeight
