local ContextActionService = game:GetService("ContextActionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerJoinView")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local v5 = { event_type = "show", component = "join_private_server_modal" }

local v6 = {
	event_type = "click",
	component = "private_server_config",
	subcomponent = "join_now_btn"
}

local v7 = {
	event_type = "click",
	component = "private_server_config",
	subcomponent = "not_now_btn"
}

local function useVIPServerJoinViewModel(data)
	local v8 = useLocalization({
		title = "Feature.PrivateServers.Label.YourPrivateServerIsReadyToJoin",
		join = "Common.VisitGame.Label.Play",
		somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
	})

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		data.logEvent(v5)
	end, {})

	React.useEffect(function()
		return function()
			if ref2.current then
				ref2.current()
			end
		end
	end, {})

	local v9 = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		setState(true)
		setState2(false)
		data.logEvent(v6)

		ref2.current = data.teleport(data.vipServerAccessCode, function()
			ref.current = false
			setState(false)
			setState2(true)
		end)
	end, { data.teleport, data.vipServerAccessCode, data.logEvent })

	local v10 = React.useCallback(function()
		data.logEvent(v7)
		data.onClose()
	end, { data.onClose, data.logEvent })

	local ref3 = React.useRef(v10)
	ref3.current = v10

	React.useEffect(function()
		ContextActionService:BindCoreAction("VIPServerJoinCloseButtonBind", function(p2, p3)
			if p3 == Enum.UserInputState.Begin then
				ref3.current()
			end
		end, false, Enum.KeyCode.ButtonB)
		return function()
			ContextActionService:UnbindCoreAction("VIPServerJoinCloseButtonBind")
		end
	end, {})

	return {
		locales = v8,
		serverName = data.serverName,
		gameName = data.gameName,
		thumbnailUrl = data.thumbnailUrl,
		hasError = state2,
		isJoining = state,
		onJoin = v9,
		onClose = v10,
		focusRootRef = data.focusRootRef,
		joinButtonRef = data.joinButtonRef
	}
end

return useVIPServerJoinViewModel
