local Players = game:GetService("Players")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local fFlagMomentsCommentsUseMockNetwork = SharedFlags.FFlagMomentsCommentsUseMockNetwork
local defineFastFlag = game:DefineFastFlag("MomentsCommentsMockLatency", false)
local defineFastFlag2 = game:DefineFastFlag("MomentsCommentsMockPostedViewer", false)
local v5

if fFlagMomentsCommentsUseMockNetwork then
	local createCommentsMockNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Comments/createCommentsMockNetwork")
	local localPlayer = Players.LocalPlayer

	local v7 = if defineFastFlag2 and localPlayer ~= nil and localPlayer.UserId > 0 then tostring(localPlayer.UserId) else nil
	v5 = createCommentsMockNetwork({
		fetchLatencySeconds = defineFastFlag and 0.2 or nil,
		postLatencySeconds = defineFastFlag and 2 or nil,
		postAuthorUserId = v7
	})
else
	v5 = nil
end

local function resolveCommentsNetwork(p2)
	if fFlagMomentsCommentsUseMockNetwork then
		return v5
	end

	if p2 == nil then
		return nil
	end

	return p2.network
end

return resolveCommentsNetwork
