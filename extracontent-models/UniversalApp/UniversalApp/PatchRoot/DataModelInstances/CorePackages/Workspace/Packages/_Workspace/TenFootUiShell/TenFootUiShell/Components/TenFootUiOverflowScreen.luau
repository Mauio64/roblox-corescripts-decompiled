local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local React = require(TenFootUiShellParent.React)
local Style = require(TenFootUiShellParent.Style)

require(TenFootUiShellParent.TenFootUiCommon)

local Constants = require(ReactNavigationExtend.Views.Constants)
local useDesignTokens = Style.useDesignTokens
local getVirtualResolutionScale = require(TenFootUiShellParent.Responsive).getVirtualResolutionScale

local function getVariantStyles(t1: {[any]: any}, p1) -- line: 21
	-- upvalues: Constants (copy)
	local TOP_BAR_CANVAS_SIZEY = Constants.TOP_BAR_CANVAS_SIZE.Y
	local PAGE_CONTENT_HEIGHT_RATIO = Constants.PAGE_CONTENT_HEIGHT_RATIO
	local v15 = p1.Size.Size_400 / Constants.CANVAS_SIZE.Y + PAGE_CONTENT_HEIGHT_RATIO
	local v16 = TOP_BAR_CANVAS_SIZEY - p1.Size.Size_600

	return {
		showOverflowFade = t1.screenKind == "Default",
		paddingTop = t1.screenKind ~= "Default" and 0 or v16,
		pageHeightRatio = PAGE_CONTENT_HEIGHT_RATIO,
		overflowStop = v15
	}
end
local function TenFootUiOverflowScreen(t2: {[any]: any}) -- line: 34
	-- upvalues: useDesignTokens (copy), getVariantStyles (copy), React (copy), getVirtualResolutionScale (copy)
	local v18 = useDesignTokens()
	local v19 = getVariantStyles(t2, v18)

	return React.createElement("CanvasGroup", {
		Name = "TenFootUiOverflowScreen",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		GroupTransparency = t2.groupTransparency,
		ResolutionScale = getVirtualResolutionScale()
	}, React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v19.paddingTop)
	}), t2.children, if not v19.showOverflowFade then nil else React.createElement("UIGradient", {
		Rotation = 270,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(v19.pageHeightRatio, 0),
			NumberSequenceKeypoint.new(v19.overflowStop, 1),
			NumberSequenceKeypoint.new(1, 1)
		})
	}))
end

return TenFootUiOverflowScreen
