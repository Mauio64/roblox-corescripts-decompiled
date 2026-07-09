local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local AvatarEditorService = game:GetService("AvatarEditorService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local v5 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.init")
local LogHelpers = require(Modules.AvatarExperience.Common.Debug.LogHelpers)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local SwitchTab = require(CorePackages.Workspace.Packages.RobloxAppEnums).SwitchTab
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local RemoteAvatarUpdateHandler = require(CorePackages.Workspace.Packages.AvatarExperienceInitialization).Components.RemoteAvatarUpdateHandler
local WaitUntilIXPUserInit = require(Modules.LuaApp.Thunks.WaitUntilIXPUserInit)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local GetAvatarData = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetAvatarData)
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local GetAvatarRules = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetAvatarRules)
local GetProfileConfiguration = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetProfileConfiguration)
local ProcessAvatarRules = require(Modules.AvatarExperience.AvatarEditor.Thunks.ProcessAvatarRules)
local GetCatalogMetadata = require(Modules.AvatarExperience.Catalog.Thunks.GetCatalogMetadata)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AvatarExperienceLoaded = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.AvatarExperienceLoaded
local PreventSaveAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.PreventSaveAvatar)

require(Modules.AvatarExperience.Common.Types)

local SetRangesAndSliderValuesFromBodyColor3s = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetRangesAndSliderValuesFromBodyColor3s)
local selectCurrentLegacyPage = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors.selectCurrentLegacyPage
local v33 = game:DefineFastInt("AXGetAvatarDataThrottleInterval", 90000)
local GetFFlagAXEnableAvatarDataRefresh = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableAvatarDataRefresh)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXBackgroundsPersistence = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBackgroundsPersistence
local v37 = Roact.PureComponent:extend("AvatarExperienceInitialization")

v37.validateProps = t.strictInterface({
	networking = t.callback,
	avatarExperienceActive = t.boolean,
	navigation = if not GetFFlagAXEnableAvatarDataRefresh() then nil else t.table,
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
	setPreventSaveAvatar = if not GetFFlagAXEnableAvatarDataRefresh() then nil else t.callback,
	ixpService = t.any
})

function v37.init(p1) -- line: 95
	-- upvalues: Players (copy), Promise (copy), v5 (copy), LogHelpers (copy), AvatarEditorService (copy)
	p1.pendingBodyColor3s = nil
	p1:setState({
		getAvatarDataFailed = false,
		getAvatarRulesFailed = false,
		getAvatarRulesSuccess = false,
		ixpLoaded = false,
		localPlayer = Players.LocalPlayer,
		userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	})
	p1.loadedPromise = Promise.new(function(resolve, _) -- line: 107
		-- upvalues: p1 (copy)
		p1.resolveLoadedPromise = resolve
	end)
	p1.retryAvatarRulesPromise = nil
	p1.retryAvatarRulesCount = 0
	p1.loadedPromise:andThen(function() -- line: 115
	end)

	function p1.onLocalPlayerChanged() -- line: 117
		-- upvalues: v5 (copy), LogHelpers (copy), Players (copy), p1 (copy)
		v5:info("onLocalPlayerChanged: {}", LogHelpers.obfuscatePlayer(Players.LocalPlayer))

		if p1.state.localPlayer == nil then
			p1:setState({
				localPlayer = Players.LocalPlayer
			})
		end
	end
	function p1.onUserIdChanged() -- line: 126
		-- upvalues: v5 (copy), LogHelpers (copy), Players (copy), p1 (copy)
		v5:info("onUserIdChanged: {}", LogHelpers.obfuscatePlayer(Players.LocalPlayer))

		if p1.state.userId == 0 and Players.LocalPlayer ~= nil then
			p1:setState({
				userId = Players.LocalPlayer.UserId
			})
		end
	end
	function p1.onRemoteAvatarUpdate() -- line: 135
		-- upvalues: p1 (copy), AvatarEditorService (copy)
		p1:getAvatarData():andThen(function() -- line: 136
			-- upvalues: AvatarEditorService (copy)
			if game:GetEngineFeature("AvatarEditorServiceRefreshAvatarThumbnailEnabled") then
				AvatarEditorService:refreshAvatarThumbnails({
					"AvatarHeadShot",
					"AvatarBust",
					"Avatar"
				})
			end
		end)
	end
