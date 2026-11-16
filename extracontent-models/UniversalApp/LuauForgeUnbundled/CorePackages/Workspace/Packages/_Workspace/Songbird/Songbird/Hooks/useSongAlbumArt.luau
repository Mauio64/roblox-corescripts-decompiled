local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")

local tryLoadRbxthumbAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Common/tryLoadRbxthumbAsync")

local useAsync = ReactUtils.useAsync
local useMemo = React.useMemo

local v5 = { Icon = "Icon", Masthead = "Masthead" }

local v6 = {
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_blue.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_green.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_magenta.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_orange.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_pink.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_purple.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_turquoise.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_yellow.png"
}

local v7 = { ["Icon"] = Vector2.new(420, 420), Masthead = Vector2.new(1440, 456) }

local function getFallbackMusicThumbnail(value)
	if not value then
		return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
	end

	if typeof(value) == "string" then
		value = tonumber((value:match("(%d+)$")))
	end

	if value then
		return v6[value % #v6 + 1]
	end

	return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
end

local function useSongAlbumArt(p2, value)
	local v8 = value or "Icon"

	local v9 = useMemo(function()
		local v10 = p2

		if not v10 then
			return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
		end

		if typeof(v10) == "string" then
			v10 = tonumber((v10:match("(%d+)$")))
		end

		if v10 then
			return v6[v10 % #v6 + 1]
		end

		return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
	end, { p2 })

	local v10 = useAsync(function()
		if not p2 then
			return nil
		end

		local v11 = v7[v8]

		local formatted = `rbxthumb://type=Asset&id={p2}&w={v11.X}&h={v11.Y}`

		if pcall(tryLoadRbxthumbAsync, formatted) then
			return formatted
		end

		return nil
	end, { v8, p2 })

	local v11 = useMemo(function()
		if v10.status == "ok" and v10.value then
			return v10.value
		end

		return v9
	end, { v10, v9 })

	return { status = v10.status, value = v11 }
end

return useSongAlbumArt
