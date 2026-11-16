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
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton

local PlayerPermissionsModule = require(CoreGui.RobloxGui.Modules.PlayerPermissionsModule)

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Resources.Constants)
local Divider = require(parent.Components.Divider)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local withLocalization = require(parent.Localization.withLocalization)

local engineFeature = game:GetEngineFeature("CoreScriptVersionEnabled")

local GetFFlagNewEventIngestPlayerScriptsDimensions = require(RobloxGui.Modules.Flags.GetFFlagNewEventIngestPlayerScriptsDimensions)
local GetFFlagRemoveAssetVersionEndpoint = require(RobloxGui.Modules.Flags.GetFFlagRemoveAssetVersionEndpoint)

local extended = Roact.PureComponent:extend("VersionReporter")
extended.validateProps = t.strictInterface({ LayoutOrder = t.integer })

local function inferPlayerScriptStatus(instance)
	local playerScriptsLoader = instance:FindFirstChild("PlayerScriptsLoader")
	local playerModule = instance:FindFirstChild("PlayerModule")
	local v

	if playerScriptsLoader == nil or playerModule == nil then
		local cameraScript = instance:FindFirstChild("CameraScript")
		local controlScript = instance:FindFirstChild("ControlScript")

		if cameraScript == nil and controlScript == nil then
			v = Constants.PlayerScriptStatusStrings.Custom
		else
			v = Constants.PlayerScriptStatusStrings.CustomOld
		end
	elseif playerModule.Archivable or playerScriptsLoader.Archivable then
		v = Constants.PlayerScriptStatusStrings.PossiblyCustom
	else
		v = Constants.PlayerScriptStatusStrings.Default
	end

	local analyticsTargetName = Constants.AnalyticsTargetName

	local v2 = {
		defaultPlayerScripts = v == Constants.PlayerScriptStatusStrings.Default,
		placeID = tostring(game.PlaceId),
		rawValue = 0,
		context = 0
	}
	local rawValue

	if GetFFlagNewEventIngestPlayerScriptsDimensions() then
		rawValue = v
	end

	v2.rawValue = rawValue
	v2.context = GetFFlagNewEventIngestPlayerScriptsDimensions() and "IGMv2" or nil
	RbxAnalyticsService:SetRBXEventStream(
		analyticsTargetName,
		"player_scripts_status",
		"player_scripts_status_action",
		v2
	)

	return v
end

function extended:init()
	local playerScriptStatus = "PlayerScript Status: Unknown"
	local starterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")

	if starterPlayerScripts then
		playerScriptStatus = inferPlayerScriptStatus(starterPlayerScripts)
	else
		self.playerScriptsAddedConnection = StarterPlayer.ChildAdded:Connect(function(child)
			if child.Name == "StarterPlayerScripts" then
				self.playerScriptsAddedConnection:Disconnect()
				self.playerScriptsAddedConnection = nil
				self:setState({ playerScriptStatus = inferPlayerScriptStatus(child) })
			end
		end)
	end

	self:setState({
		baseUrl = ContentProvider.BaseUrl,
		clientVersion = RunService:GetRobloxVersion(),
		isAdmin = false,
		latestPlaceVersion = nil,
		placeVersion = game.PlaceVersion,
		serverVersion = nil,
		playerScriptStatus = playerScriptStatus,
		coreScriptVersion = engineFeature and RunService:GetCoreScriptVersion() or nil
	})
end

function extended.render(object)
	local v = object.state.serverVersion ~= nil
	local v2 = object.state.latestPlaceVersion ~= nil
	local v3 = not object.state.baseUrl:find("www.roblox.com")

	local v4 = v3 or object.state.isAdmin

	return withLocalization({
		clientVersion = {
			"CoreScripts.InGameMenu.GameSettings.ClientVersion",
			CLIENT_VERSION = object.state.clientVersion
		},
		serverVersion = {
			"CoreScripts.InGameMenu.GameSettings.ServerVersion",
			SERVER_VERSION = object.state.serverVersion
		},
		placeVersion = {
			v2 and "CoreScripts.InGameMenu.GameSettings.PlaceVersionWithLatest" or "CoreScripts.InGameMenu.GameSettings.PlaceVersion",
			PLACE_VERSION = object.state.placeVersion,
			LATEST_PLACE_VERSION = object.state.latestPlaceVersion
		},
		coreScriptVersion = engineFeature and ({
			"CoreScripts.InGameMenu.GameSettings.ClientCoreScriptVersion",
			CLIENT_CORESCRIPT_VERSION = object.state.coreScriptVersion
		} or nil) or nil
	})(function(props)
		local clientVersion = props.clientVersion

		local success, result = pcall(function()
			return RunService.ClientGitHash
		end)

		if success then
			clientVersion = string.format("%s (%.6s)", clientVersion, result)
		end

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 80),
				LayoutOrder = object.props.LayoutOrder
			},
			{
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
					Text = clientVersion,
					LayoutOrder = 1,
					Size = UDim2.new(1, -24, 0, 14)
				}),
				ServerVersion = Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "Footer",
					Text = v and props.serverVersion or "",
					LayoutOrder = 2,
					Size = UDim2.new(1, -24, 0, 14)
				}, { not v and Roact.createElement(Skeleton, { Size = UDim2.new(1, 0, 1, 0) }) }),
				PlaceVersion = Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "Footer",
					Text = props.placeVersion,
					LayoutOrder = 3,
					Size = UDim2.new(1, -24, 0, 14)
				}),
				Divider = (v3 or v4) and Roact.createElement(Divider, {
					Size = UDim2.new(1, 0, 0, 1),
					LayoutOrder = 4
				}),
				PlayerScriptStatus = v4 and Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "Footer",
					Text = object.state.playerScriptStatus,
					LayoutOrder = 5,
					Size = UDim2.new(1, -24, 0, 14)
				}),
				Environment = v3 and Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "Footer",
					Text = ("Base URL: %s"):format(object.state.baseUrl),
					LayoutOrder = 6,
					Size = UDim2.new(1, -24, 0, 14)
				}),
				Divider2 = engineFeature and Roact.createElement(Divider, {
					Size = UDim2.new(1, 0, 0, 1),
					LayoutOrder = 7
				}),
				CoreScriptVersion = engineFeature and Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "Footer",
					Text = props.coreScriptVersion,
					LayoutOrder = 8,
					Size = UDim2.new(1, -24, 0, 14)
				}),
				VersionWatcher = Roact.createElement(ExternalEventConnection, {
					event = game:GetPropertyChangedSignal("PlaceVersion"),
					callback = function()
						object:setState({ placeVersion = game.PlaceVersion })
					end
				})
			}
		)
	end)
end

function extended:didMount()
	self.mounted = true

	coroutine.wrap(function()
		local serverVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()

		if self.mounted then
			self:setState({ serverVersion = serverVersion })
		end
	end)()

	if not GetFFlagRemoveAssetVersionEndpoint() then
		coroutine.wrap(function()
			pcall(function()
				local versionNumber = HttpService:JSONDecode((HttpRbxApiService:GetAsync(string.format("assets/%d/versions", game.PlaceId))))[1].VersionNumber

				if self.mounted then
					self:setState({ latestPlaceVersion = versionNumber })
				end
			end)
		end)()
	end

	coroutine.wrap(function()
		local isPlayerAdminAsync = PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer)

		if self.mounted then
			self:setState({ isAdmin = isPlayerAdminAsync })
		end
	end)()
end

function extended:willUnmount()
	self.mounted = false

	if self.playerScriptsAddedConnection then
		self.playerScriptsAddedConnection:Disconnect()
	end
end

return extended
