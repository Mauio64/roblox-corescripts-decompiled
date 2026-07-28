local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local LoadingScreenTelemetry = require(ExperienceLoadingScriptParent.ProgressLoading.LoadingScreenTelemetry)
local PlaceLauncherState = require(ExperienceLoadingScript.Enums.PlaceLauncherState)
local getLoadingScreenStore = require(ExperienceLoadingScript.Store.getLoadingScreenStore)
local Foundation = require(ExperienceLoadingScriptParent.Foundation)
local useLocalization = require(ExperienceLoadingScriptParent.Localization).Hooks.useLocalization
local React = require(ExperienceLoadingScriptParent.React)

require(ExperienceLoadingScriptParent.Signals)

local SignalsReact = require(ExperienceLoadingScriptParent.SignalsReact)
local useTokens = Foundation.Hooks.useTokens
local EngineFeature = game:GetEngineFeature("QueuePositionEnabled")
local FFlagEnableLuaAppsFollowUserId = require(ExperienceLoadingScriptParent.SharedFlags).FFlagEnableLuaAppsFollowUserId
local v16 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and FFlagEnableLuaAppsFollowUserId

local function getStoreJoinState(p1) -- line: 29
	-- upvalues: getLoadingScreenStore (copy)
	local v20 = getLoadingScreenStore(p1)

	if p1 and (v20 and v20.getJoinState) then
		return v20.getJoinState(p1)
	end

	return ""
end
local function getStoreServerStatusText(p2) -- line: 37
	-- upvalues: getLoadingScreenStore (copy)
	local v22 = getLoadingScreenStore(p2)

	if p2 and (v22 and v22.getServerStatusText) then
		return v22.getServerStatusText(p2)
	end

	return ""
end

return React.memo(function(t1: {[any]: any}) -- line: 54
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), GuiService (copy), SignalsReact (copy), getStoreJoinState (copy), getStoreServerStatusText (copy), PlaceLauncherState (copy), LoadingScreenTelemetry (copy), v16 (copy), ExperienceService (copy), EngineFeature (copy), Foundation (copy), CoreGui (copy)
	local v24 = useTokens()
	local v25 = useLocalization({
		queuedDescription = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		dontWantToWait = "InGame.ConnectionError.Description.DontWantToWait",
		joinNewServer = "InGame.ConnectionError.Action.JoinNewServer"
	})
	local v26 = React.useRef(0)
	local v27 = React.useRef(1e999)
	local v28 = React.useCallback(function() -- line: 64
		-- upvalues: v26 (copy), v27 (copy), GuiService (copy)
		if v26.current == 0 then
			v26.current = 1
			v27.current = tick()

			return
		end

		if tick() - v27.current <= 0.5 then
			GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
		end

		v26.current = 0
		v27.current = 1e999
	end, {})
	local v29 = React.useCallback(function() -- line: 79
		-- upvalues: t1 (copy), v28 (copy)
		if not t1.isSubjectToChinaPolicies then
			v28()
		end
	end, {
		t1.isSubjectToChinaPolicies,
		v28
	})
	local v30 = SignalsReact.useSignalState(getStoreJoinState)
	local v31 = SignalsReact.useSignalBinding(getStoreServerStatusText)
	local v32 = React.useRef(nil)

	React.useEffect(function() -- line: 89
		-- upvalues: v30 (copy), PlaceLauncherState (copy), v32 (copy)
		if v30 == PlaceLauncherState.Queued then
			v32.current = os.clock()
		end
	end, { v30 })

	local v33 = React.useCallback(function() -- line: 95
		-- upvalues: v32 (copy), LoadingScreenTelemetry (copy), v16 (copy), ExperienceService (copy), t1 (copy), EngineFeature (copy)
		local v34 = if not v32.current then nil else math.floor((os.clock() - v32.current) * 1000)

		LoadingScreenTelemetry.logQueuedStateButtonClick({
			buttonName = "JoinNewServer",
			joinTargetUserId = if not v16 then nil else ExperienceService:GetFollowUserId(),
			placeId = t1.placeId,
			positionInQueue = if not EngineFeature then nil else ExperienceService:GetQueuePosition(),
			timeElapsedMs = v34,
			universeId = t1.universeId
		})
		ExperienceService:LaunchExperience({
			placeId = t1.placeId
		})
	end, {
		t1.placeId,
		t1.universeId
	})

	return React.createElement(Foundation.View, {
		AutoLocalize = true,
		tag = "col align-x-center align-y-bottom gap-xxlarge",
		AnchorPoint = t1.anchorPoint,
		Position = t1.position,
		Size = t1.size
	}, {
		ServerStatusContainer = React.createElement(Foundation.View, {
			AutoLocalize = true,
			LayoutOrder = 1,
			tag = "col align-x-center align-y-bottom gap-xsmall auto-xy",
			onActivated = v29,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			QueuedDescriptionText = if v30 ~= PlaceLauncherState.Queued or (not v16 or not (ExperienceService:GetFollowUserId() > 0)) then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-medium content-system-contrast",
				Text = v25.queuedDescription
			}),
			ServerStatusText = React.createElement("TextLabel", {
				AutoLocalize = true,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				TextWrapped = true,
				TextScaled = false,
				TextStrokeTransparency = 1,
				ZIndex = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Font = v24.Typography.TitleMedium.Font,
				TextSize = v24.Typography.TitleMedium.FontSize,
				TextColor3 = v24.Color.System.Contrast.Color3,
				Text = v31,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
			})
		}),
		ActionContainer = if v30 ~= PlaceLauncherState.Queued then nil else React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "col align-x-center align-y-bottom gap-xsmall auto-xy"
		}, {
			ActionButtonDescriptionText = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-body-medium content-system-contrast",
				Text = v25.dontWantToWait
			}),
			ActionButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = v33,
				text = v25.joinNewServer
			})
		})
	})
end)
