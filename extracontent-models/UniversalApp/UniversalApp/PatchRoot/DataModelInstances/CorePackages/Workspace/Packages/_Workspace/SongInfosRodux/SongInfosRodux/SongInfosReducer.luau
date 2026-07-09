local Parent = script:FindFirstAncestor("SongInfosRodux").Parent
local AddSongs = require(script.Parent.AddSongs)
local Cryo = require(Parent.Cryo)

require(Parent.DiscoveryTypes)

return {
	key = "SongInfosKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 12
		-- upvalues: AddSongs (copy), Cryo (copy)
		local v6 = t1 or {}

		assert(v6, "")

		if p1 and p1.type == AddSongs.name then
			local t2 = {}

			for k, _ in pairs(p1.songs) do
				if v6[k] then
					t2[k] = Cryo.Dictionary.join(v6[k], p1.songs[k])
				else
					t2[k] = p1.songs[k]
				end
			end

			v6 = Cryo.Dictionary.join(v6, t2)
		end

		return v6
	end
}
