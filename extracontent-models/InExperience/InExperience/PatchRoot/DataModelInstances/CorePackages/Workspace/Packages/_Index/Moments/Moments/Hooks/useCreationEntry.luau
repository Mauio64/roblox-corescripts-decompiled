local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local AppTabBarRodux = require(MomentsParent.AppTabBarRodux)
local useDispatch = require(MomentsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible
local createGalleryCaptureSource = require(Moments.Capture.createGalleryCaptureSource)
local isStudio = require(MomentsParent.MomentsCommon.isStudio)
local hasGalleryApi = require(Moments.Capture.hasGalleryApi)

local function useCreationEntry() -- line: 41
	-- upvalues: React (copy), useDispatch (copy), isStudio (copy), hasGalleryApi (copy), createGalleryCaptureSource (copy), SetTabBarVisible (copy)
	local v11, v12 = React.useState(false)
	local v13, v14 = React.useState(false)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(false)
	local v17 = useDispatch()
	local v18 = isStudio()
	local v19 = hasGalleryApi()
	local v20 = v18 or not v19
	local v21 = React.useCallback(function() -- line: 53
		-- upvalues: v20 (copy), v12 (copy), v16 (copy), v15 (copy), createGalleryCaptureSource (copy), v14 (copy)
		if v20 then
			v12(true)

			return
		end

		if v16.current then
			return
		end

		v16.current = true
		task.spawn(function() -- line: 63
			-- upvalues: v15 (copy), createGalleryCaptureSource (copy), v16 (copy), v14 (copy), v12 (copy)
			v15.current = createGalleryCaptureSource(nil, function(p1, p2) -- line: 64
				-- upvalues: v16 (copy), v14 (copy), v12 (copy)
				v16.current = false

				if p2 and #p1 == 0 then
					v14(true)

					return
				end

				v12(true)
			end)
		end)
	end, { v20 })

	React.useEffect(function() -- line: 75
		-- upvalues: v11 (copy), v17 (copy), SetTabBarVisible (copy)
		if v11 then
			v17(SetTabBarVisible(false))
		end

		return function() -- line: 79
			-- upvalues: v11 (copy), v17 (copy), SetTabBarVisible (copy)
			if v11 then
				v17(SetTabBarVisible(true))
			end
		end
	end, {
		v11,
		v17
	})

	local v22 = React.useCallback(function() -- line: 86
		-- upvalues: v15 (copy), v12 (copy)
		v15.current = nil
		v12(false)
	end, {})
	local v23 = React.useCallback(function() -- line: 91
		-- upvalues: v15 (copy), v14 (copy)
		v15.current = nil
		v14(false)
	end, {})

	return {
		isCreating = v11,
		showFtux = not v20 and v13,
		captureSource = if not v20 then v15.current else nil,
		onCreatePressed = v21,
		onExitCreation = v22,
		onExitFtux = v23
	}
end

return useCreationEntry
