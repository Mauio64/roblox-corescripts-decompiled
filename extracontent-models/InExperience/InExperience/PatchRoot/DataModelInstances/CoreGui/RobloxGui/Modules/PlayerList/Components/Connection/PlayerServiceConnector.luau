local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent

local AddPlayer = require(parent.Actions.AddPlayer)
local RemovePlayer = require(parent.Actions.RemovePlayer)

local MakePlayerInfoRequests = require(parent.Thunks.MakePlayerInfoRequests)
local EventConnection = require(script.Parent.EventConnection)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagReplacePlayerIconRoduxWithSignal = SharedFlags2.FFlagReplacePlayerIconRoduxWithSignal
local defineFastFlag = game:DefineFastFlag("DeferPlayerInfoRequests", false)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)
local playerIconInfoStore = PlayerIconInfoStore.PlayerIconInfoStore
local extended = Roact.PureComponent:extend("PlayerServiceConnector")

function extended:didMount()
	local players = Players:GetPlayers()

	for _, player in ipairs(players) do
		self.props.addPlayer(player)
		self.props.makePlayerInfoRequests(player)
	end

	if FFlagBadgeVisibilitySettingEnabled then
		spawn(function()
			self.sendPlayerProfileSettingsConnection = RobloxReplicatedStorage:WaitForChild(
				"SendPlayerProfileSettings",
				1e999
			).OnClientEvent:Connect(function(p: string)
				local playerByUserId = Players:GetPlayerByUserId((tonumber(p)))

				if playerByUserId then
					if defineFastFlag then
						task.defer(function()
							self.props.makePlayerInfoRequests(playerByUserId)
						end)
					else
						self.props.makePlayerInfoRequests(playerByUserId)
					end
				end
			end)
		end)
	end
end

function extended.render(p)
	return Roact.createFragment({
		PlayerAddedConnection = Roact.createElement(EventConnection, {
			event = Players.PlayerAdded,
			callback = function(p2)
				p.props.addPlayer(p2)
				p.props.makePlayerInfoRequests(p2)
			end
		}),
		PlayerRemovingConnection = Roact.createElement(EventConnection, {
			event = Players.PlayerRemoving,
			callback = function(p2)
				p.props.removePlayer(p2)
			end
		})
	})
end

function extended.willUnmount(p)
	local players = Players:GetPlayers()

	for _, player in ipairs(players) do
		p.props.removePlayer(player)
	end

	if FFlagBadgeVisibilitySettingEnabled and p.sendPlayerProfileSettingsConnection then
		p.sendPlayerProfileSettingsConnection:Disconnect()
	end
end

local function mapDispatchToProps(callback)
	return {
		addPlayer = function(p)
			return callback(AddPlayer(p))
		end,
		makePlayerInfoRequests = function(p)
			return callback(MakePlayerInfoRequests(p))
		end,
		removePlayer = function(p)
			if FFlagReplacePlayerIconRoduxWithSignal then
				playerIconInfoStore.removePlayer(p.UserId)
			end

			return callback(RemovePlayer(p))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
