local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local ParentParent = TiltLoadingScreen.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local Localization = require(ParentParent.Localization)
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local Constants = require(TiltLoadingScreen.Constants)

require(TiltLoadingScreen.Types)

local Button = Foundation.Button
local FoundationImage = Foundation.Image
local Progress = Foundation.Progress
local FoundationText = Foundation.Text
local View = Foundation.View
local Enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(ParentParent.SharedFlags)
local FIntAutoJoinNewServerTimeMs = SharedFlags.FIntAutoJoinNewServerTimeMs
local FFlagDebugEnablePioneerUX = SharedFlags.FFlagDebugEnablePioneerUX

local function localizeUiMessage(s1: string) -- line: 29
	-- upvalues: CoreGui (copy), LocalizationService (copy)
	local CoreScriptLocalization = CoreGui:FindFirstChild("CoreScriptLocalization")

	if not CoreScriptLocalization then
		return s1
	end

	local ok, result = pcall(function() -- line: 34
		-- upvalues: CoreScriptLocalization (copy), LocalizationService (copy), CoreGui (copy), s1 (copy)
		return CoreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId):Translate(CoreGui, s1)
	end)

	if ok then
		return result
	end

	return s1
end
local function TiltLoadingScreenStatusPanel(p1) -- line: 41
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), FIntAutoJoinNewServerTimeMs (copy), RunService (copy), Constants (copy), CoreGui (copy), LocalizationService (copy), View (copy), Enums (copy), FoundationText (copy), Progress (copy), Button (copy), FFlagDebugEnablePioneerUX (copy), FoundationImage (copy)
	local v28 = useTokens()
	local v29 = useLocalization({
		antiAddictionText = "Authentication.Login.WeChat.AntiAddictionText",
		dontWantToWait = "InGame.ConnectionError.Description.DontWantToWait",
		friendsServerIsFullJoiningNewServer = "InGame.ConnectionError.Description.FriendsServerIsFullJoiningNewServer",
		friendsServerIsFullWaitingToJoin = "InGame.ConnectionError.Description.FriendsServerIsFullWaitingToJoin",
		joinNewServer = "InGame.ConnectionError.Action.JoinNewServer",
		joinTheLine = "InGame.ConnectionError.Action.JoinTheLine",
		statusGameEnded = "InGame.ConnectionError.PlacelaunchGameEnded",
		statusHttpError = "InGame.ConnectionError.PlacelaunchHttpError",
		statusJoining = "InGame.ConnectionError.Joining",
		wantToJoinYourFriend = "InGame.ConnectionError.Description.WantToJoinYourFriend",
		statusQueued = {
			"InGame.ConnectionError.Queue",
			POSITION = tostring(p1.queuePosition or "")
		}
	})
	local v30 = React.useRef(-1e999)
	local v31, v32 = React.useBinding(0)
	local v33, v34 = React.useState(false)
	local v35 = React.useRef(nil)
	local v36 = React.useRef(nil)
	local v37 = React.useCallback(function() -- line: 66
		-- upvalues: v34 (copy), v35 (copy)
		v34(false)

		if v35.current then
			v35.current:Disconnect()
			v35.current = nil
		end
	end, {})
	local v38 = React.useCallback(function() -- line: 74
		-- upvalues: v35 (copy), v34 (copy), FIntAutoJoinNewServerTimeMs (copy), RunService (copy), v32 (copy), v37 (copy), p1 (copy)
		if v35.current then
			return
		end

		v34(true)

		local elapsed = os.clock()
		local v51 = FIntAutoJoinNewServerTimeMs / 1000

		v35.current = RunService.Heartbeat:Connect(function() -- line: 83
			-- upvalues: elapsed (copy), v51 (copy), v32 (copy), v37 (copy), p1 (copy)
			local v53 = math.clamp((os.clock() - elapsed) / v51 * 100, 0, 100)

			v32(v53)

			if v53 >= 100 then
				v37()
				p1.onAutoJoinNewServer()
			end
		end)
	end, {
		p1.onAutoJoinNewServer,
		v37
	})

	React.useEffect(function() -- line: 94
		-- upvalues: p1 (copy), Constants (copy), v36 (copy)
		if p1.status == Constants.QUEUED_STATE then
			v36.current = os.clock()
		end
	end, { p1.status })
	React.useEffect(function() -- line: 100
		-- upvalues: p1 (copy), Constants (copy), v38 (copy), v37 (copy)
		if p1.status == Constants.QUEUED_STATE and (p1.queueTreatment == Constants.AUTO_JOIN_TREATMENT and p1.followUserId > 0) then
			v38()
		else
			v37()
		end

		return v37
	end, {
		p1.status,
		p1.queueTreatment,
		p1.followUserId,
		v38,
		v37
	})

	local v39 = React.useCallback(function() -- line: 114
		-- upvalues: p1 (copy), v30 (copy), Constants (copy)
		if p1.isSubjectToChinaPolicies then
			return
		end

		local elapsed = os.clock()

		if elapsed - v30.current <= Constants.DOUBLE_TAP_WINDOW_SECONDS then
			p1.onShowConnectionHealth()
			v30.current = -1e999

			return
		end

		v30.current = elapsed
	end, {
		p1.isSubjectToChinaPolicies,
		p1.onShowConnectionHealth
	})
	local v40 = React.useCallback(function() -- line: 127
		-- upvalues: v37 (copy), p1 (copy), v36 (copy)
		v37()
		p1.onJoinTheLine(if not v36.current then nil else math.floor((os.clock() - v36.current) * 1000))
	end, {
		p1.onJoinTheLine,
		v37
	})
	local v41 = React.useCallback(function() -- line: 134
		-- upvalues: p1 (copy), v36 (copy)
		p1.onJoinNewServer(if not v36.current then nil else math.floor((os.clock() - v36.current) * 1000))
	end, { p1.onJoinNewServer })
	local v42 = p1.status == Constants.QUEUED_STATE and p1.queueTreatment == Constants.JOIN_NEW_SERVER_TREATMENT
	local v43 = p1.status == Constants.QUEUED_STATE and (p1.queueTreatment == Constants.AUTO_JOIN_TREATMENT and (p1.followUserId > 0 and v33))
	local v44 = if p1.status ~= Constants.QUEUED_STATE or (not (p1.followUserId > 0) or p1.queueTreatment == nil) then nil else if not v33 then v29.friendsServerIsFullWaitingToJoin else v29.friendsServerIsFullJoiningNewServer
	local v45 = ({
		Joining = v29.statusJoining,
		GameEnded = v29.statusGameEnded,
		HttpError = v29.statusHttpError
	})[p1.status]

	if p1.status == Constants.QUEUED_STATE and p1.queuePosition ~= nil then
		v45 = v29.statusQueued
	elseif v45 then
	else
		local statusText = p1.statusText
		local CoreScriptLocalization = CoreGui:FindFirstChild("CoreScriptLocalization")

		if not CoreScriptLocalization then
			v45 = statusText
		else
			local ok, result = pcall(function() -- line: 34
				-- upvalues: CoreScriptLocalization (copy), LocalizationService (copy), CoreGui (copy), statusText (copy)
				return CoreScriptLocalization:GetTranslator(LocalizationService.RobloxLocaleId):Translate(CoreGui, statusText)
			end)

			v45 = if not ok then statusText else result
		end
	end

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
		testId = "tilt-loading-screen-status-panel",
		LayoutOrder = p1.LayoutOrder
	}, {
		Status = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-center gap-small size-full-0 auto-y",
			onActivated = v39,
			stateLayer = {
				affordance = Enums.StateLayerAffordance.None
			}
		}, {
			Policy = if not p1.isSubjectToChinaPolicies then nil else React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-system-contrast",
				Text = v29.antiAddictionText
			}),
			QueueDescription = if not v44 then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-title-medium content-system-contrast",
				testId = "tilt-loading-screen-queue-description",
				Text = v44
			}),
			StatusText = if v45 == "" then nil else React.createElement(FoundationText, {
				LayoutOrder = 3,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-system-contrast",
				Text = v45
			})
		}),
		Countdown = if not v33 then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center size-full-0 auto-y"
		}, {
			ProgressBar = React.createElement(Progress, {
				testId = "tilt-loading-screen-auto-join-progress",
				shape = Enums.ProgressShape.Bar,
				value = v31
			})
		}),
		JoinNewServerAction = if not v42 then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = "col align-x-center gap-xsmall auto-xy"
		}, {
			Description = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-body-medium content-system-contrast",
				Text = v29.dontWantToWait
			}),
			Button = React.createElement(Button, {
				LayoutOrder = 2,
				testId = "tilt-loading-screen-join-new-server",
				onActivated = v41,
				text = v29.joinNewServer
			})
		}),
		JoinTheLineAction = if not v43 then nil else React.createElement(View, {
			LayoutOrder = 4,
			tag = "col align-x-center gap-xsmall auto-xy"
		}, {
			Description = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-body-medium content-system-contrast",
				Text = v29.wantToJoinYourFriend
			}),
			Button = React.createElement(Button, {
				LayoutOrder = 2,
				testId = "tilt-loading-screen-join-the-line",
				onActivated = v40,
				text = v29.joinTheLine
			})
		}),
		RobloxWordmark = if not FFlagDebugEnablePioneerUX then nil else React.createElement(FoundationImage, {
			LayoutOrder = 5,
			testId = "tilt-loading-screen-roblox-wordmark",
			Image = Constants.ROBLOX_WORDMARK_IMAGE,
			imageStyle = v28.Color.System.Contrast,
			Size = UDim2.fromOffset(v28.Size.Size_300 * Constants.ROBLOX_WORDMARK_ASPECT_RATIO, v28.Size.Size_300)
		})
	})
end

return React.memo(TiltLoadingScreenStatusPanel)
