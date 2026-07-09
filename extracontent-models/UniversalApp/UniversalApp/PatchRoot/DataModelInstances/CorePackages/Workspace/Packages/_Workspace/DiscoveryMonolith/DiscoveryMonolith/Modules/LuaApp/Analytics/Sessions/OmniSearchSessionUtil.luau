local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local SessionType = require(Parent.RobloxAppSessionization).SessionType

return {
	generateUuid = function() -- line: 8
		-- upvalues: HttpService (copy)
		return HttpService:GenerateGUID(true)
	end,
	create = function(p1, p2, p3, p4, p5, p6) -- line: 12
		-- upvalues: SessionType (copy)
		local v10 = true

		if p1:SessionExists(SessionType.StructuralIdentifier.OmniSearch) and p2 == p1:GetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.OmniSearchUuid) then
			v10 = false
		end

		if v10 then
			p1:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.OmniSearch, SessionType.StructuralIdentifier.OmniSearch)
			p1:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.OmniSearchUuid, p2)
		end

		p1:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchKeyword, p3)
		p1:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchType, p4)
		p1:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchTabUuid, p5)
		p1:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchSourceEvent, p6)
	end,
	updateSearchType = function(p7, p8, p9, p10) -- line: 63
		-- upvalues: SessionType (copy)
		if p7:SessionExists(SessionType.StructuralIdentifier.OmniSearch) then
			p7:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchType, p8)

			if p9 then
				p7:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchTabUuid, p9)
			end

			p7:SetMetadata(SessionType.StructuralIdentifier.OmniSearch, SessionType.Metadata.OmniSearch.SearchSourceEvent, p10)
		end
	end
}
