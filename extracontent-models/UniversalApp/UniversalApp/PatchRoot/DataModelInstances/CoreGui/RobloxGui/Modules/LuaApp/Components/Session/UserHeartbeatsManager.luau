local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Modules = CoreGui.RobloxGui.Modules
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus)
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local ExperienceEventReceiver = require(Modules.LuaApp.ExperienceEventReceiver)
local AppRunService = RoactServiceTags.AppRunService
local AppUserInputService = RoactServiceTags.AppUserInputService
local MessageBus2 = MessageBus.MessageBus
local RoactNetworking = RoactServiceTags.RoactNetworking
local EventConnection = ReactUtils.EventConnection
local FFlagSignalsNavP3cEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3cEvents
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v20 = if not FFlagSignalsNavP3cEvents then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local PostUserHeartbeatsActionReport = require(Modules.LuaApp.Http.Requests.UserHeartbeats.PostUserHeartbeatsActionReport)
local PostUserHeartbeatsPulse = require(Modules.LuaApp.Http.Requests.UserHeartbeats.PostUserHeartbeatsPulse)
local selectCurrentLegacyPage = NavigationRodux.Selectors.selectCurrentLegacyPage
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute

game:DefineFastInt("UserHeartbeatsActionReportRolloutPerMyriad", 0)
game:DefineFastInt("UserHeartbeatsPulseRolloutPerMyriad", 0)

local v25 = game:DefineFastInt("UserHeartbeatsPulseIntervalSeconds", 30)
local v26 = game:DefineFastFlag("UserHeartbeatsInExperienceTracking", false)
local v27 = Roact.Component:extend("UserHeartbeatsManager")
local _ = {
	Invalid = 0,
	Foregrounded = 1,
	Backgrounded = 2,
	Idle = 3,
	InExperience = 4
}
local v29 = MessageBus2.getMessageId("Realtime", "appResume")
local v30 = MessageBus2.getMessageId("Realtime", "appStop")
local t1 = {
	mid = v29,
	validateParams = function(_) -- line: 62
		return true
	end
}
local t2 = {
	mid = v30,
	validateParams = function(_) -- line: 69
		return true
	end
}

function v27.init(p3) -- line: 74
	-- upvalues: v26 (copy), MessageBus2 (copy), ExperienceEventReceiver (copy), PostUserHeartbeatsActionReport (copy), v25 (copy), PostUserHeartbeatsPulse (copy)
	p3._isMounted = false
	p3._nextPulseTick = tick()
	p3.state = {
		activeState = 1,
		inExperience = not v26 and nil
	}
	p3._subscriber = MessageBus2.Subscriber.new()
	p3._rollout = Random.new():NextInteger(1, 10000)
	p3._isActionReportEnabled = p3._rollout <= game:GetFastInt("UserHeartbeatsActionReportRolloutPerMyriad")
	p3._isPulseEnabled = p3._rollout <= game:GetFastInt("UserHeartbeatsPulseRolloutPerMyriad")
	p3._experienceEventReceiver = if not v26 then nil else ExperienceEventReceiver.new()

	function p3.onDataModelClose() -- line: 93
		-- upvalues: p3 (copy), PostUserHeartbeatsActionReport (copy)
		if not p3._isMounted then
			return
		end

		if not p3._isActionReportEnabled then
			return
		end

		local t3 = {
			logoutActionInfo = {}
		}

		PostUserHeartbeatsActionReport(p3.props.networking, t3)
	end
	function p3.onBackgrounded() -- line: 106
		-- upvalues: p3 (copy)
		p3:setState({
			activeState = 2
		})
	end
	function p3.onForegrounded() -- line: 112
		-- upvalues: p3 (copy), v26 (copy)
		p3:setState({
			activeState = (not v26 or not p3.state.inExperience) and 1 or 4
		})
	end
	function p3.heartbeatCallback() -- line: 120
		-- upvalues: p3 (copy), v25 (copy), PostUserHeartbeatsPulse (copy)
		if not p3._isPulseEnabled then
			return
		end

		if v25 <= 0 then
			return
		end

		local timestamp = tick()

		if timestamp < p3._nextPulseTick then
			return
		end

		p3._nextPulseTick = timestamp + v25

		local currentPage = p3.props.currentPage

		PostUserHeartbeatsPulse(p3.props.networking, p3.state.activeState, currentPage.name)
	end
	function p3.onExperienceJoin() -- line: 140
		-- upvalues: p3 (copy)
		p3:setState({
			activeState = 4,
			inExperience = true
		})
	end
	function p3.onExperienceLeave() -- line: 147
		-- upvalues: p3 (copy)
		p3:setState({
			activeState = 1,
			inExperience = false
		})
	end
