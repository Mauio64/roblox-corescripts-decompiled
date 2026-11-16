local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local sessionType = require("@luauforge/bundled/foF").SessionType
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute
local selectCurrentLegacyPage = NavigationRodux.Selectors.selectCurrentLegacyPage
local hasPageInCurrentRoute = require("@luauforge/bundled/fXq").hasPageInCurrentRoute
local reportWarning = require("@luauforge/bundled/dwD").Points.reportWarning

local fFlagSignalsNavP3cEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3cEvents

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3cEvents then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local module2 = require("@luauforge/bundled/dCo")
local module3 = require("@luauforge/bundled/hWI")
local module4 = require("@luauforge/bundled/hWR")

local function computeLevel2SessionsFromRoute_deprecated(list)
	if module4 then
		error("computeLevel2SessionsFromRoute_deprecated must not be called when FFlagSessionResolveTagFromMap is enabled")
	end

	local level2a = sessionType.StructuralIdentifier.Level2a
	local level2b = sessionType.StructuralIdentifier.Level2b
	local level2SessionsFromRoute_deprecated = {}
	local v5 = false

	for i = #list, 1, -1 do
		local name = list[i].name

		local v6 = sessionType.Tag.Level2a[name]
		local v7 = sessionType.Tag.Level2b[name]

		if v6 then
			level2SessionsFromRoute_deprecated[level2a] = list[i]
			break
		end

		if v5 or not v7 then
			continue
		end

		level2SessionsFromRoute_deprecated[level2b] = list[i]
		v5 = true
	end

	local v6 = { name = sessionType.Tag.Level2a.Unknown, detail = nil }

	level2SessionsFromRoute_deprecated[level2a] = level2SessionsFromRoute_deprecated[level2a] or v6
	return level2SessionsFromRoute_deprecated
end

local function computeLevel2SessionsFromRoute(list, p2)
	local level2a = sessionType.StructuralIdentifier.Level2a
	local level2b = sessionType.StructuralIdentifier.Level2b
	local level2SessionsFromRoute = {}
	local v5 = false

	for i = #list, 1, -1 do
		local item = list[i]

		if not (p2 == nil or not p2[item.name]) then
			continue
		end

		local v6 = sessionType.Tag.Level2a[item.name]
		local v7 = sessionType.Tag.Level2b[item.name]

		if v6 then
			level2SessionsFromRoute[level2a] = { name = v6, detail = item.detail }

			if v7 and not v5 then
				level2SessionsFromRoute[level2b] = { name = v7, detail = item.detail }
			end

			break
		elseif v7 and not v5 then
			level2SessionsFromRoute[level2b] = { name = v7, detail = item.detail }
			v5 = true
		end
	end

	if not level2SessionsFromRoute[level2a] then
		level2SessionsFromRoute[level2a] = {
			name = sessionType.Tag.Level2a.Unknown,
			detail = nil
		}
	end

	if not level2SessionsFromRoute[level2b] then
		level2SessionsFromRoute[level2b] = {
			name = level2SessionsFromRoute[level2a].name .. "Page",
			detail = nil
		}
	end

	return level2SessionsFromRoute
end

local extended = Roact.Component:extend("SessionManager")

