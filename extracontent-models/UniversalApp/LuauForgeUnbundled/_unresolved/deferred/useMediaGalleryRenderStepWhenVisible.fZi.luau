local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local React = require(CorePackages.Packages.React)

local getIsInstanceVisible = require("@luauforge/bundled/fZd").getIsInstanceVisible
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagLuaAppEdpMediaGalleryRedesign = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesign

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fIntLuaAppEdpMediaGalleryItemVisiblePercent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntLuaAppEdpMediaGalleryItemVisiblePercent

local function useMediaGalleryRenderStepWhenVisible(p2, p3, p4, p5, onRenderStepped, callback, p6, p7)
	local v5

	if fFlagLuaAppEdpMediaGalleryRedesign then
		v5 = not fFlagLuaAppEdpMediaGalleryRedesignIxp or p6
	else
		v5 = nil
	end

	local v6

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v6 = not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp or p7
	else
		v6 = nil
	end

	local v7 = useSelector(function(p8)
		return p8.ScreenSize
	end)

	local v8 = useSelector(function(p8)
		return p8.TopBar.topBarHeight
	end)

	local v9 = useSelector(function(p8)
		return p8.GlobalGuiInset
	end)

	local v10 = React.useMemo(function()
		return {
			min = Vector2.new(0, v8),
			max = Vector2.new(v7.X, v7.Y - v9.bottom)
		}
	end, { v7, v8, v9 })

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local useEffect = React.useEffect
	local function fn()
		if
			not v5
			or fFlagLuaAppEdpMediaGalleryFullScreen and (p2 or p3)
			or fFlagLuaAppEdpMediaGalleryVideoPreview and v6 and p4
		then
			return nil
		end

		local v11

		if p5.current == nil then
			v11 = {}
		else
			local current = p5.current
			local now = nil
			local v12 = nil

			local function connectRenderStepIfVisible()
				now = tick()

				if getIsInstanceVisible(current, v10, fIntLuaAppEdpMediaGalleryItemVisiblePercent) then
					if not ref.current then
						ref.current = RunService.RenderStepped:Connect(onRenderStepped)
					end
				elseif ref.current then
					ref.current:Disconnect()
					ref.current = nil

					if callback then
						callback()
					end
				end
			end

			local function onScrollingFrameLayoutChange()
				if v12 ~= nil then
					return
				end

				local v13

				if now == nil then
					v13 = 0
				else
					v12 = now + 0.5
					v13 = v12 - tick()
				end

				if v13 > 0 then
					ref2.current = task.delay(v13, function()
						v12 = nil
						connectRenderStepIfVisible()
					end)
					return
				end

				v12 = nil
				connectRenderStepIfVisible()
			end

			connectRenderStepIfVisible()

			v11 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onScrollingFrameLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onScrollingFrameLayoutChange)
			}
		end

		return function()
			for k, connection in v11 do
				connection:Disconnect()
			end

			if ref.current then
				ref.current:Disconnect()
				ref.current = nil

				if callback then
					callback()
				end
			end

			if ref2.current then
				task.cancel(ref2.current)
				ref2.current = nil
			end
		end
	end

	local v12 = if fFlagLuaAppEdpMediaGalleryFullScreen then p2 else nil
	local v13 = if fFlagLuaAppEdpMediaGalleryFullScreen then p3 else nil
	local v14 = if fFlagLuaAppEdpMediaGalleryVideoPreview and v6 then p4 else nil
	local v15 = if fFlagLuaAppEdpMediaGalleryRedesign then v5 else nil
	useEffect(fn, {
		v12,
		v13,
		v14,
		p5,
		onRenderStepped,
		callback,
		v15,
		if fFlagLuaAppEdpMediaGalleryVideoPreview then v6 else nil,
		v10
	})
end

return useMediaGalleryRenderStepWhenVisible
