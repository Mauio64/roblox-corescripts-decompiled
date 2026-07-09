local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute
local selectCurrentLegacyPage = NavigationRodux.Selectors.selectCurrentLegacyPage
local hasPageInCurrentRoute = require(CorePackages.Workspace.Packages.DiscoveryRouting).hasPageInCurrentRoute
local reportWarning = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Points.reportWarning
local FFlagSignalsNavP3cEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3cEvents
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v17 = if not FFlagSignalsNavP3cEvents then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local FFlagEnableL1SessionStateEngineOwned = require(Modules.LuaApp.Flags.FFlagEnableL1SessionStateEngineOwned)

local function computeLevel2SessionsFromRoute(p1) -- line: 33
	-- upvalues: SessionType (copy)
	local Level2a = SessionType.StructuralIdentifier.Level2a
	local Level2b = SessionType.StructuralIdentifier.Level2b
	local t1 = {}
	local v31 = false

	for i = #p1, 1, -1 do
		local name = p1[i].name
		local v34 = SessionType.Tag.Level2a[name]
		local v35 = SessionType.Tag.Level2b[name]

		if v34 then
			t1[Level2a] = p1[i]

			break
		end

		if not v31 and v35 then
			t1[Level2b] = p1[i]
			v31 = true
		end
	end

	local t2 = {
		detail = nil,
		name = SessionType.Tag.Level2a.Unknown
	}

	t1[Level2a] = t1[Level2a] or t2

	return t1
end

local v22 = Roact.Component:extend("SessionManager")

function v22.init(p2) -- line: 83
	-- upvalues: mutedError (copy), hasPageInCurrentRoute (copy), AppPage (copy), SessionType (copy), reportWarning (copy), FFlagEnableL1SessionStateEngineOwned (copy), FlagSettings (copy), computeLevel2SessionsFromRoute (copy)
	function p2.updateGameSearchSession() -- line: 84
		-- upvalues: p2 (copy), mutedError (copy), hasPageInCurrentRoute (copy), AppPage (copy), SessionType (copy)
		local sessionService = p2.props.sessionService
		local currentRoute = p2.props.currentRoute

		if sessionService == nil then
			mutedError("SessionManager requires valid SessionService.")

			return
		end

		if not hasPageInCurrentRoute(currentRoute, AppPage.SearchPage, nil) then
			sessionService:RemoveSession(SessionType.StructuralIdentifier.GameSearchAutocomplete)
			sessionService:RemoveSession(SessionType.StructuralIdentifier.OmniSearch)
		end
	end
	function p2.updateGameDetailSourceSession() -- line: 100
		-- upvalues: p2 (copy), hasPageInCurrentRoute (copy), AppPage (copy), SessionType (copy), reportWarning (copy)
		local sessionService = p2.props.sessionService
		local currentRoute = p2.props.currentRoute
		local loggingProtocol = p2.props.loggingProtocol

		if hasPageInCurrentRoute(currentRoute, AppPage.GameDetail, nil) or hasPageInCurrentRoute(currentRoute, AppPage.ExperienceDetail, nil) then
			if not sessionService:SessionExists(SessionType.StructuralIdentifier.GameDetailSource) then
				local v58 = reportWarning
				local s1

				if not currentRoute then
					s1 = "No currentRoute!"
				else
					s1 = ""

					for i = 1, #currentRoute do
						s1 = `{ currentRoute[i].name };{ s1 }`
					end
				end

				v58(loggingProtocol, "Session", `No GameDetailSource session for Game Details page. Pages: { s1 }`)

				return
			end
		else
			if sessionService:SessionExists(SessionType.StructuralIdentifier.GameDetailSource) then
				local v61 = reportWarning
				local s2

				if not currentRoute then
					s2 = "No currentRoute!"
				else
					s2 = ""

					for i = 1, #currentRoute do
						s2 = `{ currentRoute[i].name };{ s2 }`
					end
				end

				v61(loggingProtocol, "Session", `GameDetailSource session exists but no Game Details page open. Pages: { s2 }`)
			end

			sessionService:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end
	function p2.updateSessionService(p3, p4, p5, p6) -- line: 130
		-- upvalues: p2 (copy), SessionType (copy), FFlagEnableL1SessionStateEngineOwned (copy)
		local sessionService = p2.props.sessionService
		local Level1 = SessionType.StructuralIdentifier.Level1
		local Level2a = SessionType.StructuralIdentifier.Level2a
		local Level2b = SessionType.StructuralIdentifier.Level2b
		local v72 = p5 or {
			name = SessionType.Tag.Level2a.Unknown
		}
		local v73 = p6 or {}
		local v74 = p3 or {}
		local v75 = p4 or {}

		if not FFlagEnableL1SessionStateEngineOwned and not sessionService:SessionExists(Level1) then
			sessionService:SetSession(sessionService:GetRootSID(), Level1, SessionType.Tag.Level1.Default)
			sessionService:SetMetadata(Level1, SessionType.Metadata.User.UserId, "Unknown")
		end

		if v72.name ~= v74.name or v73.name ~= v75.name then
			sessionService:RemoveSessionsWithMetadataKey(SessionType.Metadata.GamePlay.DeleteOnGameLeave)
		end

		if v72.detail ~= v74.detail or v72.name ~= v74.name then
			if sessionService:SessionExists(Level2a) then
				sessionService:ReplaceSession(Level2a, v72.name)
			else
				sessionService:SetSession(Level1, Level2a, v72.name)
			end

			if v73.name == nil and v75.name == nil then
				sessionService:SetSession(Level2a, Level2b, v72.name .. "Page")
			end
		end

		if v73.detail ~= v75.detail or v73.name ~= v75.name then
			if sessionService:SessionExists(Level2b) then
				sessionService:ReplaceSession(Level2b, v73.name or v72.name .. "Page")

				return
			end

			sessionService:SetSession(Level2a, Level2b, v73.name or v72.name .. "Page")
		end
	end

	p2:setState({
		RNLevel2a = {
			name = FlagSettings.GetDefaultAppPage()
		},
		RNLevel2b = {}
	})

	function p2._processRouteSignal(p7) -- line: 196
		-- upvalues: computeLevel2SessionsFromRoute (copy), p2 (copy), SessionType (copy)
		local v77 = computeLevel2SessionsFromRoute(p7) or {}

		p2:setState({
			RNLevel2a = v77[SessionType.StructuralIdentifier.Level2a],
			RNLevel2b = v77[SessionType.StructuralIdentifier.Level2b] or {}
		})
	end