function extended:init()
	function self.updateGameSearchSession()
		local sessionService = self.props.sessionService
		local v5

		if fFlagSignalsNavP3cEvents then
			v5 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		else
			v5 = self.props.currentRoute
		end

		if sessionService == nil then
			mutedError("SessionManager requires valid SessionService.")
		elseif not hasPageInCurrentRoute(v5, appPage.SearchPage, nil) then
			sessionService:RemoveSession(sessionType.StructuralIdentifier.GameSearchAutocomplete)
			sessionService:RemoveSession(sessionType.StructuralIdentifier.OmniSearch)
		end
	end

	function self.updateGameDetailSourceSession()
		local sessionService = self.props.sessionService
		local v5

		if fFlagSignalsNavP3cEvents then
			v5 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		else
			v5 = self.props.currentRoute
		end

		local loggingProtocol = self.props.loggingProtocol

		if
			hasPageInCurrentRoute(v5, appPage.GameDetail, nil)
			or hasPageInCurrentRoute(v5, appPage.ExperienceDetail, nil)
		then
			if not sessionService:SessionExists(sessionType.StructuralIdentifier.GameDetailSource) then
				local v9

				if v5 then
					v9 = ""

					for i = 1, #v5 do
						v9 = `{v5[i].name};{v9}`
					end
				else
					v9 = "No currentRoute!"
				end

				reportWarning(
					loggingProtocol,
					"Session",
					`No GameDetailSource session for Game Details page. Pages: {v9}`
				)
			end
		else
			if sessionService:SessionExists(sessionType.StructuralIdentifier.GameDetailSource) then
				local v9

				if v5 then
					v9 = ""

					for i = 1, #v5 do
						v9 = `{v5[i].name};{v9}`
					end
				else
					v9 = "No currentRoute!"
				end

				reportWarning(
					loggingProtocol,
					"Session",
					`GameDetailSource session exists but no Game Details page open. Pages: {v9}`
				)
			end

			sessionService:RemoveSession(sessionType.StructuralIdentifier.GameDetailSource)
		end
	end

	function self.updateSessionService(options, options2, p2, options3)
		local sessionService = self.props.sessionService

		local level1 = sessionType.StructuralIdentifier.Level1
		local level2a = sessionType.StructuralIdentifier.Level2a
		local level2b = sessionType.StructuralIdentifier.Level2b

		local v5 = p2 or { name = sessionType.Tag.Level2a.Unknown }
		local v6 = options3 or {}
		local v7 = options or {}
		local v8 = options2 or {}

		if not (module3 or sessionService:SessionExists(level1)) then
			sessionService:SetSession(sessionService:GetRootSID(), level1, sessionType.Tag.Level1.Default)
			sessionService:SetMetadata(level1, sessionType.Metadata.User.UserId, "Unknown")
		end

		if v5.name ~= v7.name or v6.name ~= v8.name then
			sessionService:RemoveSessionsWithMetadataKey(sessionType.Metadata.GamePlay.DeleteOnGameLeave)
		end

		if v5.detail ~= v7.detail or v5.name ~= v7.name then
			if sessionService:SessionExists(level2a) then
				sessionService:ReplaceSession(level2a, v5.name)
			else
				sessionService:SetSession(level1, level2a, v5.name)
			end

			if v6.name == nil and v8.name == nil then
				sessionService:SetSession(level2a, level2b, v5.name .. "Page")
			end
		end

		if v6.detail ~= v8.detail or v6.name ~= v8.name then
			if sessionService:SessionExists(level2b) then
				sessionService:ReplaceSession(level2b, v6.name or v5.name .. "Page")
			else
				sessionService:SetSession(level2a, level2b, v6.name or v5.name .. "Page")
			end
		end

		if
			self.props.onSessionsUpdated ~= nil
			and (v5.name ~= v7.name or v5.detail ~= v7.detail or v6.name ~= v8.name or v6.detail ~= v8.detail)
		then
			self.props.onSessionsUpdated()
		end
	end

	self:setState({
		RNLevel2a = { name = module2.GetDefaultAppPage() },
		RNLevel2b = {}
	})

	function self._processRouteSignal(lastRoute, p2)
		self._lastRoute = lastRoute

		if p2 == nil and self.props.getL2Exclusions ~= nil then
			p2 = self.props.getL2Exclusions(false, lastRoute)
		end

		local v5

		if module4 then
			v5 = computeLevel2SessionsFromRoute
		else
			v5 = computeLevel2SessionsFromRoute_deprecated
		end

		local v6 = v5(lastRoute, p2) or {}
		self:setState({
			RNLevel2a = v6[sessionType.StructuralIdentifier.Level2a],
			RNLevel2b = v6[sessionType.StructuralIdentifier.Level2b] or {}
		})
	end
end

function extended.render(p2) end

function extended:didMount()
	self.updateGameSearchSession()
	self.updateGameDetailSourceSession()

	self.updateSessionService(nil, nil, self.state.RNLevel2a, self.state.RNLevel2b)

	if self.props.getL2Exclusions ~= nil then
		self._disposeExclusionsEffect = Signals.createEffect(function(p2)
			local l2Exclusions = self.props.getL2Exclusions(p2, self._lastRoute)

			if self._lastRoute ~= nil then
				self._processRouteSignal(self._lastRoute, l2Exclusions)
			end
		end)
	end

	if self.props.connectRouteSignal then
		self._routeChangedConnection = self.props.connectRouteSignal(self._processRouteSignal)
	else
		mutedError("Did not find a listener function in props, Session will not update")
	end
end

function extended:didUpdate(data, p2)
	local v5, v6

	if fFlagSignalsNavP3cEvents then
		v5 = self.props.currentPageName
		v6 = data.currentPageName
	else
		v5 = not self.props.currentPage and "" or self.props.currentPage.name
		v6 = if data and data.currentPage then data.currentPage.name else ""
	end

	if v5 ~= v6 then
		self.updateGameSearchSession()
		self.updateGameDetailSourceSession()
	end

	self.updateSessionService(p2.RNLevel2a, p2.RNLevel2b, self.state.RNLevel2a, self.state.RNLevel2b)

	if data.connectRouteSignal ~= self.props.connectRouteSignal then
		if self._routeChangedConnection ~= nil then
			self._routeChangedConnection:disconnect()
			self._routeChangedConnection = nil
		end

		if self.props.connectRouteSignal then
			self._routeChangedConnection = self.props.connectRouteSignal(self._processRouteSignal)
		end
	end
end

function extended:willUnmount()
	if self._routeChangedConnection ~= nil then
		self._routeChangedConnection:disconnect()
		self._routeChangedConnection = nil
	end

	if self._disposeExclusionsEffect ~= nil then
		self._disposeExclusionsEffect()
		self._disposeExclusionsEffect = nil
	end
end

local v5

if fFlagSignalsNavP3cEvents then
	local React = require(CorePackages.Packages.React)
	local Cryo = require(CorePackages.Packages.Cryo)
	v5 = React.memo(function(p2)
		local v6 = useSignalState(getLegacyNavigationStore(false).getCurrentPageName)
		return React.createElement(extended, Cryo.Dictionary.union(p2, {
			currentPageName = v6
		}))
	end)
else
	v5 = RoactRodux.connect(function(p2, p3)
		return {
			currentPage = selectCurrentLegacyPage(p2),
			currentRoute = selectCurrentLegacyRoute(p2)
		}
	end)(extended)
end

return roactServices.connect({
	sessionService = appSessionService,
	loggingProtocol = appLogging
})(v5)
