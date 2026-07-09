local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2, s1: string?) -- line: 5
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")({
		id = p2
	}), "GET"):andThen(function(p3) -- line: 8
		-- upvalues: s1 (copy)
		local v7 = p3.responseBody and (not not p3.responseBody.thumbnails and (not not p3.responseBody.thumbnails[1] and p3.responseBody.thumbnails[1].mediaId)) or nil

		if v7 then
			return "rbxassetid://" .. v7
		end

		return s1
	end, function() -- line: 20
		-- upvalues: s1 (copy)
		return s1
	end)
end
