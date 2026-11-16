local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local AvatarEditorService = game:GetService("AvatarEditorService")

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.init")
local module = require("@luauforge/bundled/igG")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local module2 = require("@luauforge/bundled/dxy")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local switchTab = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SwitchTab
local module3 = require("@luauforge/bundled/eda")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local remoteAvatarUpdateHandler = require("@luauforge/bundled/igH").Components.RemoteAvatarUpdateHandler
local module4 = require("@luauforge/bundled/fAN")
require("@luauforge/bundled/dHK")

local module5 = require("@luauforge/bundled/igP")
local module6 = require("@luauforge/bundled/dNc")
local module7 = require("@luauforge/bundled/igQ")
local module8 = require("@luauforge/bundled/igR")
local module9 = require("@luauforge/bundled/igS")
local module10 = require("@luauforge/bundled/igT")
local module11 = require("@luauforge/bundled/fuD")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local avatarExperienceLoaded = require("@luauforge/bundled/dHL").Actions.AvatarExperienceLoaded
require("@luauforge/bundled/dMc")

local module12 = require("@luauforge/bundled/gUQ")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(CorePackages.Packages.Signals)
local createComputed = Signals.createComputed

local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectCurrentLegacyPage = NavigationRodux.Selectors.selectCurrentLegacyPage

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow

local fFlagAXBackgroundsPersistence = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundsPersistence

local extended = Roact.PureComponent:extend("AvatarExperienceInitialization")

extended.validateProps = t.strictInterface({
	networking = t.callback,
	avatarExperienceActive = t.boolean,
	defaultBodyColorRanges = t.optional(t.table),
	getCatalogMetadata = t.callback,
	getAvatarData = t.callback,
	receivedAvatarData = t.callback,
	getProfileConfiguration = t.callback,
	getAvatarRules = t.callback,
	processAvatarRules = t.callback,
	avatarExperienceLoaded = t.callback,
	waitUntilIXPUserInit = t.callback,
	setRangesAndSliderValuesFromBodyColor3s = t.callback,
	ixpService = t.any
})

function extended:init()
	self.pendingBodyColor3s = nil

	self:setState({
		localPlayer = Players.LocalPlayer,
		userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0,
		getAvatarDataFailed = false,
		getAvatarRulesFailed = false,
		getAvatarRulesSuccess = false,
		ixpLoaded = false
	})

	self.loadedPromise = Promise.new(function(resolveLoadedPromise, p2)
		self.resolveLoadedPromise = resolveLoadedPromise
	end)

	self.retryAvatarRulesPromise = nil
	self.retryAvatarRulesCount = 0

	self.loadedPromise:andThen(function() end)

	function self.onLocalPlayerChanged()
		logger:info("onLocalPlayerChanged: {}", module.obfuscatePlayer(Players.LocalPlayer))

		if self.state.localPlayer == nil then
			self:setState({ localPlayer = Players.LocalPlayer })
		end
	end

	function self.onUserIdChanged()
		logger:info("onUserIdChanged: {}", module.obfuscatePlayer(Players.LocalPlayer))

		if self.state.userId == 0 and Players.LocalPlayer ~= nil then
			self:setState({ userId = Players.LocalPlayer.UserId })
		end
	end

	function self.onRemoteAvatarUpdate()
		self:getAvatarData():andThen(function()
			if game:GetEngineFeature("AvatarEditorServiceRefreshAvatarThumbnailEnabled") then
				AvatarEditorService:refreshAvatarThumbnails({ "AvatarHeadShot", "AvatarBust", "Avatar" })
			end
		end)
	end
end

function extended:getLoadingStatus()
	local v5 = not (self.state.localPlayer == nil) and self.state.userId ~= 0

	if not (v5 and self.state.ixpLoaded) then
		return module2.Fetching
	end

	if self.state.getAvatarRulesSuccess then
		return module2.Done
	end

	return module2.Fetching
end

