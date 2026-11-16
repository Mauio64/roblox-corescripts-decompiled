local ContentProvider = game:GetService("ContentProvider")

local mutedError = require("@luauforge/bundled/dru").mutedError

local module = require("@luauforge/bundled/drK")

local v5 = {
	maxEntries = game:DefineFastInt("HomeThumbnailPrefetchMaxEntries", 4),
	maxEntriesPerSort = game:DefineFastInt("HomeThumbnailPrefetchMaxEntriesPerSort", 2)
}

local function prefetchHomeThumbnails(p2, p3)
	local v6 = module(p2, p3, v5)

	if #v6 > 0 then
		task.spawn(function()
			if not pcall(ContentProvider.PreloadAsync, ContentProvider, v6) then
				mutedError("prefetchHomeThumbnails: ContentProvider:PreloadAsync failed")
			end
		end)
	end
end

return prefetchHomeThumbnails
