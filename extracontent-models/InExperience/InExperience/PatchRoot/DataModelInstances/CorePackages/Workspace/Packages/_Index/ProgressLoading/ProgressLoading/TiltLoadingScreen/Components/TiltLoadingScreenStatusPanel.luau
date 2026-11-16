local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local parent = TiltLoadingScreen.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local Constants = require(TiltLoadingScreen.Constants)
require(TiltLoadingScreen.Types)
local Footer = require(parent.Components.Footer)

local Button = Foundation.Button
local Progress = Foundation.Progress
local Text = Foundation.Text
local View = Foundation.View
local Enums = Foundation.Enums

local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent2.SharedFlags)
local FIntAutoJoinNewServerTimeMs = SharedFlags.FIntAutoJoinNewServerTimeMs
local PioneerUtils = require(parent2.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local function localizeUiMessage(p: string)
	local coreScriptLocalization = CoreGui:FindFirstChild("CoreScriptLocalization")

	if not coreScriptLocalization then
		return p
	end

	local success, result = pcall(function()
		return coreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId):Translate(CoreGui, p)
	end)
	return if success then result else p
end

local function TiltLoadingScreenStatusPanel(props)
	local v = useLocalization({
		antiAddictionText = "Authentication.Login.WeChat.AntiAddictionText",
		dontWantToWait = "InGame.ConnectionError.Description.DontWantToWait",
		friendsServerIsFullJoiningNewServer = "InGame.ConnectionError.Description.FriendsServerIsFullJoiningNewServer",
		friendsServerIsFullWaitingToJoin = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		joinNewServer = "InGame.ConnectionError.Action.JoinNewServer",
		joinTheLine = "InGame.ConnectionError.Action.JoinTheLine",
		statusGameEnded = "InGame.ConnectionError.PlacelaunchGameEnded",
		statusHttpError = "InGame.ConnectionError.PlacelaunchHttpError",
		statusJoining = "InGame.ConnectionError.Joining",
		statusQueued = {
			"InGame.ConnectionError.Queue",
			POSITION = tostring(props.queuePosition or "")
		},
		wantToJoinYourFriend = "InGame.ConnectionError.Description.WantToJoinYourFriend"
	})

	local ref = React.useRef(-1e999)
	local v2, v3 = React.useBinding(0)
	local state, setState = React.useState(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v4 = React.useCallback(function()
		setState(false)

		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end
	end, {})

	local v5 = React.useCallback(function()
		if ref2.current then
			return
		end

		setState(true)
		local lastTime = os.clock()
		local v5 = FIntAutoJoinNewServerTimeMs / 1000

		ref2.current = RunService.Heartbeat:Connect(function()
			local v6 = math.clamp((os.clock() - lastTime) / v5 * 100, 0, 100)
			v3(v6)

			if v6 >= 100 then
				v4()
				props.onAutoJoinNewServer()
			end
		end)
	end, { props.onAutoJoinNewServer, v4 })

	React.useEffect(function()
		if props.status == Constants.QUEUED_STATE then
			ref3.current = os.clock()
		end
	end, { props.status })

	React.useEffect(function()
		if
			props.status == Constants.QUEUED_STATE
			and props.queueTreatment == Constants.AUTO_JOIN_TREATMENT
			and props.followUserId > 0
		then
			v5()
		else
			v4()
		end

		return v4
	end, { props.status, props.queueTreatment, props.followUserId, v5, v4 })

	local onActivated = React.useCallback(function()
		if props.isSubjectToChinaPolicies then
			return
		end

		local now = os.clock()

		if now - ref.current <= Constants.DOUBLE_TAP_WINDOW_SECONDS then
			props.onShowConnectionHealth()
			ref.current = -1e999
		else
			ref.current = now
		end
	end, { props.isSubjectToChinaPolicies, props.onShowConnectionHealth })

	local onActivated2 = React.useCallback(function()
		v4()
		local onJoinTheLine = props.onJoinTheLine
		local v6

		if ref3.current then
			v6 = math.floor((os.clock() - ref3.current) * 1000)
		end

		onJoinTheLine(v6)
	end, { props.onJoinTheLine, v4 })

	local onActivated3 = React.useCallback(function()
		local onJoinNewServer = props.onJoinNewServer
		local v6

		if ref3.current then
			v6 = math.floor((os.clock() - ref3.current) * 1000)
		end

		onJoinNewServer(v6)
	end, { props.onJoinNewServer })
	local v6

	if props.status == Constants.QUEUED_STATE then
		v6 = props.queueTreatment == Constants.JOIN_NEW_SERVER_TREATMENT
	else
		v6 = false
	end

	local v7

	if props.status == Constants.QUEUED_STATE and props.queueTreatment == Constants.AUTO_JOIN_TREATMENT then
		v7 = props.followUserId > 0 and state
	else
		v7 = false
	end

	local text

	if props.status == Constants.QUEUED_STATE and props.followUserId > 0 and props.queueTreatment ~= nil then
		if state then
			text = v.friendsServerIsFullJoiningNewServer
		else
			text = v.friendsServerIsFullWaitingToJoin
		end
	end

	local result = ({
		Joining = v.statusJoining,
		GameEnded = v.statusGameEnded,
		HttpError = v.statusHttpError
	})[props.status]

	if props.status == Constants.QUEUED_STATE and props.queuePosition ~= nil then
		result = v.statusQueued
	elseif not result then
		local statusText = props.statusText
		local coreScriptLocalization = CoreGui:FindFirstChild("CoreScriptLocalization")

		if coreScriptLocalization then
			local success
			success, result = pcall(function()
				return coreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId):Translate(
					CoreGui,
					statusText
				)
			end)

			if not success then
				result = statusText
			end
		else
			result = statusText
		end
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center align-y-bottom gap-large size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
		testId = "tilt-loading-screen-status-panel"
	}

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		tag = {
			["col align-x-center gap-small size-full-0 auto-y"] = true,
			["padding-bottom-small"] = isPioneerLaunch()
		},
		onActivated = onActivated,
		stateLayer = { affordance = Enums.StateLayerAffordance.None },
		testId = "tilt-loading-screen-status"
	}
	local policy

	if props.isSubjectToChinaPolicies then
		policy = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v.antiAddictionText,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-system-contrast"
		})
	end

	local queueDescription

	if text then
		queueDescription = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "auto-xy text-title-medium content-system-contrast",
			testId = "tilt-loading-screen-queue-description"
		})
	end

	local statusText

	if result ~= "" then
		statusText = React.createElement(Text, {
			LayoutOrder = 3,
			Text = result,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-system-contrast"
		})
	end

	local v10 = {
		Status = createElement2(View, v9, {
			Policy = policy,
			QueueDescription = queueDescription,
			StatusText = statusText
		}),
		Countdown = 0,
		JoinNewServerAction = 0,
		JoinTheLineAction = 0,
		RobloxWordmark = 0
	}
	local countdown

	if state then
		countdown = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center size-full-0 auto-y"
		}, {
			ProgressBar = React.createElement(Progress, {
				shape = Enums.ProgressShape.Bar,
				value = v2,
				testId = "tilt-loading-screen-auto-join-progress"
			})
		})
	end

	v10.Countdown = countdown
	local joinNewServerAction

	if v6 then
		joinNewServerAction = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "col align-x-center gap-xsmall auto-xy" },
			{
				Description = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v.dontWantToWait,
					tag = "auto-xy text-body-medium content-system-contrast"
				}),
				Button = React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = onActivated3,
					text = v.joinNewServer,
					testId = "tilt-loading-screen-join-new-server"
				})
			}
		)
	end

	v10.JoinNewServerAction = joinNewServerAction
	local joinTheLineAction

	if v7 then
		joinTheLineAction = React.createElement(
			View,
			{ LayoutOrder = 4, tag = "col align-x-center gap-xsmall auto-xy" },
			{
				Description = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v.wantToJoinYourFriend,
					tag = "auto-xy text-body-medium content-system-contrast"
				}),
				Button = React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = onActivated2,
					text = v.joinTheLine,
					testId = "tilt-loading-screen-join-the-line"
				})
			}
		)
	end

	v10.JoinTheLineAction = joinTheLineAction
	local robloxWordmark

	if isPioneerLaunch() then
		robloxWordmark = React.createElement(Footer, {
			LayoutOrder = 5,
			textTestId = "tilt-loading-screen-pre-logo-text",
			wordmarkTestId = "tilt-loading-screen-roblox-wordmark"
		})
	end

	v10.RobloxWordmark = robloxWordmark
	return createElement(View, v8, v10)
end

return React.memo(TiltLoadingScreenStatusPanel)
