local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local ContentProvider = game:GetService("ContentProvider")
local React = require(MomentsCommonParent.React)
local Signal = require(MomentsCommon.Utils.Signal)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useToggleState = require(MomentsCommon.Hooks.useToggleState)

local function useImageDisplay(_: boolean, p1) -- line: 22
	-- upvalues: useRef (copy), Signal (copy), useToggleState (copy), useEffect (copy), ContentProvider (copy), useCallback (copy)
	local v13 = useRef(nil)
	local v14 = useRef(nil)
	local v15 = useRef(false)
	local v16 = useRef(Signal.new())
	local v17 = useToggleState(false)

	useEffect(function() -- line: 33
		-- upvalues: v13 (copy), p1 (copy), v15 (copy), v14 (copy), ContentProvider (copy), v16 (copy)
		local current = v13.current

		if not current then
			return
		end

		if p1 then
			v15.current = false

			if p1.SourceType == Enum.ContentSourceType.Uri then
				v14.current = p1.Uri
				task.spawn(function() -- line: 44
					-- upvalues: ContentProvider (copy), p1 (copy), v14 (copy), v15 (copy), v16 (copy)
					ContentProvider:PreloadAsync({ p1.Uri }, function(_, p3) -- line: 45
						-- upvalues: v14 (copy), p1 (copy), v15 (copy), v16 (copy)
						if v14.current ~= p1.Uri then
							return
						end

						if p3 == Enum.AssetFetchStatus.Success then
							v15.current = true
							v16.current:fire()
						end
					end)
				end)
			end

			if p1.SourceType == Enum.ContentSourceType.Object then
				v15.current = true
				v16.current:fire()
			end

			current.ImageContent = p1
		end
	end, {
		v17.enabled,
		p1
	})

	local v18 = useCallback(function(p4) -- line: 67
		-- upvalues: v17 (copy), v13 (copy)
		v17.toggle()
		v13.current = p4
	end, { v17.toggle })

	return {
		isLoadedRef = v15,
		onImageLoadedSignalRef = v16,
		ref = v13,
		updateRef = v18
	}
end

return useImageDisplay
