local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/FocusNavigationUtils").FocusNavigationEventNameEnum
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/InputHandlers")

local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport

require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryTypes")

local function useCarouselGamepadInput(data)
	local v5 = React.useCallback(function()
		if data.onFullscreenToggle then
			data.onFullscreenToggle()
		end
	end, { data.onFullscreenToggle })

	local v6 = React.useCallback(function()
		if data.isVideoActive then
			data.toggleMuteSignal:fire()
		end
	end, { data.toggleMuteSignal, data.isVideoActive })

	local useMemo = React.useMemo
	local function fn()
		local buttonL1 = Enum.KeyCode.ButtonL1

		local v8 = if not fFlagLuaAppMediaGalleryGamepadSupport then focusNavigationEventNameEnum.TabBackward else nil
		local v7 = { [buttonL1] = v8 }

		local buttonR1 = Enum.KeyCode.ButtonR1

		local v9 = if not fFlagLuaAppMediaGalleryGamepadSupport then focusNavigationEventNameEnum.TabForward else nil
		v7[buttonR1] = v9

		local buttonL2 = Enum.KeyCode.ButtonL2
		local v10 = if fFlagLuaAppMediaGalleryGamepadSupport then focusNavigationEventNameEnum.PageBackward else nil
		v7[buttonL2] = v10

		local buttonR2 = Enum.KeyCode.ButtonR2
		local v11 = if fFlagLuaAppMediaGalleryGamepadSupport then focusNavigationEventNameEnum.PageForward else nil
		v7[buttonR2] = v11

		local buttonA = Enum.KeyCode.ButtonA
		local v12

		if fFlagLuaAppMediaGalleryGamepadSupport and data.isVideoActive and data.isVideoReady then
			if data.isVideoPlaying then
				v12 = focusNavigationEventNameEnum.PauseVideo
			else
				v12 = focusNavigationEventNameEnum.PlayVideo
			end
		end

		v7[buttonA] = v12

		local buttonR3 = Enum.KeyCode.ButtonR3
		local v13 = if data.isFullscreen then focusNavigationEventNameEnum.ExitFullscreen else focusNavigationEventNameEnum.Fullscreen
		v7[buttonR3] = v13

		local buttonL3 = Enum.KeyCode.ButtonL3
		local v14

		if data.isVideoActive then
			if data.isMuted then
				v14 = focusNavigationEventNameEnum.Unmute
			else
				v14 = focusNavigationEventNameEnum.Mute
			end
		end

		v7[buttonL3] = v14
		return v7
	end

	local isFullscreen = data.isFullscreen
	local isMuted = data.isMuted
	local isVideoActive = data.isVideoActive
	local isVideoPlaying = if fFlagLuaAppMediaGalleryGamepadSupport then data.isVideoPlaying else nil
	local v8 = if fFlagLuaAppMediaGalleryGamepadSupport then data.isVideoReady else nil
	local v9 = useMemo(fn, { isFullscreen, isMuted, isVideoActive, isVideoPlaying, v8 })

	local v10 = React.useMemo(function()
		local v11 = {
			[focusNavigationEventNameEnum.Fullscreen] = {
				handler = InputHandlers.onRelease(v5)
			},
			[focusNavigationEventNameEnum.ExitFullscreen] = {
				handler = InputHandlers.onRelease(v5)
			},
			[focusNavigationEventNameEnum.Mute] = { handler = InputHandlers.onRelease(v6) },
			[focusNavigationEventNameEnum.Unmute] = { handler = InputHandlers.onRelease(v6) }
		}

		if fFlagLuaAppMediaGalleryGamepadSupport then
			v11[focusNavigationEventNameEnum.PageBackward] = {
				handler = InputHandlers.onPress(data.scrollLeft)
			}

			v11[focusNavigationEventNameEnum.PageForward] = {
				handler = InputHandlers.onPress(data.scrollRight)
			}

			v11[focusNavigationEventNameEnum.PlayVideo] = {
				handler = InputHandlers.onRelease(function() end)
			}
			v11[focusNavigationEventNameEnum.PauseVideo] = {
				handler = InputHandlers.onRelease(function() end)
			}
		else
			v11[focusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(data.scrollLeft)
			}

			v11[focusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(data.scrollRight)
			}
		end

		return v11
	end, { data.scrollLeft, data.scrollRight, v5, v6 })

	local v11 = ReactFocusNavigation.useEventMap(v9)
	return ReactFocusNavigation.useEventHandlerMap(v10, v11)
end

return useCarouselGamepadInput
