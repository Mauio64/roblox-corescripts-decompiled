local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local AddSongExperiences = require(SongDetailRodux.Actions.AddSongExperiences)
local Cryo = require(SongDetailRoduxParent.Cryo)

return {
	key = "SongExperiencesKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 15
		-- upvalues: AddSongExperiences (copy), Cryo (copy)
		local v7 = t1 or {}

		assert(v7, "")

		if p1 and p1.type == AddSongExperiences.name then
			v7 = Cryo.Dictionary.join(v7, p1.songExperiences)
		end

		return v7
	end
}
