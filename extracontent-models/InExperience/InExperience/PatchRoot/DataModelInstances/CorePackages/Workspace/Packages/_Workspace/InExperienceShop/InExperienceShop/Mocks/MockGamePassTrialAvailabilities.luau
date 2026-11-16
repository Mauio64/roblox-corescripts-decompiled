local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
require(InExperienceShop.Types)

local v = {}
local v2 = {}
local v3 = {}

return {
	fetchGamePassTrialAvailabilities = function(_: number)
		local v4 = { available = {}, active = {}, redeemed = {} }

		for _, v5 in v do
			v4.available[v5] = true
		end

		for _, v5 in v2 do
			v4.active[v5] = true
		end

		for _, v5 in v3 do
			v4.redeemed[v5.gamePassId] = { gamePassId = v5.gamePassId, endTime = v5.endTime }
		end

		return Promise.resolve(v4)
	end
}