end
function v37.getLoadingStatus(p3) -- line: 144
	-- upvalues: RetrievalStatus (copy)
	if p3.state.localPlayer == nil or p3.state.userId == 0 then
		return RetrievalStatus.Fetching
	end

	if not p3.state.ixpLoaded then
		return RetrievalStatus.Fetching
	end

	if not p3.state.getAvatarRulesSuccess then
		return RetrievalStatus.Fetching
	end

	return RetrievalStatus.Done
end
function v37.render(p4) -- line: 163
	-- upvalues: Roact (copy), ExternalEventConnection (copy), Players (copy), RetrievalStatus (copy), React (copy), RemoteAvatarUpdateHandler (copy)
	return Roact.createFragment({
		LocalPlayerConn = Roact.createElement(ExternalEventConnection, {
			event = Players:GetPropertyChangedSignal("LocalPlayer"),
			callback = p4.onLocalPlayerChanged
		}),
		UserIdConn = Players.LocalPlayer ~= nil and Roact.createElement(ExternalEventConnection, {
			event = Players.LocalPlayer:GetPropertyChangedSignal("UserId"),
			callback = p4.onUserIdChanged
		}),
		RemoteAvatarUpdateHandler = if p4:getLoadingStatus() ~= RetrievalStatus.Done then nil else React.createElement(RemoteAvatarUpdateHandler, {
			onUpdated = p4.onRemoteAvatarUpdate
		})
	})
end
function v37.checkHasLoaded(p5) -- line: 179
	-- upvalues: Promise (copy), RetrievalStatus (copy), v5 (copy)
	if p5.loadedPromise:getStatus() ~= Promise.Status.Resolved and p5:getLoadingStatus() == RetrievalStatus.Done then
		v5:info("avatarExperienceLoaded")
		p5.props.avatarExperienceLoaded()
		p5.resolveLoadedPromise()
	end
end
function v37.maybeSetRangesAndSliderValuesFromBodyColor3s(p6) -- line: 189
	if p6.pendingBodyColor3s == nil then
		return
	end

	if #p6.props.defaultBodyColorRanges == 0 then
		return
	end

	p6.props.setRangesAndSliderValuesFromBodyColor3s(p6.pendingBodyColor3s)
end
function v37.getAvatarData(t1: {[any]: any}, b1: boolean?) -- line: 205
	-- upvalues: Promise (copy), v5 (copy), GetFFlagAXEnableAvatarDataRefresh (copy), Utils (copy)
	return (Promise.all({
		t1.props.getAvatarData(t1.props.networking),
		t1.loadedPromise
	}):andThen(function(p7) -- line: 212
		-- upvalues: v5 (copy), GetFFlagAXEnableAvatarDataRefresh (copy), b1 (copy), t1 (copy), Utils (copy)
		local v79 = p7[1]

		v5:debug("getAvatarData results valid: {}", v79 ~= nil)

		if v79 then
			if GetFFlagAXEnableAvatarDataRefresh() and b1 then
				t1.props.setPreventSaveAvatar(true)
			end

			local v80 = v79.bodyColor3s or {}
			local v81 = Utils.convertBodyColor3HexesToColor3s(v80)

			t1:applyAvatarDataWithModifiedBodyColor3s(v79, v81)
		end
	end):catch(function(p8) -- line: 228
		-- upvalues: v5 (copy), t1 (copy)
		v5:info("getAvatarData failed: {}", p8)
		t1:setState({
			getAvatarDataFailed = true
		})
	end))
end
function v37.applyAvatarDataWithModifiedBodyColor3s(p9, p10, p11) -- line: 237
	-- upvalues: Cryo (copy)
	local t2 = {
		bodyColor3s = p11
	}
	local v53 = Cryo.Dictionary.join(p10, t2)

	p9.props.receivedAvatarData(v53)
	p9.pendingBodyColor3s = p11
	p9:maybeSetRangesAndSliderValuesFromBodyColor3s()
end
function v37.maybeStartRetryAvatarRules(p12) -- line: 259
	-- upvalues: Promise (copy)
	if p12.retryAvatarRulesPromise and p12.retryAvatarRulesPromise:getStatus() ~= Promise.Status.Resolved then
		return
	end

	p12.retryAvatarRulesCount = p12.retryAvatarRulesCount + 1
	p12.retryAvatarRulesPromise = Promise.delay(math.pow(2, p12.retryAvatarRulesCount - 1) * 2):andThen(function() -- line: 268
		-- upvalues: p12 (copy)
		p12:getAvatarRules()
	end)
