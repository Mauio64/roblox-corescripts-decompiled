require("@luauforge/bundled/dvN")
local module = require("@luauforge/bundled/dvP")
local useSelector = require("@luauforge/bundled/dvS").Hooks.RoactRodux.useSelector
local useSongAlbumArt = require("@luauforge/bundled/dvT").useSongAlbumArt

local module2 = require("@luauforge/bundled/dvU")

return function(p2)
	local v5 = useSongAlbumArt(p2)

	return {
		song = useSelector(function(p3)
			return p3.Personalization[module.key][p2]
		end, module2.shallowEqual),
		thumbnail = v5.value
	}
end
