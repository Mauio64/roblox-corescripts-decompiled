local url = require("@luauforge/deferred/gNK").Url

return {
	foldersUrl = function()
		return `{url.AVATAR_URL}v1/folders`
	end,
	folderUrl = function(p2)
		return `{url.AVATAR_URL}v1/folders/{p2}`
	end,
	folderItemsUrl = function(p2)
		return `{url.AVATAR_URL}v1/folders/{p2}/items`
	end,
	folderItemsRemoveUrl = function(p2)
		return `{url.AVATAR_URL}v1/folders/{p2}/items/remove`
	end
}