end
function v37.getAvatarRules(p13) -- line: 273
	-- upvalues: v5 (copy), Promise (copy)
	local v56 = p13.props.getAvatarRules():andThen(function(p14) -- line: 276
		-- upvalues: p13 (copy)
		p13:setState({
			getAvatarRulesSuccess = true
		})

		return p14
	end, function(p15) -- line: 282
		-- upvalues: v5 (copy), p13 (copy)
		v5:info("getAvatarRules failed: {}", p15)
		p13:setState({
			getAvatarRulesFailed = true
		})
		p13:maybeStartRetryAvatarRules()
	end)

	Promise.all({
		v56,
		p13.loadedPromise
	}):andThen(function(p16) -- line: 293
		-- upvalues: v5 (copy), p13 (copy)
		local v86 = p16[1]

		v5:debug("getAvatarRules results valid: {}", v86 ~= nil)

		if v86 then
			p13.props.processAvatarRules(v86)
		end
	end)
end
function v37.checkIXPInitialized(p17) -- line: 302
	if p17.state.userId ~= 0 then
		local ixpService = p17.props.ixpService

		p17.props.waitUntilIXPUserInit(ixpService, p17.state.userId):andThen(function() -- line: 306
			-- upvalues: p17 (copy)
			p17:setState({
				ixpLoaded = true
			})
		end)
	end
end
function v37.checkForLocalPlayer(p18) -- line: 314
	-- upvalues: Players (copy)
	local v60 = Players.LocalPlayer ~= p18.state.localPlayer
	local v61 = Players.LocalPlayer and Players.LocalPlayer.UserId ~= p18.state.userId

	if v60 or v61 then
		p18:setState({
			localPlayer = Players.LocalPlayer,
			userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
		})
	end
end
function v37.didMount(p19) -- line: 327
	-- upvalues: v5 (copy), FFlagAXBackgroundsPersistence (copy)
	p19:checkForLocalPlayer()
	v5:info("AvatarExperienceInitialization:didMount")
	p19.props.getCatalogMetadata(p19.props.networking)
	p19:getAvatarData()

	if FFlagAXBackgroundsPersistence then
		p19.props.getProfileConfiguration()
	end

	p19:getAvatarRules()
	p19:checkIXPInitialized()
	p19:checkHasLoaded()
end

if GetFFlagAXEnableAvatarDataRefresh() then
	function v37.refreshAvatarDataOnRouteChange(p20, p21) -- line: 345
		-- upvalues: v33 (copy)
		if p20.props.navigation.currentRoute.routeName ~= p21.navigation.currentRoute.routeName and not p20.props.avatarExperienceActive then
			local v65 = os.clock() * 1000

			if not p20.lastCallTime then
				p20.lastCallTime = 0
			end

			if v65 and v65 - p20.lastCallTime >= v33 then
				p20:getAvatarData(true)
				p20.lastCallTime = v65
			end
		end
	end
end

function v37.didUpdate(p22, p23, p24) -- line: 366
	-- upvalues: GetFFlagAXEnableAvatarDataRefresh (copy)
	p22:checkForLocalPlayer()
	p22:checkHasLoaded()

	if p22.props.avatarExperienceActive and not p23.avatarExperienceActive then
		if p22.state.getAvatarDataFailed then
			p22:setState({
				getAvatarDataFailed = false
			})
			p22:getAvatarData()
		end

		if p22.state.getAvatarRulesFailed then
			p22:setState({
				getAvatarRulesFailed = false
			})
			p22:getAvatarRules()
		end
	end

	if GetFFlagAXEnableAvatarDataRefresh() then
		p22:refreshAvatarDataOnRouteChange(p23)
	end

	if p22.state.userId ~= p24.userId then
		p22:checkIXPInitialized()
	end

	if #p23.defaultBodyColorRanges == 0 and #p22.props.defaultBodyColorRanges ~= 0 then
		p22:maybeSetRangesAndSliderValuesFromBodyColor3s()
	end
