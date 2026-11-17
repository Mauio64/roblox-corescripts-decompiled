local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local ContextActionService = game:GetService("ContextActionService")

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(script.Parent.VIPServerJoinView)
require(PurchasePrompt.types)

local v = { event_type = "show", component = "join_private_server_modal" }

local v2 = {
	event_type = "click",
	component = "private_server_config",
	subcomponent = "join_now_btn"
}

local v3 = {
	event_type = "click",
	component = "private_server_config",
	subcomponent = "not_now_btn"
}

local function useVIPServerJoinViewModel(data)
	local locales = useLocalization({
		title = "Feature.PrivateServers.Label.YourPrivateServerIsReadyToJoin",
		join = "Common.VisitGame.Label.Play",
		somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
	})

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		data.logEvent(v)
	end, {})

	React.useEffect(function()
		return function()
			if ref2.current then
				ref2.current()
			end
		end
	end, {})

	local onJoin = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		setState(true)
		setState2(false)
		data.logEvent(v2)

		ref2.current = data.teleport(data.vipServerAccessCode, function()
			ref.current = false
			setState(false)
			setState2(true)
		end)
	end, { data.teleport, data.vipServerAccessCode, data.logEvent })

	local v4 = React.useCallback(function()
		data.logEvent(v3)
		data.onClose()
	end, { data.onClose, data.logEvent })

	local ref3 = React.useRef(v4)
	ref3.current = v4

	React.useEffect(function()
		ContextActionService:BindCoreAction("VIPServerJoinCloseButtonBind", function(_, p)
			if p == Enum.UserInputState.Begin then
				ref3.current()
			end
		end, false, Enum.KeyCode.ButtonB)
		return function()
			ContextActionService:UnbindCoreAction("VIPServerJoinCloseButtonBind")
		end
	end, {})

	return {
		locales = locales,
		serverName = data.serverName,
		gameName = data.gameName,
		thumbnailUrl = data.thumbnailUrl,
		hasError = state2,
		isJoining = state,
		onJoin = onJoin,
		onClose = v4,
		focusRootRef = data.focusRootRef,
		joinButtonRef = data.joinButtonRef
	}
end

return useVIPServerJoinViewModel
