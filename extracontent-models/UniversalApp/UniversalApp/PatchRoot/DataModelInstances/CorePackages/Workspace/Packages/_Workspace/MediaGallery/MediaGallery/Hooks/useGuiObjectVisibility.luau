local RunService = game:GetService("RunService")
local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local getIsInstanceVisible = require(MediaGalleryParent.VideoUtils).getIsInstanceVisible
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)
local VIDEO_VISIBLE_PERCENT = MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
local VISIBILITY_SCAN_DEBOUNCE_SEC = MediaGalleryConstants.VISIBILITY_SCAN_DEBOUNCE_SEC

local function useGuiObjectVisibility(t1: {[any]: any}, b1: boolean, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 24
	-- upvalues: React (copy), getIsInstanceVisible (copy), VIDEO_VISIBLE_PERCENT (copy), RunService (copy), VISIBILITY_SCAN_DEBOUNCE_SEC (copy)
	local v14 = React.useRef(nil)

	React.useEffect(function() -- line: 32
		-- upvalues: b1 (copy), t1 (copy), getIsInstanceVisible (copy), VIDEO_VISIBLE_PERCENT (copy), v14 (copy), p2 (copy), RunService (copy), p1 (copy), VISIBILITY_SCAN_DEBOUNCE_SEC (copy)
		if not b1 or not t1.current then
			return nil
		end

		local current = t1.current
		local t2 = {}
		local u17 = nil
		local n1 = 0

		local function getViewportBounds() -- line: 43
			local CurrentCamera = workspace.CurrentCamera

			if not CurrentCamera then
				return nil
			end

			return {
				min = Vector2.new(0, 0),
				max = CurrentCamera.ViewportSize
			}
		end
		local function isVisible() -- line: 51
			-- upvalues: getIsInstanceVisible (copy), current (copy), VIDEO_VISIBLE_PERCENT (copy)
			local CurrentCamera = workspace.CurrentCamera
			local v29 = if CurrentCamera then {
				min = Vector2.new(0, 0),
				max = CurrentCamera.ViewportSize
			} else nil

			if not v29 then
				return false
			end

			return getIsInstanceVisible(current, v29, VIDEO_VISIBLE_PERCENT)
		end

		local u21 = nil

		local function disconnectRenderStep() -- line: 62
			-- upvalues: v14 (copy), p2 (copy)
			if v14.current then
				v14.current:Disconnect()
				v14.current = nil

				if p2 then
					p2()
				end
			end
		end
		local function disconnectLayoutSignals() -- line: 72
			-- upvalues: t2 (ref), u17 (ref)
			for _, v31 in t2 do
				v31:Disconnect()
			end

			t2 = {}

			if u17 then
				task.cancel(u17)
				u17 = nil
			end
		end
		local function u24() -- line: 83
			-- upvalues: v14 (copy), disconnectLayoutSignals (copy), RunService (copy), getIsInstanceVisible (copy), current (copy), VIDEO_VISIBLE_PERCENT (copy), p1 (copy), p2 (copy), u21 (ref)
			if v14.current then
				return
			end

			disconnectLayoutSignals()
			v14.current = RunService.RenderStepped:Connect(function(dt) -- line: 90
				-- upvalues: getIsInstanceVisible (copy), current (copy), VIDEO_VISIBLE_PERCENT (copy), p1 (copy), v14 (copy), p2 (copy), u21 (ref)
				local CurrentCamera = workspace.CurrentCamera
				local v35 = if CurrentCamera then {
					min = Vector2.new(0, 0),
					max = CurrentCamera.ViewportSize
				} else nil

				if if v35 then getIsInstanceVisible(current, v35, VIDEO_VISIBLE_PERCENT) else false then
					if p1 then
						p1(dt)

						return
					end
				else
					if v14.current then
						v14.current:Disconnect()
						v14.current = nil

						if p2 then
							p2()
						end
					end

					u21()
				end
			end)
		end

		function u21() -- line: 102
			-- upvalues: t2 (ref), u17 (ref), n1 (ref), VISIBILITY_SCAN_DEBOUNCE_SEC (copy), getIsInstanceVisible (copy), current (copy), VIDEO_VISIBLE_PERCENT (copy), u24 (ref)
			if #t2 > 0 then
				return
			end

			local function onLayoutChange() -- line: 107
				-- upvalues: u17 (ref), n1 (ref), VISIBILITY_SCAN_DEBOUNCE_SEC (copy), getIsInstanceVisible (copy), current (copy), VIDEO_VISIBLE_PERCENT (copy), u24 (ref)
				if u17 then
					return
				end

				local v36 = math.max(0, n1 + VISIBILITY_SCAN_DEBOUNCE_SEC - tick())

				if v36 > 0 then
					u17 = task.delay(v36, function() -- line: 113
						-- upvalues: u17 (ref), n1 (ref), getIsInstanceVisible (copy), current (copy), VIDEO_VISIBLE_PERCENT (copy), u24 (ref)
						u17 = nil
						n1 = tick()

						local CurrentCamera = workspace.CurrentCamera
						local v40 = if CurrentCamera then {
							min = Vector2.new(0, 0),
							max = CurrentCamera.ViewportSize
						} else nil

						if if v40 then getIsInstanceVisible(current, v40, VIDEO_VISIBLE_PERCENT) else false then
							u24()
						end
					end)

					return
				end

				n1 = tick()

				local CurrentCamera = workspace.CurrentCamera
				local v38 = if CurrentCamera then {
					min = Vector2.new(0, 0),
					max = CurrentCamera.ViewportSize
				} else nil

				if if v38 then getIsInstanceVisible(current, v38, VIDEO_VISIBLE_PERCENT) else false then
					u24()
				end
			end

			t2 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onLayoutChange)
			}
		end

		local CurrentCamera = workspace.CurrentCamera
		local v26 = if CurrentCamera then {
			min = Vector2.new(0, 0),
			max = CurrentCamera.ViewportSize
		} else nil

		if if v26 then getIsInstanceVisible(current, v26, VIDEO_VISIBLE_PERCENT) else false then
			u24()
		else
			u21()
		end

		return function() -- line: 140
			-- upvalues: disconnectLayoutSignals (copy), v14 (copy), p2 (copy)
			disconnectLayoutSignals()

			if v14.current then
				v14.current:Disconnect()
				v14.current = nil

				if p2 then
					p2()
				end
			end
		end
	end, {
		b1,
		t1,
		p1,
		p2
	})
end

return useGuiObjectVisibility
