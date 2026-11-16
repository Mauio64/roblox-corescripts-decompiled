local RunService = game:GetService("RunService")

local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)
local VideoUtils = require(parent.VideoUtils)
local getIsInstanceVisible = VideoUtils.getIsInstanceVisible

local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)
local VIDEO_VISIBLE_PERCENT = MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
local VISIBILITY_SCAN_DEBOUNCE_SEC = MediaGalleryConstants.VISIBILITY_SCAN_DEBOUNCE_SEC

local function useGuiObjectVisibility(p, flag: boolean, callback, callback2)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if not (flag and p.current) then
			return nil
		end

		local current = p.current

		local v = {}
		local thread = nil
		local v2 = 0

		local function getViewportBounds() -- 1 equivalent call inferred from this helper
			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				return { min = Vector2.new(0, 0), max = currentCamera.ViewportSize }
			end

			return nil
		end

		local function isVisible() -- 4 equivalent calls inferred from this helper
			local viewportBounds = getViewportBounds() -- inferred equivalent call

			if viewportBounds then
				return getIsInstanceVisible(current, viewportBounds, VIDEO_VISIBLE_PERCENT)
			end

			return false
		end

		local fn

		local function disconnectRenderStep() -- 2 equivalent calls inferred from this helper
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil

				if callback2 then
					callback2()
				end
			end
		end

		local function disconnectLayoutSignals()
			for _, connection in v do
				connection:Disconnect()
			end

			v = {}

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
				if isVisible() then -- inferred equivalent call
					if callback then
						callback(dt)
					end
				else
					disconnectRenderStep() -- inferred equivalent call
					fn()
				end
			end)
		end

		fn = function()
			if #v > 0 then
				return
			end

			local function onLayoutChange()
				if thread then
					return
				end

				local v3 = math.max(0, v2 + VISIBILITY_SCAN_DEBOUNCE_SEC - tick())

				if v3 > 0 then
					thread = task.delay(v3, function()
						thread = nil
						v2 = tick()

						if isVisible() then -- inferred equivalent call
							fn2()
						end
					end)
					return
				end

				v2 = tick()

				if isVisible() then -- inferred equivalent call
					fn2()
				end
			end

			v = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onLayoutChange)
			}
		end

		if isVisible() then -- inferred equivalent call
			fn2()
		else
			fn()
		end

		return function()
			disconnectLayoutSignals()
			disconnectRenderStep() -- inferred equivalent call
		end
	end, { flag, p, callback, callback2 })
end

return useGuiObjectVisibility
