local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)

local Constants = require(InExperienceSideSheet.Common.Constants)
local TweenDuration = Constants.TweenDuration

local Drawer = require(parent.Drawer)
local GetDrawerVisibleStore = Drawer.Stores.GetDrawerVisibleStore

local AppBlox = require(parent.AppBlox)
local AnimateScrollViewToSelectionHelper = AppBlox.AnimateScrollViewToSelectionHelper

local function useSideSheetFocusNavScrollViewAnimation()
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local getDrawerAnimating = GetDrawerVisibleStore(false).getDrawerAnimating

	local v = React.useCallback(function()
		if ref.current then
			for _, connection in ref.current do
				connection:Disconnect()
			end

			ref.current = {}
		end

		if ref2.current then
			ref2.current:Cancel()
			ref2.current = nil
		end
	end, {})

	local v2 = React.useCallback(function(current)
		if ref3.current == current then
			return
		end

		if current then
			v()
			ref3.current = current

			local current2, current3 = AnimateScrollViewToSelectionHelper(current, TweenDuration, getDrawerAnimating)
			ref.current = current2
			ref2.current = current3
		else
			ref3.current = nil
			v()
		end
	end, { ref, v, getDrawerAnimating })

	React.useEffect(function()
		return v
	end, { v })

	return v2
end

return useSideSheetFocusNavScrollViewAnimation
