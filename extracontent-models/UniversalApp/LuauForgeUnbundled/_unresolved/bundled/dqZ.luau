local HttpService = game:GetService("HttpService")

local sessionType = require("@luauforge/bundled/dra").SessionType

return {
	generateUuid = function()
		return HttpService:GenerateGUID(true)
	end,
	create = function(object, p2, p3, p4, p5, p6)
		if
			not object:SessionExists(sessionType.StructuralIdentifier.OmniSearch)
			or object:GetMetadata(
				sessionType.StructuralIdentifier.OmniSearch,
				sessionType.Metadata.OmniSearch.OmniSearchUuid
			) ~= p2
		then
			object:SetSession(
				sessionType.StructuralIdentifier.Level1,
				sessionType.StructuralIdentifier.OmniSearch,
				sessionType.StructuralIdentifier.OmniSearch
			)

			object:SetMetadata(
				sessionType.StructuralIdentifier.OmniSearch,
				sessionType.Metadata.OmniSearch.OmniSearchUuid,
				p2
			)
		end

		object:SetMetadata(
			sessionType.StructuralIdentifier.OmniSearch,
			sessionType.Metadata.OmniSearch.SearchKeyword,
			p3
		)

		object:SetMetadata(
			sessionType.StructuralIdentifier.OmniSearch,
			sessionType.Metadata.OmniSearch.SearchType,
			p4
		)

		object:SetMetadata(
			sessionType.StructuralIdentifier.OmniSearch,
			sessionType.Metadata.OmniSearch.SearchTabUuid,
			p5
		)

		object:SetMetadata(
			sessionType.StructuralIdentifier.OmniSearch,
			sessionType.Metadata.OmniSearch.SearchSourceEvent,
			p6
		)
	end,
	updateSearchType = function(object, p2, p3, p4)
		if object:SessionExists(sessionType.StructuralIdentifier.OmniSearch) then
			object:SetMetadata(
				sessionType.StructuralIdentifier.OmniSearch,
				sessionType.Metadata.OmniSearch.SearchType,
				p2
			)

			if p3 then
				object:SetMetadata(
					sessionType.StructuralIdentifier.OmniSearch,
					sessionType.Metadata.OmniSearch.SearchTabUuid,
					p3
				)
			end

			object:SetMetadata(
				sessionType.StructuralIdentifier.OmniSearch,
				sessionType.Metadata.OmniSearch.SearchSourceEvent,
				p4
			)
		end
	end
}
