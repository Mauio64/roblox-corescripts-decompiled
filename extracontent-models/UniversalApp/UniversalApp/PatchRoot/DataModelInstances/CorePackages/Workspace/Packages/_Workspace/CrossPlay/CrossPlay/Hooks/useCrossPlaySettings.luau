local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local React = require(CrossPlayParent.React)
local Cryo = require(CrossPlayParent.Cryo)
local useSelector = require(CrossPlayParent.RoactUtils).Hooks.RoactRodux.useSelector
local useCrossPlayApi = require(CrossPlay.Hooks.useCrossPlayApi)
local NetworkStatus = require(CrossPlay.Networking).roduxNetworking.Enum.NetworkStatus
local getCrossPlayIsEnabled = require(CrossPlay.Selectors.getCrossPlayIsEnabled)

local function useCrossPlaySettings() -- line: 10
	-- upvalues: useCrossPlayApi (copy), useSelector (copy), getCrossPlayIsEnabled (copy), Cryo (copy), NetworkStatus (copy), React (copy)
	local v10 = useCrossPlayApi()
	local v11 = useSelector(getCrossPlayIsEnabled)
	local v12 = useSelector(function(p1) -- line: 13
		-- upvalues: Cryo (copy), NetworkStatus (copy)
		local v22 = Cryo.Dictionary.values(p1.CrossPlaySettings.NetworkStatus)

		return Cryo.List.find(v22, NetworkStatus.Fetching) ~= nil
	end)
	local v13 = useSelector(function(p2) -- line: 18
		return p2.CrossPlaySettings.HttpError
	end)
	local v14 = useSelector(function(p3) -- line: 21
		return p3.CrossPlaySettings.DispatchError
	end)
	local v15 = useSelector(function(p4) -- line: 24
		return p4.CrossPlaySettings.SystemError
	end)
	local v16 = useSelector(function(p5) -- line: 28
		return p5.CrossPlaySettings.SystemPrivileges
	end)
	local v17 = v13 or (v14 or v15)
	local v18 = v17 ~= nil
	local v19 = v12 and not v17
	local v20 = React.useCallback(function() -- line: 36
		-- upvalues: v10 (copy), v11 (copy)
		return v10.update(not v11)
	end, {
		v10.update,
		v11
	})

	return {
		isEnabled = v11,
		systemPrivileges = v16,
		hasError = v18,
		isLoading = v19,
		toggle = v20,
		reload = v10.fetch,
		invokeSystemUi = v10.invokeSystemUi
	}
end

return useCrossPlaySettings