end
function v22.render(_) -- line: 206
end
function v22.didMount(p9) -- line: 208
	-- upvalues: mutedError (copy)
	p9.updateGameSearchSession()
	p9.updateGameDetailSourceSession()
	p9.updateSessionService(nil, nil, p9.state.RNLevel2a, p9.state.RNLevel2b)

	if p9.props.connectRouteSignal then
		p9._routeChangedConnection = p9.props.connectRouteSignal(p9._processRouteSignal)

		return
	end

	mutedError("Did not find a listener function in props, Session will not update")
end
function v22.didUpdate(p10, p11, p12) -- line: 224
	if (not p10.props.currentPage and "" or p10.props.currentPage.name) ~= ((not p11 or not p11.currentPage) and "" or p11.currentPage.name) then
		p10.updateGameSearchSession()
		p10.updateGameDetailSourceSession()
	end

	p10.updateSessionService(p12.RNLevel2a, p12.RNLevel2b, p10.state.RNLevel2a, p10.state.RNLevel2b)

	if p11.connectRouteSignal ~= p10.props.connectRouteSignal then
		if p10._routeChangedConnection ~= nil then
			p10._routeChangedConnection:disconnect()
			p10._routeChangedConnection = nil
		end

		if p10.props.connectRouteSignal then
			p10._routeChangedConnection = p10.props.connectRouteSignal(p10._processRouteSignal)
		end
	end
end
function v22.willUnmount(p13) -- line: 249
	if p13._routeChangedConnection ~= nil then
		p13._routeChangedConnection:disconnect()
		p13._routeChangedConnection = nil
	end
end

local v26

if FFlagSignalsNavP3cEvents then
	local React = require(CorePackages.Packages.React)
	local Cryo = require(CorePackages.Packages.Cryo)
	local v25 = v22

	function v26(p14) -- line: 261
		-- upvalues: v17 (copy), useSignalState (copy), React (copy), v25 (copy), Cryo (copy)
		local v48 = v17(false)
		local v49 = useSignalState(v48.getCurrentLegacyRoute)
		local v50 = v49[#v49]

		return React.createElement(v25, Cryo.Dictionary.union(p14, {
			currentPage = v50,
			currentRoute = v49
		}))
	end
else
	v26 = RoactRodux.connect(function(p15, _) -- line: 275
		-- upvalues: selectCurrentLegacyPage (copy), selectCurrentLegacyRoute (copy)
		return {
			currentPage = selectCurrentLegacyPage(p15),
			currentRoute = selectCurrentLegacyRoute(p15)
		}
	end)(v22)
end

return RoactServices.connect({
	sessionService = AppSessionService,
	loggingProtocol = AppLogging
})(v26)
