local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LoadingScreenTelemetry = require(ExperienceLoadingScript.LoadingScreenTelemetry)
local PlaceLauncherState = require(ExperienceLoadingScript.Enums.PlaceLauncherState)
local getLoadingScreenStore = require(ExperienceLoadingScript.Store.getLoadingScreenStore)
local Foundation = require(ExperienceLoadingScriptParent.Foundation)
local useLocalization = require(ExperienceLoadingScriptParent.Localization).Hooks.useLocalization
local React = require(ExperienceLoadingScriptParent.React)

require(ExperienceLoadingScriptParent.Signals)

local SignalsReact = require(ExperienceLoadingScriptParent.SignalsReact)
local v14 = game:DefineFastInt("AutoJoinNewServerTimeMs", 5000)
local EngineFeature = game:GetEngineFeature("QueuePositionEnabled")
local FFlagEnableLuaAppsFollowUserId = require(ExperienceLoadingScript.Flags.FFlagEnableLuaAppsFollowUserId)
local v17 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and FFlagEnableLuaAppsFollowUserId
local useTokens = Foundation.Hooks.useTokens

local function getStoreJoinState(p1) -- line: 33
	-- upvalues: getLoadingScreenStore (copy)
	local v22 = getLoadingScreenStore(p1)

	if p1 and (v22 and v22.getJoinState) then
		return v22.getJoinState(p1)
	end

	return ""
end
local function getStoreServerStatusText(p2) -- line: 41
	-- upvalues: getLoadingScreenStore (copy)
	local v24 = getLoadingScreenStore(p2)

	if p2 and (v24 and v24.getServerStatusText) then
		return v24.getServerStatusText(p2)
	end

	return ""
end

