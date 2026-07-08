local ContentProvider = game:GetService("ContentProvider")
local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)

local function useImageLoadingState(s1: string?) -- line: 6
	-- upvalues: React (copy), ContentProvider (copy)
	local v6, v7 = React.useState(false)

	React.useEffect(function() -- line: 9
		-- upvalues: s1 (copy), v7 (copy), ContentProvider (copy)
		if not s1 or s1 == "" then
			v7(false)

			return
		end

		if ContentProvider:GetAssetFetchStatus(s1) == Enum.AssetFetchStatus.Success then
			v7(true)

			return
		end

		v7(false)

		local u8 = true

		task.spawn(function() -- line: 24
			-- upvalues: ContentProvider (copy), s1 (copy), u8 (ref), v7 (copy)
			ContentProvider:PreloadAsync({ s1 }, function(p1, p2) -- line: 25
				-- upvalues: u8 (ref), s1 (copy), v7 (copy)
				if u8 and (p1 == s1 and p2 == Enum.AssetFetchStatus.Success) then
					v7(true)
				end
			end)
		end)

		return function() -- line: 34
			-- upvalues: u8 (ref)
			u8 = false
		end
	end, { s1 })

	return v6
end

return useImageLoadingState
