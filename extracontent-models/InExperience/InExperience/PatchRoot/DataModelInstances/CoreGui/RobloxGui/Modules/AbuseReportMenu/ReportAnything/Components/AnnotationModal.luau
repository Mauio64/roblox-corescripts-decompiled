local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Chrome = RobloxGui.Modules.Chrome
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local v9 = if not Enabled() then nil else require(Chrome.Service)

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local ScreenshotFlowStepHandlerContainer = require(AbuseReportMenu.ReportAnything.Components.ScreenshotFlowStepHandlerContainer)

require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)

local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local t1 = {
	annotationPageHandle = nil,
	annotationPageFrame = nil,
	annotationPageScreenGui = nil
}

local function unmountAnnotationPage() -- line: 28
	-- upvalues: FFlagEnableConsoleExpControls (copy), Enabled (copy), v9 (copy), t1 (copy), Roact (copy)
	if FFlagEnableConsoleExpControls and if not FFlagEnableConsoleExpControls then Enabled else Enabled() then
		v9:setHideShortcutBar("AnnotationModal", false)
	end

	if t1.annotationPageHandle ~= nil then
		Roact.unmount(t1.annotationPageHandle)
		t1.annotationPageHandle = nil
	end

	if t1.annotationPageScreenGui ~= nil then
		t1.annotationPageFrame.Parent = nil
		t1.annotationPageFrame = nil
		t1.annotationPageScreenGui = nil
	end
end

return {
	mountAnnotationPage = function(s1: string, p1: ((...any) -> ...any), p2, p3, p4: ((...any) -> ...any)) -- line: 43
		-- upvalues: FFlagEnableConsoleExpControls (copy), Enabled (copy), v9 (copy), GuiService (copy), t1 (copy), CoreGui (copy), Constants (copy), Roact (copy), ScreenshotFlowStepHandlerContainer (copy), unmountAnnotationPage (copy)
		if FFlagEnableConsoleExpControls and if not FFlagEnableConsoleExpControls then Enabled else Enabled() then
			v9:setHideShortcutBar("AnnotationModal", true)
		end

		local v20, _ = GuiService:GetGuiInset()

		if not t1.annotationPageScreenGui then
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = "AnnotationPageContents"
			ScreenGui.DisplayOrder = 7
			ScreenGui.Enabled = true
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.Parent = CoreGui:FindFirstChild(Constants.AbuseReportMenuPlaceholderFrame, true)
			t1.annotationPageScreenGui = ScreenGui

			local Frame = Instance.new("Frame")

			Frame.BackgroundTransparency = 1
			Frame.Position = UDim2.new(0, 0, 0, -v20.Y)
			Frame.Size = UDim2.new(1, 0, 1, v20.Y)
			Frame.Parent = t1.annotationPageScreenGui
			t1.annotationPageFrame = Frame
		end

		local v24 = Roact.createElement(ScreenshotFlowStepHandlerContainer, {
			initialPageNumber = 1,
			screenshot = p3.screenshotContentId,
			entryPoint = s1,
			backAction = function() -- line: 76
				-- upvalues: unmountAnnotationPage (copy)
				unmountAnnotationPage()
			end,
			dismissAction = function() -- line: 79
				-- upvalues: unmountAnnotationPage (copy)
				unmountAnnotationPage()
			end,
			finishAnnotationAction = function(p5) -- line: 82
				-- upvalues: unmountAnnotationPage (copy), p4 (copy), Constants (copy)
				unmountAnnotationPage()
				p4({
					type = Constants.ReportAnythingActions.SetAnnotationPoints,
					annotationPoints = p5
				})
				p4({
					type = Constants.ReportAnythingActions.CompleteAttachment
				})
			end,
			restartAction = function() -- line: 92
				-- upvalues: unmountAnnotationPage (copy), p4 (copy), Constants (copy), p1 (copy)
				unmountAnnotationPage()
				p4({
					type = Constants.ReportAnythingActions.ClearAll
				})
				p1()
			end,
			skipAnnotationAction = function() -- line: 102
				-- upvalues: unmountAnnotationPage (copy), p4 (copy), Constants (copy)
				unmountAnnotationPage()
				p4({
					type = Constants.ReportAnythingActions.CompleteAttachment
				})
			end,
			setAnnotationCircleRadius = function(p6) -- line: 108
				-- upvalues: p4 (copy), Constants (copy)
				p4({
					type = Constants.ReportAnythingActions.SetAnnotationCircleRadius,
					radius = p6
				})
			end,
			setAnnotationAreaDimensions = function(p7, p8) -- line: 114
				-- upvalues: p4 (copy), Constants (copy)
				p4({
					type = Constants.ReportAnythingActions.SetAnnotationAreaDimensions,
					width = p7,
					height = p8
				})
			end,
			initialAnnotationPoints = {},
			viewportInfo = p3.identificationResults.avatarIDStats.viewportInfo,
			reportAnythingAnalytics = p2
		})

		p4({
			type = Constants.ReportAnythingActions.SetAnnotationOptionSeen
		})
		t1.annotationPageHandle = Roact.mount(v24, t1.annotationPageFrame, "AnnotationFlow")
	end,
	unmountAnnotationPage = unmountAnnotationPage
}
