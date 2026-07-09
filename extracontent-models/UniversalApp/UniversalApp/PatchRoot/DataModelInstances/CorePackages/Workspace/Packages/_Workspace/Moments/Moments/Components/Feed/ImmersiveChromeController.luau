local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)

require(MomentsParent.Signals)

local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(script.Parent.FeedTypes)

local useImmersiveChrome = require(script.Parent.useImmersiveChrome)
local usePreferredInput = require(Moments.Hooks.usePreferredInput)

require(Moments.Components.VerticalPager)

local MediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local FormFactor = MomentsCommon.Enums.FormFactor
local usePreferences = Foundation.Hooks.usePreferences

local function ImmersiveChromeController(t1: {[any]: any}) -- line: 50
	-- upvalues: MediaPreloadProvider (copy), usePreferredInput (copy), useFormFactor (copy), usePreferences (copy), FormFactor (copy), React (copy), useImmersiveChrome (copy)
	local pager = t1.pager
	local v15 = MediaPreloadProvider.useMediaControllerProvider()
	local v16 = usePreferredInput()
	local v17 = useFormFactor()
	local reducedMotion = usePreferences().reducedMotion
	local v19 = v16 == Enum.PreferredInput.Touch and v17 == FormFactor.MobilePortrait
	local v20 = React.useMemo(function() -- line: 64
		-- upvalues: v15 (copy), pager (copy)
		return function(p1) -- line: 65
			-- upvalues: v15 (copy), pager (copy)
			if v15 == nil then
				return true
			end

			local v23 = pager.getCurrentItem(p1)

			if v23 == nil or v23.kind ~= "moment" then
				return true
			end

			local momentId = v23.moment.momentId
			local v25 = v15.getControllerMap(p1)[momentId]

			if v25 == nil then
				return true
			end

			return v25.getState(p1).isPlaying
		end
	end, {
		pager,
		v15
	})
	local v21 = React.useMemo(function() -- line: 85
		-- upvalues: t1 (copy)
		return function(p2) -- line: 86
			-- upvalues: t1 (copy)
			local current = t1.controllerRef.current

			if current == nil then
				return false
			end

			return current.getScrollState(p2) ~= "Idle"
		end
	end, { t1.controllerRef })

	useImmersiveChrome({
		pager = pager,
		active = t1.active,
		getActiveIsPlaying = v20,
		getIsScrolling = v21,
		inputAllowed = v19,
		reducedMotion = reducedMotion
	})

	return nil
end

return ImmersiveChromeController
