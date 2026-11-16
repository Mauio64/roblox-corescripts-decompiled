local CoreGui = game:GetService("CoreGui")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Dash")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagCleanupTenFootUiPaddingAndAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagCleanupTenFootUiPaddingAndAnalytics

local v5 = {}
local function getParentScrollingFrames(scrollingFrame, scrollingFrames)
	local scrollingFrames2 = scrollingFrames or {}

	local scrollingFrame2 = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")

	if not scrollingFrame2 then
		return scrollingFrames2
	end

	table.insert(scrollingFrames2, scrollingFrame2)
	return getParentScrollingFrames(scrollingFrame2, scrollingFrames2)
end

function v5.getUnifiedLoggingFieldName(value)
	local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
	return value.sub(value, string.len(ATTRIBUTE_PREFIX) + 1, (string.len(value)))
end

function v5.isUnifiedLoggingAttribute(p2)
	return Dash.startsWith(p2, UnifiedEventLogConstants.ATTRIBUTE_PREFIX)
end

function v5.formatLookTypeAttribute(p2)
	return string.upper("LOOK_TYPE_" .. p2)
end

if fFlagAXMISEnableMultiShoppingUnifiedEvents then
	function v5.getFieldsToSendFromInstanceAttributes(items)
		local fieldsToSend = {}

		if items then
			for k, item in items do
				if v5.isUnifiedLoggingAttribute(k) then
					fieldsToSend[v5.getUnifiedLoggingFieldName(k)] = item
				end
			end
		end

		return fieldsToSend
	end
end

function v5.getElementSizeAndPosition(instance)
	local x = instance.AbsolutePosition.X
	local y = instance.AbsolutePosition.Y
	local scrollingFrames = nil or {}

	local scrollingFrame = instance:FindFirstAncestorWhichIsA("ScrollingFrame")

	if scrollingFrame then
		table.insert(scrollingFrames, scrollingFrame)
		scrollingFrames = getParentScrollingFrames(scrollingFrame, scrollingFrames)
	end

	if scrollingFrames then
		for k, v6 in scrollingFrames do
			x += v6.CanvasPosition.X
			y += v6.CanvasPosition.Y
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

function v5.getScreenSize(instance)
	local v6 = nil
	local screenGui = instance:FindFirstAncestorOfClass("ScreenGui")

	if screenGui and screenGui:IsA("ScreenGui") then
		v6 = screenGui
	else
		local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")
		local mainAppScreen_SurfaceGui

		if luaAppScreenGui then
			mainAppScreen_SurfaceGui = luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
		end

		if mainAppScreen_SurfaceGui and mainAppScreen_SurfaceGui:IsA("SurfaceGui") then
			v6 = mainAppScreen_SurfaceGui
		elseif not fFlagCleanupTenFootUiPaddingAndAnalytics then
			local tenFootUiSurfaceGuiFolder = CoreGui:FindFirstChild("TenFootUiSurfaceGuiFolder")
			local rootViewSurface_SurfaceGui

			if tenFootUiSurfaceGuiFolder then
				rootViewSurface_SurfaceGui = tenFootUiSurfaceGuiFolder:FindFirstChild("RootViewSurface_SurfaceGui")
			end

			if rootViewSurface_SurfaceGui and rootViewSurface_SurfaceGui:IsA("SurfaceGui") then
				v6 = rootViewSurface_SurfaceGui
			end
		end
	end

	local v7 = if v6 and v6.AbsoluteSize then math.round(v6.AbsoluteSize.X) else nil
	local v8 = if v6 and v6.AbsoluteSize then math.round(v6.AbsoluteSize.Y) else nil
	return { screenSizeWidth = v7, screenSizeHeight = v8 }
end

return v5
