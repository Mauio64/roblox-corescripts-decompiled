local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local LoadingScreenTelemetry = require(ProgressLoading.LoadingScreenTelemetry)
local PlaceLauncherState = require(ProgressLoading.Enums.PlaceLauncherState)
local getLoadingScreenStore = require(ProgressLoading.Stores.getLoadingScreenStore)

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local engineFeature = game:GetEngineFeature("QueuePositionEnabled")
local SharedFlags = require(parent.SharedFlags)
local FIntAutoJoinNewServerTimeMs = SharedFlags.FIntAutoJoinNewServerTimeMs
local FFlagEnableLuaAppsFollowUserId = SharedFlags.FFlagEnableLuaAppsFollowUserId
local v = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and FFlagEnableLuaAppsFollowUserId

local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function getStoreJoinState(p)
	local loadingScreenStore = getLoadingScreenStore(p)

	if p and loadingScreenStore and loadingScreenStore.getJoinState then
		return loadingScreenStore.getJoinState(p)
	end

	return ""
end

local function getStoreServerStatusText(p)
	local loadingScreenStore = getLoadingScreenStore(p)

	if p and loadingScreenStore and loadingScreenStore.getServerStatusText then
		return loadingScreenStore.getServerStatusText(p)
	end

	return ""
end

return React.memo(function(props)
	local v2 = useTokens()
	local v3 = useLocalization({
		friendsServerIsFullJoiningNewServer = "InGame.ConnectionError.Description.FriendsServerIsFullJoiningNewServer",
		friendsServerIsFullWaitingToJoin = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		joinTheLine = "InGame.ConnectionError.Action.JoinTheLine",
		wantToJoinYourFriend = "InGame.ConnectionError.Description.WantToJoinYourFriend"
	})

	local ref = React.useRef(0)
	local ref2 = React.useRef(1e999)

	local v4 = React.useCallback(function()
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

	local onActivated = React.useCallback(function()
		if not props.isSubjectToChinaPolicies then
			v4()
		end
	end, { props.isSubjectToChinaPolicies, v4 })

	local v5 = SignalsReact.useSignalState(getStoreJoinState)
	local text2 = SignalsReact.useSignalBinding(getStoreServerStatusText)

	local v6, v7 = React.useBinding(0)
	local ref3 = React.useRef(nil)
	local state, setState = React.useState(false)

	local ref4 = React.useRef(nil)

	local v8 = React.useCallback(function()
		setState(false)

		if ref4.current then
			ref4.current:Disconnect()
			ref4.current = nil
		end
	end, {})

	local v9 = React.useCallback(function()
		if ref4.current then
			return
		end

		setState(true)

		local lastTime = os.clock()
		local v9 = FIntAutoJoinNewServerTimeMs / 1000

		ref4.current = RunService.Heartbeat:Connect(function()
			local v10 = math.clamp((os.clock() - lastTime) / v9 * 100, 0, 100)
			v7(v10)

			if v10 >= 100 then
				ExperienceService:LaunchExperience({ placeId = props.placeId })

				if ref4.current then
					ref4.current:Disconnect()
					ref4.current = nil
				end
			end
		end)
	end, { props.placeId })

	React.useEffect(function()
		if v5 == PlaceLauncherState.Queued then
			ref3.current = os.clock()
		end
	end, { v5 })

	React.useEffect(function()
		if v5 == PlaceLauncherState.Queued and v and ExperienceService:GetFollowUserId() > 0 then
			v9()
		else
			v8()
		end

		return function()
			v8()
		end
	end, { v5, v9, v8 })

	local onActivated2 = React.useCallback(function()
		v8()
		local timeElapsedMs

		if ref3.current then
			timeElapsedMs = math.floor((os.clock() - ref3.current) * 1000)
		end

		local logQueuedStateButtonClick = LoadingScreenTelemetry.logQueuedStateButtonClick
		local joinTargetUserId

		if v then
			joinTargetUserId = ExperienceService:GetFollowUserId()
		end

		local v10 = {
			buttonName = "JoinTheLine",
			joinTargetUserId = joinTargetUserId,
			placeId = props.placeId,
			positionInQueue = 0,
			timeElapsedMs = 0,
			universeId = 0
		}
		local positionInQueue

		if engineFeature then
			positionInQueue = ExperienceService:GetQueuePosition()
		end

		v10.positionInQueue = positionInQueue
		v10.timeElapsedMs = timeElapsedMs
		v10.universeId = props.universeId
		logQueuedStateButtonClick(v10)
	end, { props.placeId, props.universeId, v8 })

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		AnchorPoint = props.anchorPoint,
		AutoLocalize = true,
		Position = props.position,
		Size = props.size,
		tag = "col align-x-center align-y-bottom gap-xxlarge"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v11 = {
		AutoLocalize = true,
		LayoutOrder = 1,
		tag = "col align-x-center align-y-bottom gap-xsmall auto-xy",
		onActivated = onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}
	local queuedDescriptionText

	if v5 == PlaceLauncherState.Queued and v and ExperienceService:GetFollowUserId() > 0 then
		local createElement3 = React.createElement
		local text = Foundation.Text
		local text3

		if state then
			text3 = v3.friendsServerIsFullJoiningNewServer
		else
			text3 = v3.friendsServerIsFullWaitingToJoin
		end

		queuedDescriptionText = createElement3(text, {
			LayoutOrder = 1,
			Text = text3,
			tag = "auto-xy text-title-medium content-system-contrast"
		})
	end

	local createElement3 = React.createElement
	local v12 = {
		AutoLocalize = true,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextWrapped = true,
		TextScaled = false,
		TextColor3 = 0,
		TextStrokeTransparency = 1,
		Text = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		ZIndex = 2,
		RootLocalizationTable = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = v2.Typography.TitleMedium.Font
	end

	v12.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Typography.TitleMedium.Font)
	end

	v12.FontFace = fontFace

	v12.TextSize = v2.Typography.TitleMedium.FontSize

	v12.TextColor3 = v2.Color.System.Contrast.Color3

	v12.Text = text2
	v12.TextXAlignment = Enum.TextXAlignment.Center
	v12.TextYAlignment = Enum.TextYAlignment.Center

	v12.RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
	local v13 = {
		ServerStatusContainer = createElement2(view2, v11, {
			QueuedDescriptionText = queuedDescriptionText,
			ServerStatusText = createElement3("TextLabel", v12)
		}),
		ProgressBarContainer = 0,
		ActionContainer = 0
	}
	local progressBarContainer

	if state then
		progressBarContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			sizeConstraint = { MaxSize = Vector2.new(277, 1e999) },
			tag = "col align-x-center align-y-bottom gap-xsmall size-full-0 auto-y"
		}, {
			ProgressBar = React.createElement(Foundation.Progress, {
				shape = Foundation.Enums.ProgressShape.Bar,
				value = v6
			})
		})
	end

	v13.ProgressBarContainer = progressBarContainer
	local actionContainer

	if v5 == PlaceLauncherState.Queued and state and v and ExperienceService:GetFollowUserId() > 0 then
		actionContainer = React.createElement(
			Foundation.View,
			{ LayoutOrder = 3, tag = "col align-x-center align-y-bottom gap-xsmall auto-xy" },
			{
				ActionButtonDescriptionText = React.createElement(Foundation.Text, {
					LayoutOrder = 1,
					Text = v3.wantToJoinYourFriend,
					tag = "auto-xy text-body-medium content-system-contrast"
				}),
				ActionButton = React.createElement(Foundation.Button, {
					LayoutOrder = 2,
					onActivated = onActivated2,
					text = v3.joinTheLine
				})
			}
		)
	end

	v13.ActionContainer = actionContainer
	return createElement(view, v10, v13)
end)