return React.memo(function(t1: {[any]: any}) -- line: 58
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), GuiService (copy), SignalsReact (copy), getStoreJoinState (copy), getStoreServerStatusText (copy), v14 (copy), RunService (copy), ExperienceService (copy), PlaceLauncherState (copy), v17 (copy), LoadingScreenTelemetry (copy), EngineFeature (copy), Foundation (copy), CoreGui (copy)
	local v26 = useTokens()
	local v27 = useLocalization({
		friendsServerIsFullJoiningNewServer = "InGame.ConnectionError.Description.FriendsServerIsFullJoiningNewServer",
		friendsServerIsFullWaitingToJoin = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		joinTheLine = "InGame.ConnectionError.Action.JoinTheLine",
		wantToJoinYourFriend = "InGame.ConnectionError.Description.WantToJoinYourFriend"
	})
	local v28 = React.useRef(0)
	local v29 = React.useRef(1e999)
	local v30 = React.useCallback(function() -- line: 69
		-- upvalues: v28 (copy), v29 (copy), GuiService (copy)
		if v28.current == 0 then
			v28.current = 1
			v29.current = tick()

			return
		end

		if tick() - v29.current <= 0.5 then
			GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
		end

		v28.current = 0
		v29.current = 1e999
	end, {})
	local v31 = React.useCallback(function() -- line: 84
		-- upvalues: t1 (copy), v30 (copy)
		if not t1.isSubjectToChinaPolicies then
			v30()
		end
	end, {
		t1.isSubjectToChinaPolicies,
		v30
	})
	local v32 = SignalsReact.useSignalState(getStoreJoinState)
	local v33 = SignalsReact.useSignalBinding(getStoreServerStatusText)
	local v34, v35 = React.useBinding(0)
	local v36 = React.useRef(nil)
	local v37, v38 = React.useState(false)
	local v39 = React.useRef(nil)
	local v40 = React.useCallback(function() -- line: 99
		-- upvalues: v38 (copy), v39 (copy)
		v38(false)

		if v39.current then
			v39.current:Disconnect()
			v39.current = nil
		end
	end, {})
	local v41 = React.useCallback(function() -- line: 107
		-- upvalues: v39 (copy), v38 (copy), v14 (copy), RunService (copy), v35 (copy), ExperienceService (copy), t1 (copy)
		if v39.current then
			return
		end

		v38(true)

		local elapsed = os.clock()
		local v44 = v14 / 1000

		v39.current = RunService.Heartbeat:Connect(function() -- line: 117
			-- upvalues: elapsed (copy), v44 (copy), v35 (copy), ExperienceService (copy), t1 (copy), v39 (copy)
			local v46 = math.clamp((os.clock() - elapsed) / v44 * 100, 0, 100)

			v35(v46)

			if v46 >= 100 then
				ExperienceService:LaunchExperience({
					placeId = t1.placeId
				})

				if v39.current then
					v39.current:Disconnect()
					v39.current = nil
				end
			end
		end)
	end, { t1.placeId })

	React.useEffect(function() -- line: 131
		-- upvalues: v32 (copy), PlaceLauncherState (copy), v36 (copy)
		if v32 == PlaceLauncherState.Queued then
			v36.current = os.clock()
		end
	end, { v32 })
	React.useEffect(function() -- line: 137
		-- upvalues: v32 (copy), PlaceLauncherState (copy), v17 (copy), ExperienceService (copy), v41 (copy), v40 (copy)
		if v32 == PlaceLauncherState.Queued and (v17 and ExperienceService:GetFollowUserId() > 0) then
			v41()
		else
			v40()
		end

		return function() -- line: 148
			-- upvalues: v40 (copy)
			v40()
		end
	end, {
		v32,
		v41,
		v40
	})

	local v42 = React.useCallback(function() -- line: 153
		-- upvalues: v40 (copy), v36 (copy), LoadingScreenTelemetry (copy), v17 (copy), ExperienceService (copy), t1 (copy), EngineFeature (copy)
		v40()

		local v45 = if not v36.current then nil else math.floor((os.clock() - v36.current) * 1000)

		LoadingScreenTelemetry.logQueuedStateButtonClick({
			buttonName = "JoinTheLine",
			joinTargetUserId = if not v17 then nil else ExperienceService:GetFollowUserId(),
			placeId = t1.placeId,
			positionInQueue = if not EngineFeature then nil else ExperienceService:GetQueuePosition(),
			timeElapsedMs = v45,
			universeId = t1.universeId
		})
	end, {
		t1.placeId,
		t1.universeId,
		v40
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
			onActivated = v31,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			QueuedDescriptionText = if v32 ~= PlaceLauncherState.Queued or (not v17 or not (ExperienceService:GetFollowUserId() > 0)) then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-medium content-system-contrast",
				Text = if not v37 then v27.friendsServerIsFullWaitingToJoin else v27.friendsServerIsFullJoiningNewServer
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
				Font = v26.Typography.TitleMedium.Font,
				TextSize = v26.Typography.TitleMedium.FontSize,
				TextColor3 = v26.Color.System.Contrast.Color3,
				Text = v33,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
			})
		}),
		ProgressBarContainer = if not v37 then nil else React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "col align-x-center align-y-bottom gap-xsmall size-full-0 auto-y",
			sizeConstraint = {
				MaxSize = Vector2.new(277, 1e999)
			}
		}, {
			ProgressBar = React.createElement(Foundation.Progress, {
				shape = Foundation.Enums.ProgressShape.Bar,
				value = v34
			})
		}),
		ActionContainer = if v32 ~= PlaceLauncherState.Queued or (not v37 or (not v17 or not (ExperienceService:GetFollowUserId() > 0))) then nil else React.createElement(Foundation.View, {
			LayoutOrder = 3,
			tag = "col align-x-center align-y-bottom gap-xsmall auto-xy"
		}, {
			ActionButtonDescriptionText = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-body-medium content-system-contrast",
				Text = v27.wantToJoinYourFriend
			}),
			ActionButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				onActivated = v42,
				text = v27.joinTheLine
			})
		})
	})
end)
