local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local useImmersiveChrome = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/useImmersiveChrome")
local usePreferredInput = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/usePreferredInput")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")

local mediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local formFactor = MomentsCommon.Enums.FormFactor
local usePreferences = Foundation.Hooks.usePreferences

local function ImmersiveChromeController(data): nil
	local pager = data.pager
	local v5 = mediaPreloadProvider.useMediaControllerProvider()
	local v6 = usePreferredInput()
	local v7 = useFormFactor()
	local reducedMotion = usePreferences().reducedMotion

	local v8 = v6 == Enum.PreferredInput.Touch and v7 == formFactor.MobilePortrait

	local v9 = React.useMemo(function()
		return function(p2)
			if v5 == nil then
				return true
			end

			local currentItem = pager.getCurrentItem(p2)

			if currentItem == nil or currentItem.kind ~= "moment" then
				return true
			end

			local momentId = currentItem.moment.momentId
			local v10 = v5.getControllerMap(p2)[momentId]

			if v10 == nil then
				return true
			end

			return v10.getState(p2).isPlaying
		end
	end, { pager, v5 })

	local v10 = React.useMemo(function()
		return function(p2): boolean
			local current = data.controllerRef.current

			if current == nil then
				return false
			end

			return current.getScrollState(p2) ~= "Idle"
		end
	end, { data.controllerRef })

	useImmersiveChrome({
		pager = pager,
		active = data.active,
		getActiveIsPlaying = v9,
		getIsScrolling = v10,
		inputAllowed = v8,
		reducedMotion = reducedMotion,
		coveringOverlay = data.coveringOverlay
	})

	return nil
end

return ImmersiveChromeController
