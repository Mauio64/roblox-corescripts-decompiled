local parent = script:FindFirstAncestor("RoactUtils").Parent

local ContentProvider = game:GetService("ContentProvider")

local React = require(parent.React)

local function useAssetFetchStatus(p: string?)
	local state, setState = React.useState(Enum.AssetFetchStatus.None)

	React.useEffect(function()
		setState(Enum.AssetFetchStatus.None)

		if not p or p == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(p):Connect(function(p2)
			setState(p2)
		end)

		setState((ContentProvider:GetAssetFetchStatus(p)))

		return function()
			connection:Disconnect()
		end
	end, { p })

	return state
end

return useAssetFetchStatus
