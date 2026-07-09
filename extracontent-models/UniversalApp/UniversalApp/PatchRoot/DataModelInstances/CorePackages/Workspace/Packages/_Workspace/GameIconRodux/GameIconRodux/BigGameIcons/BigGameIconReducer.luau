local GameIconRodux = script:FindFirstAncestor("GameIconRodux")
local GameIconRoduxParent = GameIconRodux.Parent
local Cryo = require(GameIconRoduxParent.Cryo)
local SetBigGameIcons = require(GameIconRodux.BigGameIcons.SetBigGameIcons)

return {
	key = "BigGameIconsKey",
	reducer = function(p1, p2) -- line: 7
		-- upvalues: SetBigGameIcons (copy), Cryo (copy)
		local v7 = p1 or {}

		if p2.type == SetBigGameIcons.name then
			v7 = Cryo.Dictionary.join(v7, p2.gameIcons)
		end

		return v7
	end
}
