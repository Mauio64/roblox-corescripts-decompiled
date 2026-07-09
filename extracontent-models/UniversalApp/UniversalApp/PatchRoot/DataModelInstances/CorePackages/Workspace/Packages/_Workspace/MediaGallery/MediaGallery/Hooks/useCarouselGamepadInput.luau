local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local FocusNavigationEventNameEnum = require(MediaGalleryParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local ReactFocusNavigation = require(MediaGalleryParent.ReactFocusNavigation)
local InputHandlers = require(MediaGalleryParent.InputHandlers)

require(MediaGallery.MediaGalleryTypes)

local function useCarouselGamepadInput(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy)
	local v9 = React.useCallback(function() -- line: 26
		-- upvalues: t1 (copy)
		if t1.onFullscreenToggle then
			t1.onFullscreenToggle()
		end
	end, { t1.onFullscreenToggle })
	local v10 = React.useCallback(function() -- line: 32
		-- upvalues: t1 (copy)
		if t1.isVideoActive then
			t1.toggleMuteSignal:fire()
		end
	end, {
		t1.toggleMuteSignal,
		t1.isVideoActive
	})
	local v11 = React.useMemo(function() -- line: 38
		-- upvalues: FocusNavigationEventNameEnum (copy), t1 (copy)
		return {
			[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward,
			[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward,
			[Enum.KeyCode.ButtonR3] = if not t1.isFullscreen then FocusNavigationEventNameEnum.Fullscreen else FocusNavigationEventNameEnum.ExitFullscreen,
			[Enum.KeyCode.ButtonL3] = if t1.isVideoActive then if not t1.isMuted then FocusNavigationEventNameEnum.Mute else FocusNavigationEventNameEnum.Unmute else nil
		}
	end, {
		t1.isFullscreen,
		t1.isMuted,
		t1.isVideoActive
	})
	local v12 = React.useMemo(function() -- line: 53
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy), v9 (copy), v10 (copy)
		return {
			[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(t1.scrollLeft)
			},
			[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(t1.scrollRight)
			},
			[FocusNavigationEventNameEnum.Fullscreen] = {
				handler = InputHandlers.onRelease(v9)
			},
			[FocusNavigationEventNameEnum.ExitFullscreen] = {
				handler = InputHandlers.onRelease(v9)
			},
			[FocusNavigationEventNameEnum.Mute] = {
				handler = InputHandlers.onRelease(v10)
			},
			[FocusNavigationEventNameEnum.Unmute] = {
				handler = InputHandlers.onRelease(v10)
			}
		}
	end, {
		t1.scrollLeft,
		t1.scrollRight,
		v9,
		v10
	})
	local v13 = ReactFocusNavigation.useEventMap(v11)

	return (ReactFocusNavigation.useEventHandlerMap(v12, v13))
end

return useCarouselGamepadInput
