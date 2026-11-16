local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local Wrappers = require(Foundation.Utility.Wrappers)
local ContentProvider = Wrappers.Services.ContentProvider

require(Foundation.Components.Types)

local function isFinalAssetFetchStatus(p): boolean -- 2 equivalent calls inferred from this helper
	return p == Enum.AssetFetchStatus.Success
		or p == Enum.AssetFetchStatus.Failure
		or p == Enum.AssetFetchStatus.TimedOut
end

local function attachOnLoaded(p: string?, handleFinalStatus)
	if p == nil then
		return
	end

	local assetFetchStatus = ContentProvider:GetAssetFetchStatus(p)

	if not isFinalAssetFetchStatus(assetFetchStatus) then -- inferred equivalent call
		return ContentProvider:GetAssetFetchStatusChangedSignal(p):Connect(function(p2)
			if isFinalAssetFetchStatus(p2) then -- inferred equivalent call
				handleFinalStatus(p2)
			end
		end)
	end

	handleFinalStatus(assetFetchStatus)
end

local function useOnLoaded(p, callback)
	React.useEffect(function()
		if not callback then
			return
		end

		local connection = nil
		local function disconnectConnection() -- 4 equivalent calls inferred from this helper
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end

		local function handleFinalStatus(p2)
			disconnectConnection() -- inferred equivalent call
			callback(p2)
		end

		if not ReactIs.isBinding(p) then
			connection = attachOnLoaded(p, handleFinalStatus)

			return function()
				disconnectConnection() -- inferred equivalent call
			end
		end

		local v = p
		connection = attachOnLoaded(v:getValue(), handleFinalStatus)

		local __subscribeToBinding = React.__subscribeToBinding(v, function(p2: string)
			disconnectConnection() -- inferred equivalent call
			connection = attachOnLoaded(p2, handleFinalStatus)
		end)

		return function()
			__subscribeToBinding()
			disconnectConnection() -- inferred equivalent call
		end
	end, { p, callback })
end

return useOnLoaded
