local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local CoreGui = game:GetService("CoreGui")
local Dash = require(parent.Dash)
local UnifiedEventLogConstants = require(script.Parent.Parent.UnifiedEventLogConstants)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local SharedFlags = require(parent.SharedFlags)
local FFlagCleanupTenFootUiPaddingAndAnalytics = SharedFlags.FFlagCleanupTenFootUiPaddingAndAnalytics

local UnifiedEventLoggingUtils = {}
local function getParentScrollingFrames(scrollingFrame, scrollingFrames)
	local scrollingFrames2 = scrollingFrames or {}

	local scrollingFrame2 = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")

	if not scrollingFrame2 then
		return scrollingFrames2
	end

	table.insert(scrollingFrames2, scrollingFrame2)
	return getParentScrollingFrames(scrollingFrame2, scrollingFrames2)
end

function UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(value)
	local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
	return value.sub(value, string.len(ATTRIBUTE_PREFIX) + 1, (string.len(value)))
end

function UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(p)
	return Dash.startsWith(p, UnifiedEventLogConstants.ATTRIBUTE_PREFIX)
end

function UnifiedEventLoggingUtils.formatLookTypeAttribute(p)
	return string.upper("LOOK_TYPE_" .. p)
end

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(items)
		local fieldsToSend = {}

		if items then
			for k, item in items do
				if UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(k) then
					fieldsToSend[UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(k)] = item
				end
			end
		end

		return fieldsToSend
	end
end

function UnifiedEventLoggingUtils.getElementSizeAndPosition(instance)
	local x = instance.AbsolutePosition.X
	local y = instance.AbsolutePosition.Y
	local scrollingFrames = nil or {}

	local scrollingFrame = instance:FindFirstAncestorWhichIsA("ScrollingFrame")

	if scrollingFrame then
		table.insert(scrollingFrames, scrollingFrame)
		scrollingFrames = getParentScrollingFrames(scrollingFrame, scrollingFrames)
	end

	if scrollingFrames then
		for _, v in scrollingFrames do
			x += v.CanvasPosition.X
			y += v.CanvasPosition.Y
		end
	end

	return {
		elementSizeWidth = math.round(instance.AbsoluteSize.X),
		elementSizeHeight = math.round(instance.AbsoluteSize.Y),
		elementCoordinatesX = math.round(instance.AbsolutePosition.X),
		elementCoordinatesY = math.round(instance.AbsolutePosition.Y),
		elementRelativePositionX = math.round(x),
		elementRelativePositionY = math.round(y)
	}
end

function UnifiedEventLoggingUtils.getScreenSize(instance)
	local v = nil
	local screenGui = instance:FindFirstAncestorOfClass("ScreenGui")

	if screenGui and screenGui:IsA("ScreenGui") then
		v = screenGui
	else
		local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")
		local mainAppScreen_SurfaceGui

		if luaAppScreenGui then
			mainAppScreen_SurfaceGui = luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
		end

		if mainAppScreen_SurfaceGui and mainAppScreen_SurfaceGui:IsA("SurfaceGui") then
			v = mainAppScreen_SurfaceGui
		elseif not FFlagCleanupTenFootUiPaddingAndAnalytics then
			local tenFootUiSurfaceGuiFolder = CoreGui:FindFirstChild("TenFootUiSurfaceGuiFolder")
			local rootViewSurface_SurfaceGui

			if tenFootUiSurfaceGuiFolder then
				rootViewSurface_SurfaceGui = tenFootUiSurfaceGuiFolder:FindFirstChild("RootViewSurface_SurfaceGui")
			end

			if rootViewSurface_SurfaceGui and rootViewSurface_SurfaceGui:IsA("SurfaceGui") then
				v = rootViewSurface_SurfaceGui
			end
		end
	end

	local screenSizeWidth

	if v and v.AbsoluteSize then
		screenSizeWidth = math.round(v.AbsoluteSize.X)
	end

	local screenSizeHeight

	if v and v.AbsoluteSize then
		screenSizeHeight = math.round(v.AbsoluteSize.Y)
	end

	return { screenSizeWidth = screenSizeWidth, screenSizeHeight = screenSizeHeight }
end

return UnifiedEventLoggingUtils
