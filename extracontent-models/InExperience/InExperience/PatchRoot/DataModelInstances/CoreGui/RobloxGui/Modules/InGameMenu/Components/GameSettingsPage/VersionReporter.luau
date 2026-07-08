local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local PlayerPermissionsModule = require(CoreGui.RobloxGui.Modules.PlayerPermissionsModule)
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local Divider = require(ParentParent.Components.Divider)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local withLocalization = require(ParentParent.Localization.withLocalization)
local EngineFeature = game:GetEngineFeature("CoreScriptVersionEnabled")
local GetFFlagNewEventIngestPlayerScriptsDimensions = require(RobloxGui.Modules.Flags.GetFFlagNewEventIngestPlayerScriptsDimensions)
local GetFFlagRemoveAssetVersionEndpoint = require(RobloxGui.Modules.Flags.GetFFlagRemoveAssetVersionEndpoint)
local v26 = Roact.PureComponent:extend("VersionReporter")

v26.validateProps = t.strictInterface({
	LayoutOrder = t.integer
})

local function inferPlayerScriptStatus(p1) -- line: 46
	-- upvalues: Constants (copy), RbxAnalyticsService (copy), GetFFlagNewEventIngestPlayerScriptsDimensions (copy)
	local PlayerScriptsLoader = p1:FindFirstChild("PlayerScriptsLoader")
	local PlayerModule = p1:FindFirstChild("PlayerModule")
	local v31

	if PlayerScriptsLoader ~= nil and PlayerModule ~= nil then
		v31 = if PlayerModule.Archivable or PlayerScriptsLoader.Archivable then Constants.PlayerScriptStatusStrings.PossiblyCustom else Constants.PlayerScriptStatusStrings.Default
	else
		local CameraScript = p1:FindFirstChild("CameraScript")
		local ControlScript = p1:FindFirstChild("ControlScript")

		v31 = if CameraScript == nil and ControlScript == nil then Constants.PlayerScriptStatusStrings.Custom else Constants.PlayerScriptStatusStrings.CustomOld
	end

	RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, "player_scripts_status", "player_scripts_status_action", {
		defaultPlayerScripts = v31 == Constants.PlayerScriptStatusStrings.Default,
		placeID = tostring(game.PlaceId),
		rawValue = if not GetFFlagNewEventIngestPlayerScriptsDimensions() then nil else v31,
		context = if not GetFFlagNewEventIngestPlayerScriptsDimensions() then nil else "IGMv2"
	})

	return v31
end

function v26.init(p2) -- line: 82
	-- upvalues: StarterPlayer (copy), inferPlayerScriptStatus (copy), ContentProvider (copy), RunService (copy), EngineFeature (copy)
	local s1 = "PlayerScript Status: Unknown"
	local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")

	if StarterPlayerScripts then
		s1 = inferPlayerScriptStatus(StarterPlayerScripts)
	else
		p2.playerScriptsAddedConnection = StarterPlayer.ChildAdded:Connect(function(child) -- line: 88
			-- upvalues: p2 (copy), inferPlayerScriptStatus (copy)
			if child.Name == "StarterPlayerScripts" then
				p2.playerScriptsAddedConnection:Disconnect()
				p2.playerScriptsAddedConnection = nil
				p2:setState({
					playerScriptStatus = inferPlayerScriptStatus(child)
				})
			end
		end)
	end

	p2:setState({
		isAdmin = false,
		latestPlaceVersion = nil,
		serverVersion = nil,
		baseUrl = ContentProvider.BaseUrl,
		clientVersion = RunService:GetRobloxVersion(),
		placeVersion = game.PlaceVersion,
		playerScriptStatus = s1,
		coreScriptVersion = EngineFeature and RunService:GetCoreScriptVersion() or nil
	})
