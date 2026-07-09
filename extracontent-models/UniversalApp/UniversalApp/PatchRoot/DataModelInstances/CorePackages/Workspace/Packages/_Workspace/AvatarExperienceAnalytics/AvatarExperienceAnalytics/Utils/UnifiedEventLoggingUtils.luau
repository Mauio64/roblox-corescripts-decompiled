local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local CoreGui = game:GetService("CoreGui")
local Dash = require(Parent.Dash)
local UnifiedEventLogConstants = require(script.Parent.Parent.UnifiedEventLogConstants)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(Parent.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local t1 = {}

local function getParentScrollingFrames(p1, t2: {[any]: any}?) -- line: 14
	-- upvalues: getParentScrollingFrames (copy)
	if not t2 then
		t2 = {}
	end

	local ScrollingFrame = p1:FindFirstAncestorWhichIsA("ScrollingFrame")

	if not ScrollingFrame then
		return t2
	end

	table.insert(t2, ScrollingFrame)

	return getParentScrollingFrames(ScrollingFrame, t2)
end

function t1.getUnifiedLoggingFieldName(p2) -- line: 28
	-- upvalues: UnifiedEventLogConstants (copy)
	return p2:sub(string.len(UnifiedEventLogConstants.ATTRIBUTE_PREFIX) + 1, (string.len(p2)))
end
function t1.isUnifiedLoggingAttribute(p3) -- line: 33
	-- upvalues: Dash (copy), UnifiedEventLogConstants (copy)
	return Dash.startsWith(p3, UnifiedEventLogConstants.ATTRIBUTE_PREFIX)
end
function t1.formatLookTypeAttribute(p4) -- line: 37
	return string.upper("LOOK_TYPE_" .. p4)
end

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function t1.getFieldsToSendFromInstanceAttributes(p5) -- line: 42
		-- upvalues: t1 (copy)
		local t3 = {}

		if p5 then
			for v16, v17 in p5 do
				if t1.isUnifiedLoggingAttribute(v16) then
					t3[t1.getUnifiedLoggingFieldName(v16)] = v17
				end
			end
		end

		return t3
	end
end

function t1.getElementSizeAndPosition(p6) -- line: 57
	-- upvalues: getParentScrollingFrames (copy)
	local AbsolutePositionX = p6.AbsolutePosition.X
	local AbsolutePositionY = p6.AbsolutePosition.Y
	local v21 = nil or {}
	local ScrollingFrame = p6:FindFirstAncestorWhichIsA("ScrollingFrame")

	if not ScrollingFrame then
	else
		table.insert(v21, ScrollingFrame)
		v21 = getParentScrollingFrames(ScrollingFrame, v21)
	end

	if v21 then
		for _, v24 in v21 do
			AbsolutePositionX += v24.CanvasPosition.X
			AbsolutePositionY += v24.CanvasPosition.Y
		end
	end

	return {
		elementSizeWidth = math.round(p6.AbsoluteSize.X),
		elementSizeHeight = math.round(p6.AbsoluteSize.Y),
		elementCoordinatesX = math.round(p6.AbsolutePosition.X),
		elementCoordinatesY = math.round(p6.AbsolutePosition.Y),
		elementRelativePositionX = math.round(AbsolutePositionX),
		elementRelativePositionY = math.round(AbsolutePositionY)
	}
end
function t1.getScreenSize(p7) -- line: 78
	-- upvalues: CoreGui (copy)
	local v26 = nil
	local ScreenGui = p7:FindFirstAncestorOfClass("ScreenGui")

	if ScreenGui and ScreenGui:IsA("ScreenGui") then
		v26 = ScreenGui
	else
		local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")
		local v29 = if not LuaAppScreenGui then nil else LuaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")

		if v29 and v29:IsA("SurfaceGui") then
			v26 = v29
		else
			local TenFootUiSurfaceGuiFolder = CoreGui:FindFirstChild("TenFootUiSurfaceGuiFolder")
			local v31 = if not TenFootUiSurfaceGuiFolder then nil else TenFootUiSurfaceGuiFolder:FindFirstChild("RootViewSurface_SurfaceGui")

			if v31 and v31:IsA("SurfaceGui") then
				v26 = v31
			end
		end
	end

	return {
		screenSizeWidth = if not v26 or not v26.AbsoluteSize then nil else math.round(v26.AbsoluteSize.X),
		screenSizeHeight = if not v26 or not v26.AbsoluteSize then nil else math.round(v26.AbsoluteSize.Y)
	}
end

return t1