end
function v27.render(p4) -- line: 155
	-- upvalues: Roact (copy), EventConnection (copy)
	local runService = p4.props.runService
	local userInputService = p4.props.userInputService

	return Roact.createFragment({
		HeartbeatListener = Roact.createElement(EventConnection, {
			callback = p4.heartbeatCallback,
			event = runService.Heartbeat
		}),
		WindowFocusedListener = Roact.createElement(EventConnection, {
			callback = p4.onForegrounded,
			event = userInputService.WindowFocused
		}),
		WindowFocusLostListener = Roact.createElement(EventConnection, {
			callback = p4.onBackgrounded,
			event = userInputService.WindowFocusReleased
		})
	})
end
function v27.didMount(p5) -- line: 175
	-- upvalues: t1 (copy), t2 (copy), v26 (copy), RunService (copy), PostUserHeartbeatsActionReport (copy)
	p5._isMounted = true
	p5._subscriber:subscribe(t1, p5.onForegrounded)
	p5._subscriber:subscribe(t2, p5.onBackgrounded)

	if v26 then
		p5._onLaunchedConnection = p5._experienceEventReceiver:onLaunched(p5.onExperienceJoin)
		p5._onLeftConnection = p5._experienceEventReceiver:onLeft(p5.onExperienceLeave)
	end

	if p5._isActionReportEnabled then
		if not RunService:IsStudio() then
			game:BindToClose(p5.onDataModelClose)
		end

		local t4 = {
			loginActionInfo = {}
		}

		PostUserHeartbeatsActionReport(p5.props.networking, t4)
	end
end
function v27.didUpdate(p6, _, p8) -- line: 198
	-- upvalues: PostUserHeartbeatsActionReport (copy)
	if not p6._isActionReportEnabled then
		return
	end

	if p8.activeState ~= p6.state.activeState then
		local t5 = {
			universalAppActiveStateChangeActionInfo = {
				currentActiveState = p6.state.activeState,
				previousActiveState = p8.activeState
			}
		}

		PostUserHeartbeatsActionReport(p6.props.networking, t5)
	end
end
function v27.willUnmount(p9) -- line: 214
	-- upvalues: v26 (copy)
	p9._subscriber:unsubscribeFromAllMessages()

	if v26 then
		p9._onLaunchedConnection:disconnect()
		p9._onLeftConnection:disconnect()
		p9._experienceEventReceiver:UnsubscribeFromAllMessages()
	end

	p9._isMounted = false
end

local function mapStateToProps(p10) -- line: 226
	-- upvalues: selectCurrentLegacyPage (copy), selectCurrentLegacyRoute (copy)
	local v52 = selectCurrentLegacyPage(p10)
	local v53 = selectCurrentLegacyRoute(p10)

	return {
		currentPage = v52,
		route = v53
	}
end

local v37

if FFlagSignalsNavP3cEvents then
	local React = require(CorePackages.Packages.React)
	local Cryo = require(CorePackages.Packages.Cryo)
	local v36 = v27

	function v37(p11) -- line: 240
		-- upvalues: v20 (copy), useSignalState (copy), React (copy), v36 (copy), Cryo (copy)
		local v55 = v20(false)
		local v56 = useSignalState(v55.getCurrentPage)

		return React.createElement(v36, Cryo.Dictionary.union(p11, {
			currentPage = v56
		}))
	end
else
	v37 = RoactRodux.connect(mapStateToProps, nil)(v27)
end

return RoactServices.connect({
	networking = RoactNetworking,
	runService = AppRunService,
	userInputService = AppUserInputService
})(v37)
