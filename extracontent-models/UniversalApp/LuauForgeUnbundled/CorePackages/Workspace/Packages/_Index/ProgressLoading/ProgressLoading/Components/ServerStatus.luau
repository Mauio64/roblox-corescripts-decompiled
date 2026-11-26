local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")

local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")
local PlaceLauncherState = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Enums/PlaceLauncherState")
local getLoadingScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/getLoadingScreenStore")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization").Hooks.useLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SignalsReact")

local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local engineFeature = game:GetEngineFeature("QueuePositionEnabled")
local fFlagEnableLuaAppsFollowUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagEnableLuaAppsFollowUserId
local v5 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and fFlagEnableLuaAppsFollowUserId

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
		queuedDescription = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		dontWantToWait = "InGame.ConnectionError.Description.DontWantToWait",
		joinNewServer = "InGame.ConnectionError.Action.JoinNewServer"
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
	local ref3 = React.useRef(nil)

	React.useEffect(function()
		if v10 == PlaceLauncherState.Queued then
			ref3.current = os.clock()
		end
	end, { v10 })

	local v12 = React.useCallback(function()
		local v13 = if ref3.current then math.floor((os.clock() - ref3.current) * 1000) else nil

		local logQueuedStateButtonClick = LoadingScreenTelemetry.logQueuedStateButtonClick

		local v15 = if v5 then ExperienceService:GetFollowUserId() else nil
		local v14 = {
			buttonName = "JoinNewServer",
			joinTargetUserId = v15,
			placeId = props.placeId,
			positionInQueue = 0,
			timeElapsedMs = 0,
			universeId = 0
		}
		local v16 = if engineFeature then ExperienceService:GetQueuePosition() else nil
		v14.positionInQueue = v16
		v14.timeElapsedMs = v13
		v14.universeId = props.universeId
		logQueuedStateButtonClick(v14)

		ExperienceService:LaunchExperience({ placeId = props.placeId })
	end, { props.placeId, props.universeId })

	local createElement = React.createElement
	local view = Foundation.View
	local v13 = {
		AnchorPoint = props.anchorPoint,
		AutoLocalize = true,
		Position = props.position,
		Size = props.size,
		tag = "col align-x-center align-y-bottom gap-xxlarge"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v15 = {
		AutoLocalize = true,
		LayoutOrder = 1,
		tag = "col align-x-center align-y-bottom gap-xsmall auto-xy",
		onActivated = v9,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}

	local v17 = if v10 == PlaceLauncherState.Queued and v5 and ExperienceService:GetFollowUserId() > 0 then React.createElement(Foundation.Text, {
		LayoutOrder = 1,
		Text = v7.queuedDescription,
		tag = "auto-xy text-title-medium content-system-contrast"
	}) else nil
	local v14 = {
		ServerStatusContainer = createElement2(view2, v15, {
			QueuedDescriptionText = v17,
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
		ActionContainer = 0
	}

	local v18 = if v10 == PlaceLauncherState.Queued then React.createElement(
		Foundation.View,
		{
			LayoutOrder = 2,
			tag = "col align-x-center align-y-bottom gap-xsmall auto-xy"
		},
		{
			ActionButtonDescriptionText = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				Text = v7.dontWantToWait,
				tag = "auto-xy text-body-medium content-system-contrast"
			}),
			ActionButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = v12,
				text = v7.joinNewServer
			})
		}
	) else nil
	v14.ActionContainer = v18
	return createElement(view, v13, v14)
end)
