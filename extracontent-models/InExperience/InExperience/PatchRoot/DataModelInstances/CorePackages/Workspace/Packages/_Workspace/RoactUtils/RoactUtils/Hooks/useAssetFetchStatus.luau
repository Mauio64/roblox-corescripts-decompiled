local Parent = script:FindFirstAncestor("RoactUtils").Parent
local ContentProvider = game:GetService("ContentProvider")
local React = require(Parent.React)

local function useAssetFetchStatus(s1: string?) -- line: 8
	-- upvalues: React (copy), ContentProvider (copy)
	local v6, v7 = React.useState(Enum.AssetFetchStatus.None)

	React.useEffect(function() -- line: 11
		-- upvalues: v7 (copy), s1 (copy), ContentProvider (copy)
		v7(Enum.AssetFetchStatus.None)

		if not s1 or s1 == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(s1):Connect(function(p1) -- line: 18
			-- upvalues: v7 (copy)
			v7(p1)
		end)
		local AssetFetchStatus = ContentProvider:GetAssetFetchStatus(s1)

		v7(AssetFetchStatus)

		return function() -- line: 25
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { s1 })

	return v6
end

return useAssetFetchStatus
