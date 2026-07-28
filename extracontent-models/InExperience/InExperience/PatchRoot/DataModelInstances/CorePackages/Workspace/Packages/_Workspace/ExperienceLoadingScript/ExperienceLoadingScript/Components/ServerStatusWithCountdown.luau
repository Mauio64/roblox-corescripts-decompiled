local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LoadingScreenTelemetry = require(ExperienceLoadingScriptParent.ProgressLoading.LoadingScreenTelemetry)
local PlaceLauncherState = require(ExperienceLoadingScript.Enums.PlaceLauncherState)
local getLoadingScreenStore = require(ExperienceLoadingScript.Store.getLoadingScreenStore)
local Foundation = require(ExperienceLoadingScriptParent.Foundation)
local useLocalization = require(ExperienceLoadingScriptParent.Localization).Hooks.useLocalization
local React = require(ExperienceLoadingScriptParent.React)

require(ExperienceLoadingScriptParent.Signals)

local SignalsReact = require(ExperienceLoadingScriptParent.SignalsReact)
local EngineFeature = game:GetEngineFeature("QueuePositionEnabled")
local SharedFlags = require(ExperienceLoadingScriptParent.SharedFlags)
local FIntAutoJoinNewServerTimeMs = SharedFlags.FIntAutoJoinNewServerTimeMs
local FFlagEnableLuaAppsFollowUserId = SharedFlags.FFlagEnableLuaAppsFollowUserId
local v18 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and FFlagEnableLuaAppsFollowUserId
local useTokens = Foundation.Hooks.useTokens

local function getStoreJoinState(p1) -- line: 34
	-- upvalues: getLoadingScreenStore (copy)
	local v23 = getLoadingScreenStore(p1)

	if p1 and (v23 and v23.getJoinState) then
		return v23.getJoinState(p1)
	end

	return ""
end
local function getStoreServerStatusText(p2) -- line: 42
	-- upvalues: getLoadingScreenStore (copy)
	local v25 = getLoadingScreenStore(p2)

	if p2 and (v25 and v25.getServerStatusText) then
		return v25.getServerStatusText(p2)
	end

	return ""
end

