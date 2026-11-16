local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local ContentProvider = game:GetService("ContentProvider")

local React = require(parent.React)

local Signal = require(MomentsCommon.Utils.Signal)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useToggleState = require(MomentsCommon.Hooks.useToggleState)

local function useImageDisplay(_: boolean, imageContent)
	local ref = useRef(nil)
	local v = useRef(nil)

	local isLoadedRef = useRef(false)

	local onImageLoadedSignalRef = useRef(Signal.new())

	local v2 = useToggleState(false)

	useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		if imageContent then
			isLoadedRef.current = false

			if imageContent.SourceType == Enum.ContentSourceType.Uri then
				v.current = imageContent.Uri
				task.spawn(function()
					ContentProvider:PreloadAsync({ imageContent.Uri }, function(_, p)
						if v.current ~= imageContent.Uri then
							return
						end

						if p == Enum.AssetFetchStatus.Success then
							isLoadedRef.current = true
							onImageLoadedSignalRef.current:fire()
						end
					end)
				end)
			end

			if imageContent.SourceType == Enum.ContentSourceType.Object then
				isLoadedRef.current = true
				onImageLoadedSignalRef.current:fire()
			end

			current.ImageContent = imageContent
		end
	end, { v2.enabled, imageContent })

	return {
		isLoadedRef = isLoadedRef,
		onImageLoadedSignalRef = onImageLoadedSignalRef,
		ref = ref,
		updateRef = useCallback(function(current)
			v2.toggle()
			ref.current = current
		end, { v2.toggle })
	}
end

return useImageDisplay
