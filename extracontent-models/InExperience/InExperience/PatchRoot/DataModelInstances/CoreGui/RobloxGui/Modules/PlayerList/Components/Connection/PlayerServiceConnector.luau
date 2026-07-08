local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local AddPlayer = require(ParentParent.Actions.AddPlayer)
local RemovePlayer = require(ParentParent.Actions.RemovePlayer)
local MakePlayerInfoRequests = require(ParentParent.Thunks.MakePlayerInfoRequests)
local EventConnection = require(script.Parent.EventConnection)
local FFlagBadgeVisibilitySettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBadgeVisibilitySettingEnabled
local FFlagReplacePlayerIconRoduxWithSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagReplacePlayerIconRoduxWithSignal
local v13 = game:DefineFastFlag("DeferPlayerInfoRequests", false)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore).PlayerIconInfoStore
local v15 = Roact.PureComponent:extend("PlayerServiceConnector")

function v15.didMount(p1) -- line: 23
	-- upvalues: Players (copy), FFlagBadgeVisibilitySettingEnabled (copy), RobloxReplicatedStorage (copy), v13 (copy)
	local players = Players:GetPlayers()

	for _, v in ipairs(players) do
		p1.props.addPlayer(v)
		p1.props.makePlayerInfoRequests(v)
	end

	if FFlagBadgeVisibilitySettingEnabled then
		spawn(function() -- line: 31
			-- upvalues: RobloxReplicatedStorage (copy), p1 (copy), Players (copy), v13 (copy)
			p1.sendPlayerProfileSettingsConnection = RobloxReplicatedStorage:WaitForChild("SendPlayerProfileSettings", 1e999).OnClientEvent:Connect(function(s1: string) -- line: 33
				-- upvalues: Players (copy), v13 (copy), p1 (copy)
				local num = tonumber(s1)
				local PlayerByUserId = Players:GetPlayerByUserId(num)

				if PlayerByUserId then
					if v13 then
						task.defer(function() -- line: 38
							-- upvalues: p1 (copy), PlayerByUserId (copy)
							p1.props.makePlayerInfoRequests(PlayerByUserId)
						end)

						return
					end

					p1.props.makePlayerInfoRequests(PlayerByUserId)
				end
			end)
		end)
	end
end
function v15.render(p2) -- line: 50
	-- upvalues: Roact (copy), EventConnection (copy), Players (copy)
	return Roact.createFragment({
		PlayerAddedConnection = Roact.createElement(EventConnection, {
			event = Players.PlayerAdded,
			callback = function(p3) -- line: 54
				-- upvalues: p2 (copy)
				p2.props.addPlayer(p3)
				p2.props.makePlayerInfoRequests(p3)
			end
		}),
		PlayerRemovingConnection = Roact.createElement(EventConnection, {
			event = Players.PlayerRemoving,
			callback = function(p4) -- line: 62
				-- upvalues: p2 (copy)
				p2.props.removePlayer(p4)
			end
		})
	})
end
function v15.willUnmount(p5) -- line: 69
	-- upvalues: Players (copy), FFlagBadgeVisibilitySettingEnabled (copy)
	local players = Players:GetPlayers()

	for _, v in ipairs(players) do
		p5.props.removePlayer(v)
	end

	if FFlagBadgeVisibilitySettingEnabled and p5.sendPlayerProfileSettingsConnection then
		p5.sendPlayerProfileSettingsConnection:Disconnect()
	end
end

local function mapDispatchToProps(p6) -- line: 80
	-- upvalues: AddPlayer (copy), MakePlayerInfoRequests (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), RemovePlayer (copy)
	return {
		addPlayer = function(p7) -- line: 82
			-- upvalues: p6 (copy), AddPlayer (copy)
			return p6(AddPlayer(p7))
		end,
		makePlayerInfoRequests = function(p8) -- line: 86
			-- upvalues: p6 (copy), MakePlayerInfoRequests (copy)
			return p6(MakePlayerInfoRequests(p8))
		end,
		removePlayer = function(p9) -- line: 90
			-- upvalues: FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), p6 (copy), RemovePlayer (copy)
			if FFlagReplacePlayerIconRoduxWithSignal then
				PlayerIconInfoStore.removePlayer(p9.UserId)
			end

			return p6(RemovePlayer(p9))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v15)
