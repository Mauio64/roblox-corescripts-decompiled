local CorePackages = game:GetService("CorePackages")
local Constants = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local v4 = game:DefineFastFlag("GetJoinDataRemoteFunctionEnabled", false)
local RemoteFunction = Instance.new("RemoteFunction")

RemoteFunction.Name = "GetServerType"
RemoteFunction.Parent = RobloxReplicatedStorage

local function getServerType() -- line: 12
	-- upvalues: Constants (copy)
	if game.PrivateServerId ~= "" then
		if game.PrivateServerOwnerId ~= 0 then
			return Constants.VIP_SERVER
		end

		return Constants.RESERVED_SERVER
	end

	return Constants.STANDARD_SERVER
end

RemoteFunction.OnServerInvoke = getServerType

if v4 then
	local RemoteFunction2 = Instance.new("RemoteFunction")

	RemoteFunction2.Name = "GetJoinData"
	RemoteFunction2.Parent = RobloxReplicatedStorage

	local function getJoinData(p1) -- line: 32
		return p1:GetJoinData()
	end

	RemoteFunction2.OnServerInvoke = getJoinData
end
