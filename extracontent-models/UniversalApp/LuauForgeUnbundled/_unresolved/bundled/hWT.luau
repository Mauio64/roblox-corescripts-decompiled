local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/fBY")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local Roact = require(CorePackages.Packages.Roact)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local module5 = require("@luauforge/bundled/hWU")

local appRunService = RoactServiceTags.AppRunService
local appUserInputService = RoactServiceTags.AppUserInputService
local messageBus = module.MessageBus
local roactNetworking = RoactServiceTags.RoactNetworking

local eventConnection = ReactUtils.EventConnection
local fFlagSignalsNavP3cEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3cEvents

local getLegacyNavigationStore = if fFlagSignalsNavP3cEvents then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local module6 = require("@luauforge/bundled/hWV")
local module7 = require("@luauforge/bundled/hWW")
local selectCurrentLegacyPage = NavigationRodux.Selectors.selectCurrentLegacyPage
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute

game:DefineFastInt("UserHeartbeatsActionReportRolloutPerMyriad", 0)
game:DefineFastInt("UserHeartbeatsPulseRolloutPerMyriad", 0)
local defineFastInt = game:DefineFastInt("UserHeartbeatsPulseIntervalSeconds", 30)
local defineFastFlag = game:DefineFastFlag("UserHeartbeatsInExperienceTracking", false)

local extended = Roact.Component:extend("UserHeartbeatsManager")

local v5 = {
	Invalid = 0,
	Foregrounded = 1,
	Backgrounded = 2,
	Idle = 3,
	InExperience = 4
}

local v6 = {
	mid = messageBus.getMessageId("Realtime", "appResume"),
	validateParams = function(p2): boolean
		return true
	end
}
local v7 = {
	mid = messageBus.getMessageId("Realtime", "appStop"),
	validateParams = function(p2): boolean
		return true
	end
}

function extended:init()
	self._isMounted = false
	self._nextPulseTick = tick()

	self.state = {
		activeState = 1,
		inExperience = if defineFastFlag then false else nil
	}

	self._subscriber = messageBus.Subscriber.new()

	self._rollout = Random.new():NextInteger(1, 10000)
	self._isActionReportEnabled = self._rollout <= game:GetFastInt("UserHeartbeatsActionReportRolloutPerMyriad")
	self._isPulseEnabled = self._rollout <= game:GetFastInt("UserHeartbeatsPulseRolloutPerMyriad")

	local v10 = if defineFastFlag then module5.new() else nil
	self._experienceEventReceiver = v10

	function self.onDataModelClose()
		if not (self._isMounted and self._isActionReportEnabled) then
			return
		end

		module6(self.props.networking, { logoutActionInfo = {} })
	end

	function self.onBackgrounded()
		self:setState({ activeState = 2 })
	end

	function self.onForegrounded()
		self:setState({
			activeState = defineFastFlag and self.state.inExperience and 4 or 1
		})
	end

	function self.heartbeatCallback()
		if not self._isPulseEnabled or defineFastInt <= 0 then
			return
		end

		local now = tick()

		if now < self._nextPulseTick then
			return
		end

		self._nextPulseTick = now + defineFastInt

		local v11 = if fFlagSignalsNavP3cEvents then getLegacyNavigationStore(false).getCurrentPage(false) else self.props.currentPage
		module7(self.props.networking, self.state.activeState, v11.name)
	end

	function self.onExperienceJoin()
		self:setState({ activeState = 4, inExperience = true })
	end

	function self.onExperienceLeave()
		self:setState({ activeState = 1, inExperience = false })
	end
end

function extended.render(props)
	local runService = props.props.runService
	local userInputService = props.props.userInputService

	return Roact.createFragment({
		HeartbeatListener = Roact.createElement(eventConnection, {
			callback = props.heartbeatCallback,
			event = runService.Heartbeat
		}),
		WindowFocusedListener = Roact.createElement(eventConnection, {
			callback = props.onForegrounded,
			event = userInputService.WindowFocused
		}),
		WindowFocusLostListener = Roact.createElement(eventConnection, {
			callback = props.onBackgrounded,
			event = userInputService.WindowFocusReleased
		})
	})
end

function extended:didMount()
	self._isMounted = true

	self._subscriber:subscribe(v6, self.onForegrounded)
	self._subscriber:subscribe(v7, self.onBackgrounded)

	if defineFastFlag then
		self._onLaunchedConnection = self._experienceEventReceiver:onLaunched(self.onExperienceJoin)
		self._onLeftConnection = self._experienceEventReceiver:onLeft(self.onExperienceLeave)
	end

	if self._isActionReportEnabled then
		if not RunService:IsStudio() then
			game:BindToClose(self.onDataModelClose)
		end

		module6(self.props.networking, { loginActionInfo = {} })
	end
end

function extended:didUpdate(p2, p3)
	if not self._isActionReportEnabled then
		return
	end

	if p3.activeState ~= self.state.activeState then
		local v8 = {
			universalAppActiveStateChangeActionInfo = {
				currentActiveState = self.state.activeState,
				previousActiveState = p3.activeState
			}
		}

		module6(self.props.networking, v8)
	end
end

function extended:willUnmount()
	self._subscriber:unsubscribeFromAllMessages()

	if defineFastFlag then
		self._onLaunchedConnection:disconnect()
		self._onLeftConnection:disconnect()
		self._experienceEventReceiver:UnsubscribeFromAllMessages()
	end

	self._isMounted = false
end

local function mapStateToProps(p2)
	return {
		currentPage = selectCurrentLegacyPage(p2),
		route = selectCurrentLegacyRoute(p2)
	}
end

if not fFlagSignalsNavP3cEvents then
	extended = useSheetNavigation.connect(mapStateToProps, nil)(extended)
end

return roactServices.connect({
	networking = roactNetworking,
	runService = appRunService,
	userInputService = appUserInputService
})(extended)
