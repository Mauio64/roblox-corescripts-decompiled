local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local ContextActionService = game:GetService("ContextActionService")

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(script.Parent.VIPServerJoinView)

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

		ref2.current = data.teleport(data.vipServerAccessCode, function()
			ref.current = false
			setState(false)
			setState2(true)
		end)
	end, { data.teleport, data.vipServerAccessCode })

	local ref3 = React.useRef(data.onClose)
	ref3.current = data.onClose

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
		onClose = data.onClose
	}
end

return useVIPServerJoinViewModel