function extended:render()
	local createFragment = Roact.createFragment
	local v5 = {
		LocalPlayerConn = Roact.createElement(externalEventConnection, {
			event = Players:GetPropertyChangedSignal("LocalPlayer"),
			callback = self.onLocalPlayerChanged
		}),
		UserIdConn = Players.LocalPlayer ~= nil and Roact.createElement(externalEventConnection, {
			event = Players.LocalPlayer:GetPropertyChangedSignal("UserId"),
			callback = self.onUserIdChanged
		}),
		RemoteAvatarUpdateHandler = 0
	}

	local v7 = if self:getLoadingStatus() == module2.Done then React.createElement(remoteAvatarUpdateHandler, {
		onUpdated = self.onRemoteAvatarUpdate
	}) else nil
	v5.RemoteAvatarUpdateHandler = v7
	return createFragment(v5)
end

function extended:checkHasLoaded()
	if
		self.loadedPromise:getStatus() ~= Promise.Status.Resolved
		and self:getLoadingStatus() == module2.Done
	then
		logger:info("avatarExperienceLoaded")
		self.props.avatarExperienceLoaded()
		self.resolveLoadedPromise()
	end
end

function extended:maybeSetRangesAndSliderValuesFromBodyColor3s()
	if not (self.pendingBodyColor3s ~= nil and #self.props.defaultBodyColorRanges ~= 0) then
		return
	end

	self.props.setRangesAndSliderValuesFromBodyColor3s(self.pendingBodyColor3s)
end

function extended:getAvatarData()
	return (Promise.all({ self.props.getAvatarData(self.props.networking), self.loadedPromise }):andThen(function(list)
		local item = list[1]
		logger:debug("getAvatarData results valid: {}", item ~= nil)

		if item then
			local bodyColor3s = item.bodyColor3s or {}
			self:applyAvatarDataWithModifiedBodyColor3s(
				item,
				(module11.convertBodyColor3HexesToColor3s(bodyColor3s))
			)
		end
	end):catch(function(p2)
		logger:info("getAvatarData failed: {}", p2)
		self:setState({ getAvatarDataFailed = true })
	end))
end

function extended:applyAvatarDataWithModifiedBodyColor3s(p2, pendingBodyColor3s)
	local joined = Cryo.Dictionary.join(p2, { bodyColor3s = pendingBodyColor3s })
	self.props.receivedAvatarData(joined)

	self.pendingBodyColor3s = pendingBodyColor3s
	self:maybeSetRangesAndSliderValuesFromBodyColor3s()
end

function extended:maybeStartRetryAvatarRules()
	if
		self.retryAvatarRulesPromise
		and self.retryAvatarRulesPromise:getStatus() ~= Promise.Status.Resolved
	then
		return
	end

	self.retryAvatarRulesCount += 1

	self.retryAvatarRulesPromise = Promise.delay(math.pow(2, self.retryAvatarRulesCount - 1) * 2):andThen(function()
		self:getAvatarRules()
	end)
end

function extended:getAvatarRules()
	local v5 = self.props.getAvatarRules():andThen(function(p2)
		self:setState({ getAvatarRulesSuccess = true })

		return p2
	end, function(p2)
		logger:info("getAvatarRules failed: {}", p2)
		self:setState({ getAvatarRulesFailed = true })

		self:maybeStartRetryAvatarRules()
	end)

	Promise.all({ v5, self.loadedPromise }):andThen(function(list)
		local item = list[1]
		logger:debug("getAvatarRules results valid: {}", item ~= nil)

		if item then
			self.props.processAvatarRules(item)
		end
	end)
end

function extended:checkIXPInitialized()
	if self.state.userId ~= 0 then
		local ixpService = self.props.ixpService

		self.props.waitUntilIXPUserInit(ixpService, self.state.userId):andThen(function()
			self:setState({ ixpLoaded = true })
		end)
	end
end

function extended:checkForLocalPlayer()
	local v5 = Players.LocalPlayer ~= self.state.localPlayer
	local v6 = Players.LocalPlayer and Players.LocalPlayer.UserId ~= self.state.userId

	if v5 or v6 then
		self:setState({
			localPlayer = Players.LocalPlayer,
			userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
		})
	end
end

function extended:didMount()
	self:checkForLocalPlayer()

	logger:info("AvatarExperienceInitialization:didMount")

	self.props.getCatalogMetadata(self.props.networking)
	self:getAvatarData()

	if fFlagAXBackgroundsPersistence then
		self.props.getProfileConfiguration()
	end

	self:getAvatarRules()

	self:checkIXPInitialized()
	self:checkHasLoaded()
end

function extended:didUpdate(p2, p3)
	self:checkForLocalPlayer()

	self:checkHasLoaded()

	if self.props.avatarExperienceActive and not p2.avatarExperienceActive then
		if self.state.getAvatarDataFailed then
			self:setState({ getAvatarDataFailed = false })

			self:getAvatarData()
		end

		if self.state.getAvatarRulesFailed then
			self:setState({ getAvatarRulesFailed = false })

			self:getAvatarRules()
		end
	end

	if self.state.userId ~= p3.userId then
		self:checkIXPInitialized()
	end

	if #p2.defaultBodyColorRanges == 0 and #self.props.defaultBodyColorRanges ~= 0 then
		self:maybeSetRangesAndSliderValuesFromBodyColor3s()
	end
end

function extended:willUnmount()
	logger:info("AvatarExperienceInitialization:willUnmount")

	if self.loadedPromise:getStatus() ~= Promise.Status.Resolved then
		self.loadedPromise:cancel()
	end

	if
		self.retryAvatarRulesPromise
		and self.retryAvatarRulesPromise:getStatus() ~= Promise.Status.Resolved
	then
		self.retryAvatarRulesPromise:cancel()
		self.retryAvatarRulesPromise = nil
	end
end

local function mapStateToProps(p2, p3)
	local v5

	if not fFlagSignalsNavP3gAvatarExperience then
		local v6 = selectCurrentLegacyPage(p2)
		v5 = v6.name == switchTab.AvatarExperienceTab or v6.name == avatarScreen.AvatarExperienceRoot
	end

	return {
		defaultBodyColorRanges = p2.AvatarExperience.AvatarEditor.DefaultBodyColorRanges,
		avatarExperienceActive = v5
	}
end

local function mapDispatchToProps(callback)
	return {
		getAvatarData = function(p2)
			return callback(module5(p2, fFlagAXModeratedItemsFlow and true or nil))
		end,
		receivedAvatarData = function(p2)
			return callback(module6(p2))
		end,
		getProfileConfiguration = function()
			return callback(module8)
		end,
		getAvatarRules = function()
			return callback(module7)
		end,
		processAvatarRules = function(p2)
			return callback(module9(p2))
		end,
		avatarExperienceLoaded = function()
			return callback(avatarExperienceLoaded())
		end,
		waitUntilIXPUserInit = function(p2, p3)
			return callback(module4(p2, p3))
		end,
		getCatalogMetadata = function(p2)
			return callback(module10(p2))
		end,
		setRangesAndSliderValuesFromBodyColor3s = function(p2)
			callback(module12(p2))
		end
	}
end

local v5 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

local v6 = roactServices.connect({ networking = module3 })(v5)

if fFlagSignalsNavP3gAvatarExperience then
	local v7 = v6

	local function AvatarExperienceInitializationWithSignals(p2)
		local legacyNavigationStore = getLegacyNavigationStore(false)
		local v9 = useSignalState((React.useMemo(function()
			return createComputed(function(p3): boolean
				local currentPageName = legacyNavigationStore.getCurrentPageName(p3)
				return currentPageName == switchTab.AvatarExperienceTab
					or currentPageName == avatarScreen.AvatarExperienceRoot
			end)
		end, { legacyNavigationStore })))
		return Roact.createElement(v7, Cryo.Dictionary.join(p2, {
			avatarExperienceActive = v9
		}))
	end

	v6 = React.memo(AvatarExperienceInitializationWithSignals)
end

return function(p2)
	return Roact.createElement(RoactAppExperiment.Consumer, {
		render = function(p3)
			local joined = Cryo.Dictionary.join(p2, { ixpService = p3 })

			return Roact.createElement(v6, joined)
		end
	})
end
