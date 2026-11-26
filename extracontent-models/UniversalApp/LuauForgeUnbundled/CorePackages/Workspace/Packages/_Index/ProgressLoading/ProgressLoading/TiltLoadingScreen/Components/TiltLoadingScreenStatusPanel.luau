local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")
local Footer = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/Footer")

local button = Foundation.Button
local progress = Foundation.Progress
local text = Foundation.Text
local view = Foundation.View
local enums = Foundation.Enums

local useLocalization = Localization.Hooks.useLocalization
local fIntAutoJoinNewServerTimeMs = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FIntAutoJoinNewServerTimeMs
local isPioneerLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/PioneerUtils").isPioneerLaunch

local function localizeUiMessage(p2)
	local coreScriptLocalization = CoreGui:FindFirstChild("CoreScriptLocalization")

	if not coreScriptLocalization then
		return p2
	end

	local success, result = pcall(function()
		return coreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId):Translate(
			CoreGui,
			p2
		)
	end)

	if success then
		return result
	end

	return p2
end

local function TiltLoadingScreenStatusPanel(props)
	local v5 = useLocalization({
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
	local v6, v7 = React.useBinding(0)
	local state, setState = React.useState(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v8 = React.useCallback(function()
		setState(false)

		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end
	end, {})

	local v9 = React.useCallback(function()
		if ref2.current then
			return
		end

		setState(true)
		local lastTime = os.clock()
		local v10 = fIntAutoJoinNewServerTimeMs / 1000

		ref2.current = RunService.Heartbeat:Connect(function()
			local v11 = math.clamp((os.clock() - lastTime) / v10 * 100, 0, 100)
			v7(v11)

			if v11 >= 100 then
				v8()
				props.onAutoJoinNewServer()
			end
		end)
	end, { props.onAutoJoinNewServer, v8 })

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
			v9()
		else
			v8()
		end

		return v8
	end, { props.status, props.queueTreatment, props.followUserId, v9, v8 })

	local v10 = React.useCallback(function()
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

	local v11 = React.useCallback(function()
		v8()
		local onJoinTheLine = props.onJoinTheLine
		local v12 = if ref3.current then math.floor((os.clock() - ref3.current) * 1000) else nil
		onJoinTheLine(v12)
	end, { props.onJoinTheLine, v8 })

	local v12 = React.useCallback(function()
		local onJoinNewServer = props.onJoinNewServer
		local v13 = if ref3.current then math.floor((os.clock() - ref3.current) * 1000) else nil
		onJoinNewServer(v13)
	end, { props.onJoinNewServer })
	local v13

	if props.status == Constants.QUEUED_STATE then
		v13 = props.queueTreatment == Constants.JOIN_NEW_SERVER_TREATMENT
	else
		v13 = false
	end

	local v14

	if props.status == Constants.QUEUED_STATE and props.queueTreatment == Constants.AUTO_JOIN_TREATMENT then
		v14 = props.followUserId > 0 and state
	else
		v14 = false
	end

	local v15

	if props.status == Constants.QUEUED_STATE and props.followUserId > 0 and props.queueTreatment ~= nil then
		if state then
			v15 = v5.friendsServerIsFullJoiningNewServer
		else
			v15 = v5.friendsServerIsFullWaitingToJoin
		end
	end

	local result = ({
		Joining = v5.statusJoining,
		GameEnded = v5.statusGameEnded,
		HttpError = v5.statusHttpError
	})[props.status]

	if props.status == Constants.QUEUED_STATE and props.queuePosition ~= nil then
		result = v5.statusQueued
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
	local v17 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center align-y-bottom gap-large size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
		testId = "tilt-loading-screen-status-panel"
	}

	local createElement2 = React.createElement
	local v20 = {
		LayoutOrder = 1,
		tag = {
			["col align-x-center gap-small size-full-0 auto-y"] = true,
			["padding-bottom-small"] = isPioneerLaunch()
		},
		onActivated = v10,
		stateLayer = { affordance = enums.StateLayerAffordance.None },
		testId = "tilt-loading-screen-status"
	}

	local v22 = if props.isSubjectToChinaPolicies then React.createElement(text, {
		LayoutOrder = 1,
		Text = v5.antiAddictionText,
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-system-contrast"
	}) else nil

	local v23 = if v15 then React.createElement(text, {
		LayoutOrder = 2,
		Text = v15,
		tag = "auto-xy text-title-medium content-system-contrast",
		testId = "tilt-loading-screen-queue-description"
	}) else nil

	local v24 = if result ~= "" then React.createElement(text, {
		LayoutOrder = 3,
		Text = result,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-system-contrast"
	}) else nil
	local v18 = {
		Status = createElement2(view, v20, {
			Policy = v22,
			QueueDescription = v23,
			StatusText = v24
		}),
		Countdown = 0,
		JoinNewServerAction = 0,
		JoinTheLineAction = 0,
		RobloxWordmark = 0
	}

	local v25 = if state then React.createElement(
		view,
		{ LayoutOrder = 2, tag = "col align-x-center size-full-0 auto-y" },
		{
			ProgressBar = React.createElement(progress, {
				shape = enums.ProgressShape.Bar,
				value = v6,
				testId = "tilt-loading-screen-auto-join-progress"
			})
		}
	) else nil
	v18.Countdown = v25

	local v26 = if v13 then React.createElement(
		view,
		{ LayoutOrder = 3, tag = "col align-x-center gap-xsmall auto-xy" },
		{
			Description = React.createElement(text, {
				LayoutOrder = 1,
				Text = v5.dontWantToWait,
				tag = "auto-xy text-body-medium content-system-contrast"
			}),
			Button = React.createElement(button, {
				LayoutOrder = 2,
				onActivated = v12,
				text = v5.joinNewServer,
				testId = "tilt-loading-screen-join-new-server"
			})
		}
	) else nil
	v18.JoinNewServerAction = v26

	local v27 = if v14 then React.createElement(
		view,
		{ LayoutOrder = 4, tag = "col align-x-center gap-xsmall auto-xy" },
		{
			Description = React.createElement(text, {
				LayoutOrder = 1,
				Text = v5.wantToJoinYourFriend,
				tag = "auto-xy text-body-medium content-system-contrast"
			}),
			Button = React.createElement(button, {
				LayoutOrder = 2,
				onActivated = v11,
				text = v5.joinTheLine,
				testId = "tilt-loading-screen-join-the-line"
			})
		}
	) else nil
	v18.JoinTheLineAction = v27

	local v28 = if isPioneerLaunch() then React.createElement(Footer, {
		LayoutOrder = 5,
		textTestId = "tilt-loading-screen-pre-logo-text",
		wordmarkTestId = "tilt-loading-screen-roblox-wordmark"
	}) else nil
	v18.RobloxWordmark = v28
	return createElement(view, v17, v18)
end

return React.memo(TiltLoadingScreenStatusPanel)
