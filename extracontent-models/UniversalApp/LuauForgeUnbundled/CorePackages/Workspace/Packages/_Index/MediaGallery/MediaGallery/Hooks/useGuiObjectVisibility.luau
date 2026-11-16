local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
local getIsInstanceVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/VideoUtils").getIsInstanceVisible

local MediaGalleryConstants = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants")
local VIDEO_VISIBLE_PERCENT = MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
local VISIBILITY_SCAN_DEBOUNCE_SEC = MediaGalleryConstants.VISIBILITY_SCAN_DEBOUNCE_SEC

local function useGuiObjectVisibility(p2, p3, callback, callback2)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if not (p3 and p2.current) then
			return nil
		end

		local current = p2.current

		local v5 = {}
		local thread = nil
		local v6 = 0

		local function getViewportBounds()
			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				return { min = Vector2.new(0, 0), max = currentCamera.ViewportSize }
			end

			return nil
		end

		local function isVisible()
			local currentCamera = workspace.CurrentCamera

			local v7 = currentCamera and {
					min = Vector2.new(0, 0),
					max = currentCamera.ViewportSize
				}
				or nil

			if v7 then
				return getIsInstanceVisible(current, v7, VIDEO_VISIBLE_PERCENT)
			end

			return false
		end

		local fn

		local function disconnectRenderStep()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil

				if callback2 then
					callback2()
				end
			end
		end

		local function disconnectLayoutSignals()
			for k, connection in v5 do
				connection:Disconnect()
			end

			v5 = {}

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end

		local function fn2()
			if ref.current then
				return
			end

			disconnectLayoutSignals()

			ref.current = RunService.RenderStepped:Connect(function(dt)
				local currentCamera = workspace.CurrentCamera

				local v7 = currentCamera
					and { min = Vector2.new(0, 0), max = currentCamera.ViewportSize }
					or nil

				local v8 = if v7 then getIsInstanceVisible(current, v7, VIDEO_VISIBLE_PERCENT) else false

				if v8 then
					if callback then
						callback(dt)
					end
				else
					if ref.current then
						ref.current:Disconnect()
						ref.current = nil

						if callback2 then
							callback2()
						end
					end

					fn()
				end
			end)
		end

		fn = function()
			if #v5 > 0 then
				return
			end

			local function onLayoutChange()
				if thread then
					return
				end

				local v7 = math.max(0, v6 + VISIBILITY_SCAN_DEBOUNCE_SEC - tick())

				if v7 > 0 then
					thread = task.delay(v7, function()
						thread = nil
						v6 = tick()
						local currentCamera = workspace.CurrentCamera

						local v8 = currentCamera
							and {
								min = Vector2.new(0, 0),
								max = currentCamera.ViewportSize
							}
							or nil

						local v9 = if v8 then getIsInstanceVisible(current, v8, VIDEO_VISIBLE_PERCENT) else false

						if v9 then
							fn2()
						end
					end)
					return
				end

				v6 = tick()
				local currentCamera = workspace.CurrentCamera

				local v8 = currentCamera
					and { min = Vector2.new(0, 0), max = currentCamera.ViewportSize }
					or nil

				local v9 = if v8 then getIsInstanceVisible(current, v8, VIDEO_VISIBLE_PERCENT) else false

				if v9 then
					fn2()
				end
			end

			v5 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onLayoutChange)
			}
		end

		local currentCamera = workspace.CurrentCamera

		local v7 = currentCamera and {
			min = Vector2.new(0, 0),
			max = currentCamera.ViewportSize
		} or nil

		local v8 = if v7 then getIsInstanceVisible(current, v7, VIDEO_VISIBLE_PERCENT) else false

		if v8 then
			fn2()
		else
			fn()
		end

		return function()
			disconnectLayoutSignals()

			if ref.current then
				ref.current:Disconnect()
				ref.current = nil

				if callback2 then
					callback2()
				end
			end
		end
	end, { p3, p2, callback, callback2 })
end

return useGuiObjectVisibility
