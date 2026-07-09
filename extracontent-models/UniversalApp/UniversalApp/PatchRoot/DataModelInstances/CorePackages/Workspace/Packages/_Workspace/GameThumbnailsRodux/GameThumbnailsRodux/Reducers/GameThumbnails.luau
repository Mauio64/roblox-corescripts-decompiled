local GameThumbnailsRodux = script:FindFirstAncestor("GameThumbnailsRodux")
local GameThumbnailsRoduxParent = GameThumbnailsRodux.Parent
local Immutable = require(GameThumbnailsRoduxParent.AppCommonLib).Immutable
local SetGameThumbnails = require(GameThumbnailsRodux.Actions.SetGameThumbnails)

return function(t1: {[any]: any}?, p1) -- line: 15
	-- upvalues: SetGameThumbnails (copy), Immutable (copy)
	local v7 = t1 or {}

	assert(v7, "")

	if p1.type == SetGameThumbnails.name then
		local t2 = {}

		for k, v in pairs(p1.thumbnails) do
			t2[k] = v.url
		end

		v7 = Immutable.JoinDictionaries(v7, t2)
	end

	return v7
end
