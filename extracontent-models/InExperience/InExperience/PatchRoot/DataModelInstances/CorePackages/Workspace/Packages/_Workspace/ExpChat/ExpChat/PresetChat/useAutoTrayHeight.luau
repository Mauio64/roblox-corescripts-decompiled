local GuiService = game:GetService("GuiService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Config = require(ExpChat.Config)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)

local function getTopbarInsetTop() -- 1 equivalent call inferred from this helper
	return GuiService.TopbarInset.Height
end

local function computeHeight(state: number, state2: number, p: number) -- 1 equivalent call inferred from this helper
	return (math.clamp(
		state - state2 - p - Config.PresetTray.ChatWindowPadding,
		Config.PresetTray.MinHeight,
		Config.PresetTray.MaxHeight
	))
end

local function useAutoTrayHeight()
	local presetChatStore = GetPresetChatStore(false)
	local v = SignalsReact.useSignalState(presetChatStore.getChatWindowBottomY)

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(getTopbarInsetTop)

	React.useEffect(function()
		local topbarInsetChangedConnection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
			setState2(getTopbarInsetTop()) -- inferred equivalent call
		end)
		return function()
			topbarInsetChangedConnection:Disconnect()
		end
	end, {})

	local v2 = React.useCallback(function(p)
		setState(p.AbsoluteSize.Y)
	end, {})

	return computeHeight(state, state2, v), v2 -- inferred equivalent call
end

return useAutoTrayHeight
