local CorePackages = game:GetService("CorePackages")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Constants = CoreScriptsCommon.Constants
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local getServerType = Instance.new("RemoteFunction")
getServerType.Name = "GetServerType"
getServerType.Parent = RobloxReplicatedStorage

local function getServerType2()
	if game.PrivateServerId == "" then
		return Constants.STANDARD_SERVER
	end

	if game.PrivateServerOwnerId == 0 then
		return Constants.RESERVED_SERVER
	end

	return Constants.VIP_SERVER
end

getServerType.OnServerInvoke = getServerType2
