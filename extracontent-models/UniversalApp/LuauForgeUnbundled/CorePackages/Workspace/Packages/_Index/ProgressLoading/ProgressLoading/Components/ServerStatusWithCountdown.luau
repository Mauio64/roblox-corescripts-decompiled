local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")
local PlaceLauncherState = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Enums/PlaceLauncherState")
local getLoadingScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/getLoadingScreenStore")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization").Hooks.useLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SignalsReact")

local engineFeature = game:GetEngineFeature("QueuePositionEnabled")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags")
local fIntAutoJoinNewServerTimeMs = SharedFlags.FIntAutoJoinNewServerTimeMs
local fFlagEnableLuaAppsFollowUserId = SharedFlags.FFlagEnableLuaAppsFollowUserId
local v5 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and fFlagEnableLuaAppsFollowUserId

local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local function getStoreJoinState(p2)
	local v6 = getLoadingScreenStore(p2)

	if p2 and v6 and v6.getJoinState then
		return v6.getJoinState(p2)
	end

	return ""
end

local function getStoreServerStatusText(p2)
	local v6 = getLoadingScreenStore(p2)

	if p2 and v6 and v6.getServerStatusText then
		return v6.getServerStatusText(p2)
	end

	return ""
end

return React.memo(function(props)
	local v6 = useTokens()
	local v7 = useLocalization({
		friendsServerIsFullJoiningNewServer = "InGame.ConnectionError.Description.FriendsServerIsFullJoiningNewServer",
		friendsServerIsFullWaitingToJoin = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		joinTheLine = "InGame.ConnectionError.Action.JoinTheLine",
		wantToJoinYourFriend = "InGame.ConnectionError.Description.WantToJoinYourFriend"
	})

	local ref = React.useRef(0)
	local ref2 = React.useRef(1e999)

	local v8 = React.useCallback(function()
		if ref.current == 0 then
			ref.current = 1
			ref2.current = tick()
		else
			if tick() - ref2.current <= 0.5 then
				GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
			end

			ref.current = 0
			ref2.current = 1e999
		end
	end, {})

	local v9 = React.useCallback(function()
		if not props.isSubjectToChinaPolicies then
			v8()
		end
	end, { props.isSubjectToChinaPolicies, v8 })

	local v10 = SignalsReact.useSignalState(getStoreJoinState)
	local v11 = SignalsReact.useSignalBinding(getStoreServerStatusText)

	local v12, v13 = React.useBinding(0)
	local ref3 = React.useRef(nil)
	local state, setState = React.useState(false)

	local ref4 = React.useRef(nil)

	local v14 = React.useCallback(function()
		setState(false)

		if ref4.current then
			ref4.current:Disconnect()
			ref4.current = nil
		end
	end, {})

	local v15 = React.useCallback(function()
		if ref4.current then
			return
		end

		setState(true)

		local lastTime = os.clock()
		local v16 = fIntAutoJoinNewServerTimeMs / 1000

		ref4.current = RunService.Heartbeat:Connect(function()
			local v17 = math.clamp((os.clock() - lastTime) / v16 * 100, 0, 100)
			v13(v17)

			if v17 >= 100 then
				ExperienceService:LaunchExperience({ placeId = props.placeId })

				if ref4.current then
					ref4.current:Disconnect()
					ref4.current = nil
				end
			end
		end)
	end, { props.placeId })

	React.useEffect(function()
		if v10 == PlaceLauncherState.Queued then
			ref3.current = os.clock()
		end
	end, { v10 })

	React.useEffect(function()
		if v10 == PlaceLauncherState.Queued and v5 and ExperienceService:GetFollowUserId() > 0 then
			v15()
		else
			v14()
		end

		return function()
			v14()
		end
	end, { v10, v15, v14 })

	local v16 = React.useCallback(function()
		v14()

		local v17 = if ref3.current then math.floor((os.clock() - ref3.current) * 1000) else nil

		local logQueuedStateButtonClick = LoadingScreenTelemetry.logQueuedStateButtonClick

		local v19 = if v5 then ExperienceService:GetFollowUserId() else nil
		local v18 = {
			buttonName = "JoinTheLine",
			joinTargetUserId = v19,
			placeId = props.placeId,
			positionInQueue = 0,
			timeElapsedMs = 0,
			universeId = 0
		}
		local v20 = if engineFeature then ExperienceService:GetQueuePosition() else nil
		v18.positionInQueue = v20
		v18.timeElapsedMs = v17
		v18.universeId = props.universeId
		logQueuedStateButtonClick(v18)
	end, { props.placeId, props.universeId, v14 })

	local createElement = React.createElement
	local view = Foundation.View
	local v17 = {
		AnchorPoint = props.anchorPoint,
		AutoLocalize = true,
		Position = props.position,
		Size = props.size,
		tag = "col align-x-center align-y-bottom gap-xxlarge"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v19 = {
		AutoLocalize = true,
		LayoutOrder = 1,
		tag = "col align-x-center align-y-bottom gap-xsmall auto-xy",
		onActivated = v9,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}
	local v21

	if v10 == PlaceLauncherState.Queued and v5 and ExperienceService:GetFollowUserId() > 0 then
		local createElement3 = React.createElement
		local text = Foundation.Text

		local v23 = if state then v7.friendsServerIsFullJoiningNewServer else v7.friendsServerIsFullWaitingToJoin
		v21 = createElement3(text, {
			LayoutOrder = 1,
			Text = v23,
			tag = "auto-xy text-title-medium content-system-contrast"
		})
	end

	local v18 = {
		ServerStatusContainer = createElement2(view2, v19, {
			QueuedDescriptionText = v21,
			ServerStatusText = React.createElement("TextLabel", {
				AutoLocalize = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				FontFace = normalizeFontFace(v6.Typography.TitleMedium.Font),
				TextSize = v6.Typography.TitleMedium.FontSize,
				TextWrapped = true,
				TextScaled = false,
				TextColor3 = v6.Color.System.Contrast.Color3,
				TextStrokeTransparency = 1,
				Text = v11,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 2,
				RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
			})
		}),
		ProgressBarContainer = 0,
		ActionContainer = 0
	}

	local v22 = if state then React.createElement(Foundation.View, {
		LayoutOrder = 2,
		sizeConstraint = { MaxSize = Vector2.new(277, 1e999) },
		tag = "col align-x-center align-y-bottom gap-xsmall size-full-0 auto-y"
	}, {
		ProgressBar = React.createElement(Foundation.Progress, {
			shape = Foundation.Enums.ProgressShape.Bar,
			value = v12
		})
	}) else nil
	v18.ProgressBarContainer = v22

	local v23 = if v10 == PlaceLauncherState.Queued and state and v5 and ExperienceService:GetFollowUserId() > 0 then React.createElement(
		Foundation.View,
		{
			LayoutOrder = 3,
			tag = "col align-x-center align-y-bottom gap-xsmall auto-xy"
		},
		{
			ActionButtonDescriptionText = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				Text = v7.wantToJoinYourFriend,
				tag = "auto-xy text-body-medium content-system-contrast"
			}),
			ActionButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = v16,
				text = v7.joinTheLine
			})
		}
	) else nil
	v18.ActionContainer = v23
	return createElement(view, v17, v18)
end)
