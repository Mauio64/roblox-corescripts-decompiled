local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local v4 = game:DefineFastFlag("RemoveDuplicatesPlaceMediaAssets", false)

return function(p1, s1: string) -- line: 9
	-- upvalues: Url (copy), v4 (copy), Promise (copy)
	local t1 = {}
	local t2 = {}

	return p1(string.format("%sv2/games/%s/media", Url.GAME_URL, s1), "GET"):andThen(function(p2) -- line: 16
		-- upvalues: v4 (copy), t2 (copy), t1 (copy)
		if p2 and (p2.responseBody and p2.responseBody.data) then
			for _, v in ipairs(p2.responseBody.data) do
				if v.imageId then
					if v4 then
						local str = tostring(v.imageId)

						if not t2[str] then
							t2[str] = true
							table.insert(t1, str)
						end
					else
						table.insert(t1, (tostring(v.imageId)))
					end
				end
			end
		end
	end):finally(function() -- line: 33
		-- upvalues: Promise (copy), t1 (copy)
		return Promise.resolve(t1)
	end)
end
