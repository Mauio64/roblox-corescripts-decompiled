local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)
local decodeEmojiSets = require(script.Parent.decodeEmojiSets)
local validateMomentsEmojiCatalog = require(script.Parent.validateMomentsEmojiCatalog)

return {
	parseMomentsEmojiFallbackCatalogJson = function(p: string)
		if p == "" then
			return nil
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, p)

		if success and validateMomentsEmojiCatalog.isValidGetEmojiSetsResponseShape(result) then
			return decodeEmojiSets.flattenEmojis(decodeEmojiSets.decodeGetEmojiSetsResponse(result))
		end

		return nil
	end
}
