local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local decodeEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeEmojiSets")
local validateMomentsEmojiCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/validateMomentsEmojiCatalog")

return {
	parseMomentsEmojiFallbackCatalogJson = function(p2)
		if p2 == "" then
			return nil
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

		if success and validateMomentsEmojiCatalog.isValidGetEmojiSetsResponseShape(result) then
			return decodeEmojiSets.flattenEmojis(decodeEmojiSets.decodeGetEmojiSetsResponse(result))
		end

		return nil
	end
}
