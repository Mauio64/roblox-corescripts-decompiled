local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
require(parent.Signals)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)

require(script.Parent.FeedTypes)
local useImmersiveChrome = require(script.Parent.useImmersiveChrome)
local usePreferredInput = require(Moments.Hooks.usePreferredInput)
require(Moments.Components.VerticalPager)

local MediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local FormFactor = MomentsCommon.Enums.FormFactor
local usePreferences = Foundation.Hooks.usePreferences

local function ImmersiveChromeController(data): nil
	local pager = data.pager
	local v = MediaPreloadProvider.useMediaControllerProvider()
	local v2 = usePreferredInput()
	local v3 = useFormFactor()
	local reducedMotion = usePreferences().reducedMotion
	local inputAllowed

	if v2 == Enum.PreferredInput.Touch then
		inputAllowed = v3 == FormFactor.MobilePortrait
	else
		inputAllowed = false
	end

	local getActiveIsPlaying = React.useMemo(function()
		return function(p)
			if v == nil then
				return true
			end

			local currentItem = pager.getCurrentItem(p)

			if currentItem == nil or currentItem.kind ~= "moment" then
				return true
			end

			local momentId = currentItem.moment.momentId
			local v4 = v.getControllerMap(p)[momentId]
			return v4 == nil or v4.getState(p).isPlaying
		end
	end, { pager, v })

	local getIsScrolling = React.useMemo(function()
		return function(p): boolean
			local current = data.controllerRef.current

			return current ~= nil and current.getScrollState(p) ~= "Idle"
		end
	end, { data.controllerRef })

	useImmersiveChrome({
		pager = pager,
		active = data.active,
		getActiveIsPlaying = getActiveIsPlaying,
		getIsScrolling = getIsScrolling,
		inputAllowed = inputAllowed,
		reducedMotion = reducedMotion,
		coveringOverlay = data.coveringOverlay
	})

	return nil
end

return ImmersiveChromeController