end
function v26.render(p3) -- line: 111
	-- upvalues: withLocalization (copy), EngineFeature (copy), RunService (copy), Roact (copy), ThemedTextLabel (copy), Skeleton (copy), Divider (copy), ExternalEventConnection (copy)
	local v38 = p3.state.serverVersion ~= nil
	local v39 = p3.state.latestPlaceVersion ~= nil
	local v40 = not p3.state.baseUrl:find("www.roblox.com")
	local v41 = v40 or p3.state.isAdmin

	return withLocalization({
		clientVersion = {
			"CoreScripts.InGameMenu.GameSettings.ClientVersion",
			CLIENT_VERSION = p3.state.clientVersion
		},
		serverVersion = {
			"CoreScripts.InGameMenu.GameSettings.ServerVersion",
			SERVER_VERSION = p3.state.serverVersion
		},
		placeVersion = {
			not v39 and "CoreScripts.InGameMenu.GameSettings.PlaceVersion" or "CoreScripts.InGameMenu.GameSettings.PlaceVersionWithLatest",
			PLACE_VERSION = p3.state.placeVersion,
			LATEST_PLACE_VERSION = p3.state.latestPlaceVersion
		},
		coreScriptVersion = EngineFeature and {
			"CoreScripts.InGameMenu.GameSettings.ClientCoreScriptVersion",
			CLIENT_CORESCRIPT_VERSION = p3.state.coreScriptVersion
		} or nil
	})(function(p4) -- line: 136
		-- upvalues: RunService (copy), Roact (copy), p3 (copy), ThemedTextLabel (copy), v38 (copy), Skeleton (copy), v40 (copy), v41 (copy), Divider (copy), EngineFeature (copy), ExternalEventConnection (copy)
		local clientVersion = p4.clientVersion
		local ok, result = pcall(function() -- line: 139
			-- upvalues: RunService (copy)
			return RunService.ClientGitHash
		end)

		if ok then
			clientVersion = string.format("%s (%.6s)", clientVersion, result)
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 80),
			LayoutOrder = p3.props.LayoutOrder
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 14),
				PaddingLeft = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 14)
			}),
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			ClientVersion = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "Footer",
				LayoutOrder = 1,
				Text = clientVersion,
				Size = UDim2.new(1, -24, 0, 14)
			}),
			ServerVersion = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "Footer",
				LayoutOrder = 2,
				Text = v38 and p4.serverVersion or "",
				Size = UDim2.new(1, -24, 0, 14)
			}, { not v38 and Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 1, 0)
			}) }),
			PlaceVersion = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "Footer",
				LayoutOrder = 3,
				Text = p4.placeVersion,
				Size = UDim2.new(1, -24, 0, 14)
			}),
			Divider = (v40 or v41) and Roact.createElement(Divider, {
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			PlayerScriptStatus = v41 and Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "Footer",
				LayoutOrder = 5,
				Text = p3.state.playerScriptStatus,
				Size = UDim2.new(1, -24, 0, 14)
			}),
			Environment = v40 and Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "Footer",
				LayoutOrder = 6,
				Text = ("Base URL: %s"):format(p3.state.baseUrl),
				Size = UDim2.new(1, -24, 0, 14)
			}),
			Divider2 = EngineFeature and Roact.createElement(Divider, {
				LayoutOrder = 7,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			CoreScriptVersion = EngineFeature and Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "Footer",
				LayoutOrder = 8,
				Text = p4.coreScriptVersion,
				Size = UDim2.new(1, -24, 0, 14)
			}),
			VersionWatcher = Roact.createElement(ExternalEventConnection, {
				event = game:GetPropertyChangedSignal("PlaceVersion"),
				callback = function() -- line: 217
					-- upvalues: p3 (copy)
					p3:setState({
						placeVersion = game.PlaceVersion
					})
				end
			})
		})
	end)
end
function v26.didMount(p5) -- line: 227
	-- upvalues: RobloxReplicatedStorage (copy), GetFFlagRemoveAssetVersionEndpoint (copy), HttpRbxApiService (copy), HttpService (copy), PlayerPermissionsModule (copy), Players (copy)
	p5.mounted = true
	coroutine.wrap(function() -- line: 230
		-- upvalues: RobloxReplicatedStorage (copy), p5 (copy)
		local v49 = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()

		if p5.mounted then
			p5:setState({
				serverVersion = v49
			})
		end
	end)()

	if not GetFFlagRemoveAssetVersionEndpoint() then
		coroutine.wrap(function() -- line: 244
			-- upvalues: HttpRbxApiService (copy), HttpService (copy), p5 (copy)
			pcall(function() -- line: 245
				-- upvalues: HttpRbxApiService (copy), HttpService (copy), p5 (copy)
				local Async = HttpRbxApiService:GetAsync(string.format("assets/%d/versions", game.PlaceId))
				local VersionNumber = HttpService:JSONDecode(Async)[1].VersionNumber

				if p5.mounted then
					p5:setState({
						latestPlaceVersion = VersionNumber
					})
				end
			end)
		end)()
	end

	coroutine.wrap(function() -- line: 259
		-- upvalues: PlayerPermissionsModule (copy), Players (copy), p5 (copy)
		local v50 = PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer)

		if p5.mounted then
			p5:setState({
				isAdmin = v50
			})
		end
	end)()
end
function v26.willUnmount(p6) -- line: 270
	p6.mounted = false

	if p6.playerScriptsAddedConnection then
		p6.playerScriptsAddedConnection:Disconnect()
	end
end

return v26
