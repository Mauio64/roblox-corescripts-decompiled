local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport

require(MediaGallery.MediaGalleryTypes)

local function useCarouselGamepadInput(data)
	local v = React.useCallback(function()
		if data.onFullscreenToggle then
			data.onFullscreenToggle()
		end
	end, { data.onFullscreenToggle })

	local v2 = React.useCallback(function()
		if data.isVideoActive then
			data.toggleMuteSignal:fire()
		end
	end, { data.toggleMuteSignal, data.isVideoActive })

	local useMemo = React.useMemo
	local function fn()
		local buttonL1 = Enum.KeyCode.ButtonL1
		local v4

		if not FFlagLuaAppMediaGalleryGamepadSupport then
			v4 = FocusNavigationEventNameEnum.TabBackward
		end

		local v3 = { [buttonL1] = v4 }

		local buttonR1 = Enum.KeyCode.ButtonR1
		local v5

		if not FFlagLuaAppMediaGalleryGamepadSupport then
			v5 = FocusNavigationEventNameEnum.TabForward
		end

		v3[buttonR1] = v5

		local buttonL2 = Enum.KeyCode.ButtonL2
		local v6

		if FFlagLuaAppMediaGalleryGamepadSupport then
			v6 = FocusNavigationEventNameEnum.PageBackward
		end

		v3[buttonL2] = v6

		local buttonR2 = Enum.KeyCode.ButtonR2
		local v7

		if FFlagLuaAppMediaGalleryGamepadSupport then
			v7 = FocusNavigationEventNameEnum.PageForward
		end

		v3[buttonR2] = v7

		local buttonA = Enum.KeyCode.ButtonA
		local v8

		if FFlagLuaAppMediaGalleryGamepadSupport and data.isVideoActive and data.isVideoReady then
			if data.isVideoPlaying then
				v8 = FocusNavigationEventNameEnum.PauseVideo
			else
				v8 = FocusNavigationEventNameEnum.PlayVideo
			end
		end

		v3[buttonA] = v8

		local buttonR3 = Enum.KeyCode.ButtonR3
		local v9

		if data.isFullscreen then
			v9 = FocusNavigationEventNameEnum.ExitFullscreen
		else
			v9 = FocusNavigationEventNameEnum.Fullscreen
		end

		v3[buttonR3] = v9

		local buttonL3 = Enum.KeyCode.ButtonL3
		local v10

		if data.isVideoActive then
			if data.isMuted then
				v10 = FocusNavigationEventNameEnum.Unmute
			else
				v10 = FocusNavigationEventNameEnum.Mute
			end
		end

		v3[buttonL3] = v10
		return v3
	end

	local isFullscreen = data.isFullscreen
	local isMuted = data.isMuted
	local isVideoActive = data.isVideoActive
	local isVideoPlaying

	if FFlagLuaAppMediaGalleryGamepadSupport then
		isVideoPlaying = data.isVideoPlaying
	end

	local v3

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v3 = data.isVideoReady
	end

	local v4 = useMemo(fn, { isFullscreen, isMuted, isVideoActive, isVideoPlaying, v3 })

	local v5 = React.useMemo(function()
		local v5 = {
			[FocusNavigationEventNameEnum.Fullscreen] = { handler = InputHandlers.onRelease(v) },
			[FocusNavigationEventNameEnum.ExitFullscreen] = { handler = InputHandlers.onRelease(v) },
			[FocusNavigationEventNameEnum.Mute] = { handler = InputHandlers.onRelease(v2) },
			[FocusNavigationEventNameEnum.Unmute] = { handler = InputHandlers.onRelease(v2) }
		}

		if FFlagLuaAppMediaGalleryGamepadSupport then
			v5[FocusNavigationEventNameEnum.PageBackward] = {
				handler = InputHandlers.onPress(data.scrollLeft)
			}

			v5[FocusNavigationEventNameEnum.PageForward] = {
				handler = InputHandlers.onPress(data.scrollRight)
			}

			v5[FocusNavigationEventNameEnum.PlayVideo] = {
				handler = InputHandlers.onRelease(function() end)
			}
			v5[FocusNavigationEventNameEnum.PauseVideo] = {
				handler = InputHandlers.onRelease(function() end)
			}
		else
			v5[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(data.scrollLeft)
			}

			v5[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(data.scrollRight)
			}
		end

		return v5
	end, { data.scrollLeft, data.scrollRight, v, v2 })

	local v6 = ReactFocusNavigation.useEventMap(v4)
	return (ReactFocusNavigation.useEventHandlerMap(v5, v6))
end

return useCarouselGamepadInput
