local ContentProvider = game:GetService("ContentProvider")
local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)

local function useImageLoadingState(p: string?)
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not p or p == "" then
			setState(false)
			return
		end

		if ContentProvider:GetAssetFetchStatus(p) == Enum.AssetFetchStatus.Success then
			setState(true)
			return
		end

		setState(false)
		local v = true

		task.spawn(function()
			ContentProvider:PreloadAsync({ p }, function(p2, p3)
				if v and p2 == p and p3 == Enum.AssetFetchStatus.Success then
					setState(true)
				end
			end)
		end)

		return function()
			v = false
		end
	end, { p })

	return state
end

return useImageLoadingState
