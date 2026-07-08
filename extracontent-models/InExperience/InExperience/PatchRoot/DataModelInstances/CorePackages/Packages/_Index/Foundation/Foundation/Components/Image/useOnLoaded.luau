local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local ContentProvider = require(Foundation.Utility.Wrappers).Services.ContentProvider

require(Foundation.Components.Types)

local function isFinalAssetFetchStatus(p1) -- line: 21
	return p1 == Enum.AssetFetchStatus.Success or (p1 == Enum.AssetFetchStatus.Failure or p1 == Enum.AssetFetchStatus.TimedOut)
end
local function attachOnLoaded(s1: string?, p2: ((...any) -> ...any)) -- line: 27
	-- upvalues: ContentProvider (copy)
	if s1 == nil then
		return
	end

	local AssetFetchStatus = ContentProvider:GetAssetFetchStatus(s1)

	if AssetFetchStatus == Enum.AssetFetchStatus.Success or (AssetFetchStatus == Enum.AssetFetchStatus.Failure or AssetFetchStatus == Enum.AssetFetchStatus.TimedOut) then
		p2(AssetFetchStatus)

		return
	end

	return ContentProvider:GetAssetFetchStatusChangedSignal(s1):Connect(function(p3) -- line: 41
		-- upvalues: p2 (copy)
		if p3 == Enum.AssetFetchStatus.Success or (p3 == Enum.AssetFetchStatus.Failure or p3 == Enum.AssetFetchStatus.TimedOut) then
			p2(p3)
		end
	end)
end
local function useOnLoaded(p4, p5: ((...any) -> ...any)?) -- line: 48
	-- upvalues: React (copy), ReactIs (copy), attachOnLoaded (copy)
	React.useEffect(function() -- line: 49
		-- upvalues: p5 (copy), ReactIs (copy), p4 (copy), attachOnLoaded (copy), React (copy)
		if not p5 then
			return
		end

		local u16 = nil

		local function disconnectConnection() -- line: 55
			-- upvalues: u16 (ref)
			if u16 then
				u16:Disconnect()
				u16 = nil
			end
		end
		local function handleFinalStatus(p6) -- line: 62
			-- upvalues: u16 (ref), p5 (copy)
			if u16 then
				u16:Disconnect()
				u16 = nil
			end

			p5(p6)
		end

		if ReactIs.isBinding(p4) then
			local v19 = p4

			u16 = attachOnLoaded(v19:getValue(), handleFinalStatus)

			local v20 = React.__subscribeToBinding(v19, function(s2: string) -- line: 71
				-- upvalues: u16 (ref), attachOnLoaded (copy), handleFinalStatus (copy)
				if u16 then
					u16:Disconnect()
					u16 = nil
				end

				u16 = attachOnLoaded(s2, handleFinalStatus)
			end)

			return function() -- line: 76
				-- upvalues: v20 (copy), u16 (ref)
				v20()

				if u16 then
					u16:Disconnect()
					u16 = nil
				end
			end
		end

		local v21 = p4

		u16 = attachOnLoaded(v21, handleFinalStatus)

		return function() -- line: 84
			-- upvalues: u16 (ref)
			if u16 then
				u16:Disconnect()
				u16 = nil
			end
		end
	end, {
		p4,
		p5
	})
end

return useOnLoaded
