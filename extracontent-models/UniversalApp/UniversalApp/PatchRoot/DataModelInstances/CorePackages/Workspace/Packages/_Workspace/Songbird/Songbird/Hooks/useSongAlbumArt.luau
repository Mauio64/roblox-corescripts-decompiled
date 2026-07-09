local Songbird = script:FindFirstAncestor("Songbird")
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local tryLoadRbxthumbAsync = require(Songbird.Common.tryLoadRbxthumbAsync)
local useAsync = ReactUtils.useAsync
local useMemo = React.useMemo
local t1 = {
	Icon = "Icon",
	Masthead = "Masthead"
}
local t2 = {
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_blue.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_green.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_magenta.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_orange.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_pink.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_purple.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_turquoise.png",
	"rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_yellow.png"
}
local t3 = {
	[t1.Icon] = Vector2.new(420, 420),
	[t1.Masthead] = Vector2.new(1440, 456)
}

local function getFallbackMusicThumbnail(p1) -- line: 35
	-- upvalues: t2 (copy)
	if p1 then
		local v13 = if typeof(p1) ~= "string" then p1 else tonumber((p1:match("(%d+)$")))

		if v13 then
			return t2[v13 % #t2 + 1]
		end
	end

	return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
end
local function useSongAlbumArt(p2, s1: string?) -- line: 58
	-- upvalues: t1 (copy), useMemo (copy), t2 (copy), useAsync (copy), t3 (copy), tryLoadRbxthumbAsync (copy)
	local v16 = s1 or t1.Icon
	local v17 = useMemo(function() -- line: 61
		-- upvalues: p2 (copy), t2 (copy)
		local v20 = p2

		if v20 then
			local v21 = if typeof(v20) ~= "string" then v20 else tonumber((v20:match("(%d+)$")))

			if v21 then
				return t2[v21 % #t2 + 1]
			end
		end

		return "rbxasset://textures/ui/LuaApp/graphic/album_art_fallback_gray.png"
	end, { p2 })
	local v18 = useAsync(function() -- line: 65
		-- upvalues: p2 (copy), t3 (copy), v16 (copy), tryLoadRbxthumbAsync (copy)
		if p2 then
			local v22 = t3[v16]
			local v23 = `rbxthumb://type=Asset&id={ p2 }&w={ v22.X }&h={ v22.Y }`

			if pcall(tryLoadRbxthumbAsync, v23) then
				return v23
			end
		end

		return nil
	end, {
		v16,
		p2
	})
	local v19 = useMemo(function() -- line: 79
		-- upvalues: v18 (copy), v17 (copy)
		if v18.status == "ok" and v18.value then
			return v18.value
		end

		return v17
	end, {
		v18,
		v17
	})

	return {
		status = v18.status,
		value = v19
	}
end

return useSongAlbumArt
