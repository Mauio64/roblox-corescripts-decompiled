local ContentProvider = game:GetService("ContentProvider")
local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)

return function(s1: string?) -- line: 8
	-- upvalues: React (copy), ContentProvider (copy)
	local v5, v6 = React.useState(false)

	React.useEffect(function() -- line: 11
		-- upvalues: s1 (copy), v6 (copy), ContentProvider (copy)
		if not s1 or s1 == "" then
			v6(false)

			return
		end

		if ContentProvider:GetAssetFetchStatus(s1) == Enum.AssetFetchStatus.Success then
			v6(true)

			return
		end

		v6(false)

		local u7 = true

		task.spawn(function() -- line: 26
			-- upvalues: ContentProvider (copy), s1 (copy), u7 (ref), v6 (copy)
			ContentProvider:PreloadAsync({ s1 }, function(p1, p2) -- line: 27
				-- upvalues: u7 (ref), s1 (copy), v6 (copy)
				if u7 and (p1 == s1 and p2 == Enum.AssetFetchStatus.Success) then
					v6(true)
				end
			end)
		end)

		return function() -- line: 36
			-- upvalues: u7 (ref)
			u7 = false
		end
	end, { s1 })

	return v5
end
