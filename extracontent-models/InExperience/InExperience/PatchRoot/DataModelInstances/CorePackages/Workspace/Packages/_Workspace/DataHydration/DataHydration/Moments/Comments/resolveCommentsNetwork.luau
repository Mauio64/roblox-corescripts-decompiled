local Players = game:GetService("Players")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local SharedFlags = require(parent.SharedFlags)
require(DataHydration.Moments.MomentsStoreTypes)

local FFlagMomentsCommentsUseMockNetwork = SharedFlags.FFlagMomentsCommentsUseMockNetwork
local defineFastFlag = game:DefineFastFlag("MomentsCommentsMockLatency", false)
local defineFastFlag2 = game:DefineFastFlag("MomentsCommentsMockPostedViewer", false)
local v

if FFlagMomentsCommentsUseMockNetwork then
	local createCommentsMockNetwork = require(script.Parent.createCommentsMockNetwork)
	local localPlayer = Players.LocalPlayer
	local v2 = {
		fetchLatencySeconds = defineFastFlag and 0.2 or nil,
		postLatencySeconds = defineFastFlag and 2 or nil,
		postAuthorUserId = 0
	}
	local postAuthorUserId

	if defineFastFlag2 and localPlayer ~= nil and localPlayer.UserId > 0 then
		postAuthorUserId = tostring(localPlayer.UserId)
	end

	v2.postAuthorUserId = postAuthorUserId
	v = createCommentsMockNetwork(v2)
else
	v = nil
end

local function resolveCommentsNetwork(p)
	if FFlagMomentsCommentsUseMockNetwork then
		return v
	end

	return if p ~= nil then p.network else nil
end

return resolveCommentsNetwork
