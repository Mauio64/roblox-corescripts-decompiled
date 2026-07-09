local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local getIsInstanceVisible = require(CorePackages.Workspace.Packages.VideoUtils).getIsInstanceVisible
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagLuaAppEdpMediaGalleryRedesign = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesign
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagLuaAppEdpMediaGalleryFullScreen = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FIntLuaAppEdpMediaGalleryItemVisiblePercent = require(CorePackages.Workspace.Packages.SharedFlags).FIntLuaAppEdpMediaGalleryItemVisiblePercent

local function useMediaGalleryRenderStepWhenVisible(b1: boolean?, b2: boolean?, b3: boolean?, t1: {[any]: any}, p1: ((...any) -> ...any), p2: ((...any) -> ...any)?, b4: boolean?, b5: boolean?) -- line: 26
	-- upvalues: FFlagLuaAppEdpMediaGalleryRedesign (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), useSelector (copy), React (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), getIsInstanceVisible (copy), FIntLuaAppEdpMediaGalleryItemVisiblePercent (copy), RunService (copy)
	local v21 = if not FFlagLuaAppEdpMediaGalleryRedesign then nil else not FFlagLuaAppEdpMediaGalleryRedesignIxp or b4
	local v22 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp or b5
	local v23 = useSelector(function(p3) -- line: 44
		return p3.ScreenSize
	end)
	local v24 = useSelector(function(p4) -- line: 48
		return p4.TopBar.topBarHeight
	end)
	local v25 = useSelector(function(p5) -- line: 52
		return p5.GlobalGuiInset
	end)
	local v26 = React.useMemo(function() -- line: 56
		-- upvalues: v24 (copy), v23 (copy), v25 (copy)
		return {
			min = Vector2.new(0, v24),
			max = Vector2.new(v23.X, v23.Y - v25.bottom)
		}
	end, {
		v23,
		v24,
		v25
	})
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)

	React.useEffect(function() -- line: 67
		-- upvalues: v21 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), b1 (copy), b2 (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), v22 (copy), b3 (copy), t1 (copy), getIsInstanceVisible (copy), v26 (copy), FIntLuaAppEdpMediaGalleryItemVisiblePercent (copy), v27 (copy), RunService (copy), p1 (copy), p2 (copy), v28 (copy)
		if not v21 or (FFlagLuaAppEdpMediaGalleryFullScreen and (b1 or b2) or FFlagLuaAppEdpMediaGalleryVideoPreview and v22 and b3) then
			return nil
		end

		local t2 = {}

		if t1.current ~= nil then
			local current = t1.current
			local timestamp = nil
			local u35 = nil

			local function connectRenderStepIfVisible() -- line: 83
				-- upvalues: timestamp (ref), getIsInstanceVisible (copy), current (copy), v26 (copy), FIntLuaAppEdpMediaGalleryItemVisiblePercent (copy), v27 (copy), RunService (copy), p1 (copy), p2 (copy)
				timestamp = tick()

				if getIsInstanceVisible(current, v26, FIntLuaAppEdpMediaGalleryItemVisiblePercent) then
					if not v27.current then
						v27.current = RunService.RenderStepped:Connect(p1)

						return
					end
				elseif v27.current then
					v27.current:Disconnect()
					v27.current = nil

					if p2 then
						p2()
					end
				end
			end
			local function onScrollingFrameLayoutChange() -- line: 108
				-- upvalues: u35 (ref), timestamp (ref), connectRenderStepIfVisible (copy), v28 (copy)
				if u35 ~= nil then
					return
				end

				local n1 = 0

				if timestamp ~= nil then
					u35 = timestamp + 0.5
					n1 = u35 - tick()
				end

				if n1 > 0 then
					v28.current = task.delay(n1, function() -- line: 121
						-- upvalues: u35 (ref), connectRenderStepIfVisible (copy)
						u35 = nil
						connectRenderStepIfVisible()
					end)

					return
				end

				u35 = nil
				connectRenderStepIfVisible()
			end

			connectRenderStepIfVisible()
			t2 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onScrollingFrameLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onScrollingFrameLayoutChange)
			}
		end

		return function() -- line: 141
			-- upvalues: t2 (ref), v27 (copy), p2 (copy), v28 (copy)
			for _, v40 in t2 do
				v40:Disconnect()
			end

			if v27.current then
				v27.current:Disconnect()
				v27.current = nil

				if p2 then
					p2()
				end
			end

			if v28.current then
				task.cancel(v28.current)
				v28.current = nil
			end
		end
	end, {
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else b1,
		if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else b2,
		if not FFlagLuaAppEdpMediaGalleryVideoPreview or not v22 then nil else b3,
		t1,
		p1,
		p2,
		if not FFlagLuaAppEdpMediaGalleryRedesign then nil else v21,
		if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else v22,
		v26
	})
end

return useMediaGalleryRenderStepWhenVisible
