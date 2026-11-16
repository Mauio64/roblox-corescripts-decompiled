local ContentProvider = game:GetService("ContentProvider")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local function useAssetFetchStatus(p2)
	local state, setState = React.useState(Enum.AssetFetchStatus.None)

	React.useEffect(function()
		setState(Enum.AssetFetchStatus.None)

		if not p2 or p2 == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(p2):Connect(function(p3)
			setState(p3)
		end)

		setState((ContentProvider:GetAssetFetchStatus(p2)))

		return function()
			connection:Disconnect()
		end
	end, { p2 })

	return state
end

return useAssetFetchStatus