end
function v37.willUnmount(p25) -- line: 407
	-- upvalues: v5 (copy), Promise (copy)
	v5:info("AvatarExperienceInitialization:willUnmount")

	if p25.loadedPromise:getStatus() ~= Promise.Status.Resolved then
		p25.loadedPromise:cancel()
	end

	if p25.retryAvatarRulesPromise and p25.retryAvatarRulesPromise:getStatus() ~= Promise.Status.Resolved then
		p25.retryAvatarRulesPromise:cancel()
		p25.retryAvatarRulesPromise = nil
	end
end

local function mapStateToProps(p26, _) -- line: 419
	-- upvalues: selectCurrentLegacyPage (copy), SwitchTab (copy), AvatarScreen (copy), GetFFlagAXEnableAvatarDataRefresh (copy)
	local v72 = selectCurrentLegacyPage(p26)
	local v73 = v72.name == SwitchTab.AvatarExperienceTab or v72.name == AvatarScreen.AvatarExperienceRoot

	return {
		defaultBodyColorRanges = p26.AvatarExperience.AvatarEditor.DefaultBodyColorRanges,
		avatarExperienceActive = v73,
		navigation = if not GetFFlagAXEnableAvatarDataRefresh() then nil else p26.Navigation
	}
end
local function mapDispatchToProps(p28) -- line: 432
	-- upvalues: GetAvatarData (copy), FFlagAXModeratedItemsFlow (copy), ReceivedAvatarData (copy), GetProfileConfiguration (copy), GetAvatarRules (copy), ProcessAvatarRules (copy), AvatarExperienceLoaded (copy), WaitUntilIXPUserInit (copy), GetCatalogMetadata (copy), SetRangesAndSliderValuesFromBodyColor3s (copy), GetFFlagAXEnableAvatarDataRefresh (copy), PreventSaveAvatar (copy)
	return {
		getAvatarData = function(p29) -- line: 434
			-- upvalues: p28 (copy), GetAvatarData (copy), FFlagAXModeratedItemsFlow (copy)
			return p28(GetAvatarData(p29, not not FFlagAXModeratedItemsFlow or nil))
		end,
		receivedAvatarData = function(p30) -- line: 437
			-- upvalues: p28 (copy), ReceivedAvatarData (copy)
			return p28(ReceivedAvatarData(p30))
		end,
		getProfileConfiguration = function() -- line: 440
			-- upvalues: p28 (copy), GetProfileConfiguration (copy)
			return p28(GetProfileConfiguration)
		end,
		getAvatarRules = function() -- line: 444
			-- upvalues: p28 (copy), GetAvatarRules (copy)
			return p28(GetAvatarRules)
		end,
		processAvatarRules = function(p31) -- line: 447
			-- upvalues: p28 (copy), ProcessAvatarRules (copy)
			return p28(ProcessAvatarRules(p31))
		end,
		avatarExperienceLoaded = function() -- line: 451
			-- upvalues: p28 (copy), AvatarExperienceLoaded (copy)
			return p28(AvatarExperienceLoaded())
		end,
		waitUntilIXPUserInit = function(p32, p33) -- line: 455
			-- upvalues: p28 (copy), WaitUntilIXPUserInit (copy)
			return p28(WaitUntilIXPUserInit(p32, p33))
		end,
		getCatalogMetadata = function(p34) -- line: 459
			-- upvalues: p28 (copy), GetCatalogMetadata (copy)
			return p28(GetCatalogMetadata(p34))
		end,
		setRangesAndSliderValuesFromBodyColor3s = function(p35) -- line: 463
			-- upvalues: p28 (copy), SetRangesAndSliderValuesFromBodyColor3s (copy)
			p28(SetRangesAndSliderValuesFromBodyColor3s(p35))
		end,
		setPreventSaveAvatar = if not GetFFlagAXEnableAvatarDataRefresh() then nil else function(p36) -- line: 468
			-- upvalues: p28 (copy), PreventSaveAvatar (copy)
			p28(PreventSaveAvatar(p36))
		end
	}
end

local v40 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v37)
local u41 = RoactServices.connect({
	networking = RoactNetworking
})(v40)

return function(p37) -- line: 481
	-- upvalues: Roact (copy), RoactAppExperiment (copy), Cryo (copy), u41 (ref)
	return Roact.createElement(RoactAppExperiment.Consumer, {
		render = function(p38) -- line: 483
			-- upvalues: Cryo (copy), p37 (copy), Roact (copy), u41 (ref)
			local v96 = Cryo.Dictionary.join(p37, {
				ixpService = p38
			})

			return Roact.createElement(u41, v96)
		end
	})
end
