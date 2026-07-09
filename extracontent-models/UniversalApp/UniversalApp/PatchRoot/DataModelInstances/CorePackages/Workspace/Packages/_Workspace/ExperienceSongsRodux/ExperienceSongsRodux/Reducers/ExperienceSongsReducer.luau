local ExperienceSongsRodux = script:FindFirstAncestor("ExperienceSongsRodux")
local ExperienceSongsRoduxParent = ExperienceSongsRodux.Parent
local Cryo = require(ExperienceSongsRoduxParent.Cryo)
local AddExperienceSongs = require(ExperienceSongsRodux.Actions.AddExperienceSongs)

return {
	key = "ExperienceSongsKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 12
		-- upvalues: AddExperienceSongs (copy), Cryo (copy)
		local v7 = t1 or {}

		assert(v7, "")

		if p1 and p1.type == AddExperienceSongs.name then
			v7 = Cryo.Dictionary.join(v7, p1.experienceSongs)
		end

		return v7
	end
}
