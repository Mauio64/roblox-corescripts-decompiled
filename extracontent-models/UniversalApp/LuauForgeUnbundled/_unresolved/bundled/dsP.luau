require("@luauforge/bundled/dsL")
local module = require("@luauforge/bundled/dsN")
local useSelector = require("@luauforge/bundled/dsQ").Hooks.RoactRodux.useSelector
local useSongAlbumArt = require("@luauforge/bundled/dsR").useSongAlbumArt

local module2 = require("@luauforge/bundled/dsS")

return function(p2)
	local v5 = useSongAlbumArt(p2)

	return {
		song = useSelector(function(p3)
			return p3.Personalization[module.key][p2]
		end, module2.shallowEqual),
		thumbnail = v5.value
	}
end
