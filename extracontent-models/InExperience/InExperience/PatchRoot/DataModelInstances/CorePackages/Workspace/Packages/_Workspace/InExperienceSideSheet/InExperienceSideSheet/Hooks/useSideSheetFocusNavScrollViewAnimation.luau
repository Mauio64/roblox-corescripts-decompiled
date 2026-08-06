local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local React = require(InExperienceSideSheetParent.React)
local TweenDuration = require(InExperienceSideSheet.Common.Constants).TweenDuration
local GetDrawerVisibleStore = require(InExperienceSideSheetParent.Drawer).Stores.GetDrawerVisibleStore
local AnimateScrollViewToSelectionHelper = require(InExperienceSideSheetParent.AppBlox).AnimateScrollViewToSelectionHelper

local function useSideSheetFocusNavScrollViewAnimation() -- line: 13
	-- upvalues: React (copy), GetDrawerVisibleStore (copy), AnimateScrollViewToSelectionHelper (copy), TweenDuration (copy)
	local v8 = React.useRef({})
	local v9 = React.useRef(nil)
	local v10 = React.useRef(nil)
	local getDrawerAnimating = GetDrawerVisibleStore(false).getDrawerAnimating
	local v12 = React.useCallback(function() -- line: 19
		-- upvalues: v8 (copy), v9 (copy)
		if v8.current then
			for _, v15 in v8.current do
				v15:Disconnect()
			end

			v8.current = {}
		end

		if v9.current then
			v9.current:Cancel()
			v9.current = nil
		end
	end, {})
	local v13 = React.useCallback(function(p1) -- line: 32
		-- upvalues: v10 (copy), v12 (copy), v8 (copy), v9 (copy), AnimateScrollViewToSelectionHelper (copy), TweenDuration (copy), getDrawerAnimating (copy)
		if p1 == v10.current then
			return
		end

		if not p1 then
			v10.current = nil
			v12()

			return
		end

		v12()
		v10.current = p1

		local v17 = v8
		local v18 = v9
		local v19, v20 = AnimateScrollViewToSelectionHelper(p1, TweenDuration, getDrawerAnimating)

		v17.current = v19
		v18.current = v20
	end, {
		v8,
		v12,
		getDrawerAnimating
	})

	React.useEffect(function() -- line: 52
		-- upvalues: v12 (copy)
		return v12
	end, { v12 })

	return v13
end

return useSideSheetFocusNavScrollViewAnimation
