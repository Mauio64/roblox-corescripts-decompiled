local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local AddSongDetail = require(SongDetailRodux.Actions.AddSongDetail)
local Cryo = require(SongDetailRoduxParent.Cryo)

require(SongDetailRoduxParent.DiscoveryTypes)

return {
	key = "SongDetailKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 12
		-- upvalues: AddSongDetail (copy), Cryo (copy)
		local v7 = t1 or {}

		assert(v7, "")

		if p1 and p1.type == AddSongDetail.name then
			local t2 = {}

			for k, _ in pairs(p1.songDetail) do
				if v7[k] then
					t2[k] = Cryo.Dictionary.join(v7[k], p1.songDetail[k])
				else
					t2[k] = p1.songDetail[k]
				end
			end

			v7 = Cryo.Dictionary.join(v7, t2)
		end

		return v7
	end
}