return React.memo(function(t1: {[any]: any}) -- line: 59
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), GuiService (copy), SignalsReact (copy), getStoreJoinState (copy), getStoreServerStatusText (copy), FIntAutoJoinNewServerTimeMs (copy), RunService (copy), ExperienceService (copy), PlaceLauncherState (copy), v18 (copy), LoadingScreenTelemetry (copy), EngineFeature (copy), Foundation (copy), CoreGui (copy)
	local v27 = useTokens()
	local v28 = useLocalization({
		friendsServerIsFullJoiningNewServer = "InGame.ConnectionError.Description.FriendsServerIsFullJoiningNewServer",
		friendsServerIsFullWaitingToJoin = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		joinTheLine = "InGame.ConnectionError.Action.JoinTheLine",
		wantToJoinYourFriend = "InGame.ConnectionError.Description.WantToJoinYourFriend"
	})
	local v29 = React.useRef(0)
	local v30 = React.useRef(1e999)
	local v31 = React.useCallback(function() -- line: 70
		-- upvalues: v29 (copy), v30 (copy), GuiService (copy)
		if v29.current == 0 then
			v29.current = 1
			v30.current = tick()

			return
		end

		if tick() - v30.current <= 0.5 then
			GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
		end

		v29.current = 0
		v30.current = 1e999
	end, {})
	local v32 = React.useCallback(function() -- line: 85
		-- upvalues: t1 (copy), v31 (copy)
		if not t1.isSubjectToChinaPolicies then
			v31()
		end
	end, {
		t1.isSubjectToChinaPolicies,
		v31
	})
	local v33 = SignalsReact.useSignalState(getStoreJoinState)
	local v34 = SignalsReact.useSignalBinding(getStoreServerStatusText)
	local v35, v36 = React.useBinding(0)
	local v37 = React.useRef(nil)
	local v38, v39 = React.useState(false)
	local v40 = React.useRef(nil)
	local v41 = React.useCallback(function() -- line: 100
		-- upvalues: v39 (copy), v40 (copy)
		v39(false)

		if v40.current then
			v40.current:Disconnect()
			v40.current = nil
		end
	end, {})
	local v42 = React.useCallback(function() -- line: 108
		-- upvalues: v40 (copy), v39 (copy), FIntAutoJoinNewServerTimeMs (copy), RunService (copy), v36 (copy), ExperienceService (copy), t1 (copy)
		if v40.current then
			return
		end

		v39(true)

		local elapsed = os.clock()
		local v45 = FIntAutoJoinNewServerTimeMs / 1000

		v40.current = RunService.Heartbeat:Connect(function() -- line: 118
			-- upvalues: elapsed (copy), v45 (copy), v36 (copy), ExperienceService (copy), t1 (copy), v40 (copy)
			local v47 = math.clamp((os.clock() - elapsed) / v45 * 100, 0, 100)

			v36(v47)

			if v47 >= 100 then
				ExperienceService:LaunchExperience({
					placeId = t1.placeId
				})

				if v40.current then
					v40.current:Disconnect()
					v40.current = nil
				end
			end
		end)
	end, { t1.placeId })

	React.useEffect(function() -- line: 132
		-- upvalues: v33 (copy), PlaceLauncherState (copy), v37 (copy)
		if v33 == PlaceLauncherState.Queued then
			v37.current = os.clock()
		end
	end, { v33 })
	React.useEffect(function() -- line: 138
		-- upvalues: v33 (copy), PlaceLauncherState (copy), v18 (copy), ExperienceService (copy), v42 (copy), v41 (copy)
		if v33 == PlaceLauncherState.Queued and (v18 and ExperienceService:GetFollowUserId() > 0) then
			v42()
		else
			v41()
		end

		return function() -- line: 149
			-- upvalues: v41 (copy)
			v41()
		end
	end, {
		v33,
		v42,
		v41
	})

	local v43 = React.useCallback(function() -- line: 154
		-- upvalues: v41 (copy), v37 (copy), LoadingScreenTelemetry (copy), v18 (copy), ExperienceService (copy), t1 (copy), EngineFeature (copy)
		v41()

		local v46 = if not v37.current then nil else math.floor((os.clock() - v37.current) * 1000)

		LoadingScreenTelemetry.logQueuedStateButtonClick({
			buttonName = "JoinTheLine",
			joinTargetUserId = if not v18 then nil else ExperienceService:GetFollowUserId(),
			placeId = t1.placeId,
			positionInQueue = if not EngineFeature then nil else ExperienceService:GetQueuePosition(),
			timeElapsedMs = v46,
			universeId = t1.universeId
		})
	end, {
		t1.placeId,
		t1.universeId,
		v41
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
			onActivated = v32,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			QueuedDescriptionText = if v33 ~= PlaceLauncherState.Queued or (not v18 or not (ExperienceService:GetFollowUserId() > 0)) then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-medium content-system-contrast",
				Text = if not v38 then v28.friendsServerIsFullWaitingToJoin else v28.friendsServerIsFullJoiningNewServer
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
				Font = v27.Typography.TitleMedium.Font,
				TextSize = v27.Typography.TitleMedium.FontSize,
				TextColor3 = v27.Color.System.Contrast.Color3,
				Text = v34,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
			})
		}),
		ProgressBarContainer = if not v38 then nil else React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "col align-x-center align-y-bottom gap-xsmall size-full-0 auto-y",
			sizeConstraint = {
				MaxSize = Vector2.new(277, 1e999)
			}
		}, {
			ProgressBar = React.createElement(Foundation.Progress, {
				shape = Foundation.Enums.ProgressShape.Bar,
				value = v35
			})
		}),
		ActionContainer = if v33 ~= PlaceLauncherState.Queued or (not v38 or (not v18 or not (ExperienceService:GetFollowUserId() > 0))) then nil else React.createElement(Foundation.View, {
			LayoutOrder = 3,
			tag = "col align-x-center align-y-bottom gap-xsmall auto-xy"
		}, {
			ActionButtonDescriptionText = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-body-medium content-system-contrast",
				Text = v28.wantToJoinYourFriend
			}),
			ActionButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = v43,
				text = v28.joinTheLine
			})
		})
	})
end)
