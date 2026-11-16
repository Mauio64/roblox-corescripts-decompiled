local ContentProvider = game:GetService("ContentProvider")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")

local function useImageLoadingState(p2)
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not p2 or p2 == "" then
			setState(false)
			return
		end

		if ContentProvider:GetAssetFetchStatus(p2) == Enum.AssetFetchStatus.Success then
			setState(true)
			return
		end

		setState(false)
		local v5 = true

		task.spawn(function()
			ContentProvider:PreloadAsync({ p2 }, function(p3, p4)
				if v5 and p3 == p2 and p4 == Enum.AssetFetchStatus.Success then
					setState(true)
				end
			end)
		end)

		return function()
			v5 = false
		end
	end, { p2 })

	return state
end

return useImageLoadingState
