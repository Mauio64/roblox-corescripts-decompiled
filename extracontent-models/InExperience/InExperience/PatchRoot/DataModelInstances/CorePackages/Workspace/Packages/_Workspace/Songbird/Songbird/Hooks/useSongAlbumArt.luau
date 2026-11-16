local Songbird = script:FindFirstAncestor("Songbird")

local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)

local tryLoadRbxthumbAsync = require(Songbird.Common.tryLoadRbxthumbAsync)

local useAsync = ReactUtils.useAsync
local useMemo = React.useMemo

local _ = { Icon = "Icon", Masthead = "Masthead" }

local v = {
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_blue.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_green.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_magenta.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_orange.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_pink.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_purple.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_turquoise.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_yellow.png"
}

local v2 = { ["Icon"] = Vector2.new(420, 420), Masthead = Vector2.new(1440, 456) }

local function getFallbackMusicThumbnail(value) -- 1 equivalent call inferred from this helper
	if not value then
		return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
	end

	if typeof(value) == "string" then
		value = tonumber((value:match("(%d+)$")))
	end

	if value then
		return v[value % #v + 1]
	end

	return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
end

local function useSongAlbumArt(value, value2: string?)
	local v3 = value2 or "Icon"

	local v4 = useMemo(function()
		return getFallbackMusicThumbnail(value) -- inferred equivalent call
	end, { value })

	local v5 = useAsync(function()
		if not value then
			return nil
		end

		local v5 = v2[v3]

		local formatted = `rbxthumb://type=Asset&id={value}&w={v5.X}&h={v5.Y}`

		if pcall(tryLoadRbxthumbAsync, formatted) then
			return formatted
		end

		return nil
	end, { v3, value })

	local v6 = useMemo(function()
		if v5.status == "ok" and v5.value then
			return v5.value
		end

		return v4
	end, { v5, v4 })

	return { status = v5.status, value = v6 }
end

return useSongAlbumArt
