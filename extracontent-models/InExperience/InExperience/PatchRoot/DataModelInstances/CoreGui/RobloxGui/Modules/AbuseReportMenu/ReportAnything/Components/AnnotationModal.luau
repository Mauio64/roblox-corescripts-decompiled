local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome2.Enabled
local Service

if Enabled() then
	Service = require(Chrome.Service)
else
	Service = nil
end

require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)

local ScreenshotFlowStepHandlerContainer = require(AbuseReportMenu.ReportAnything.Components.ScreenshotFlowStepHandlerContainer)
require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local v = { annotationPageHandle = nil, annotationPageFrame = nil, annotationPageScreenGui = nil }

local function unmountAnnotationPage()
	if FFlagEnableConsoleExpControls then
		local v2

		if FFlagEnableConsoleExpControls then
			v2 = Enabled()
		else
			v2 = Enabled
		end

		if v2 then
			Service:setHideShortcutBar("AnnotationModal", false)
		end
	end

	if v.annotationPageHandle ~= nil then
		Roact.unmount(v.annotationPageHandle)
		v.annotationPageHandle = nil
	end

	if v.annotationPageScreenGui ~= nil then
		v.annotationPageFrame.Parent = nil
		v.annotationPageFrame = nil
		v.annotationPageScreenGui = nil
	end
end

return {
	mountAnnotationPage = function(entryPoint: string, callback, reportAnythingAnalytics, p, callback2)
		if FFlagEnableConsoleExpControls then
			local v2

			if FFlagEnableConsoleExpControls then
				v2 = Enabled()
			else
				v2 = Enabled
			end

			if v2 then
				Service:setHideShortcutBar("AnnotationModal", true)
			end
		end

		local guiInset, _ = GuiService:GetGuiInset()

		if not v.annotationPageScreenGui then
			local annotationPageContents = Instance.new("ScreenGui")
			annotationPageContents.Name = "AnnotationPageContents"
			annotationPageContents.DisplayOrder = 7
			annotationPageContents.Enabled = true
			annotationPageContents.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			annotationPageContents.Parent = CoreGui:FindFirstChild(Constants.AbuseReportMenuPlaceholderFrame, true)

			v.annotationPageScreenGui = annotationPageContents

			local frame = Instance.new("Frame")
			frame.BackgroundTransparency = 1
			frame.Position = UDim2.new(0, 0, 0, -guiInset.Y)
			frame.Size = UDim2.new(1, 0, 1, guiInset.Y)
			frame.Parent = v.annotationPageScreenGui

			v.annotationPageFrame = frame
		end

		local element = Roact.createElement(ScreenshotFlowStepHandlerContainer, {
			screenshot = p.screenshotContentId,
			entryPoint = entryPoint,
			backAction = function()
				unmountAnnotationPage()
			end,
			dismissAction = function()
				unmountAnnotationPage()
			end,
			finishAnnotationAction = function(annotationPoints)
				unmountAnnotationPage()
				callback2({
					type = Constants.ReportAnythingActions.SetAnnotationPoints,
					annotationPoints = annotationPoints
				})

				callback2({ type = Constants.ReportAnythingActions.CompleteAttachment })
			end,
			restartAction = function()
				unmountAnnotationPage()

				callback2({ type = Constants.ReportAnythingActions.ClearAll })

				callback()
			end,
			skipAnnotationAction = function()
				unmountAnnotationPage()
				callback2({ type = Constants.ReportAnythingActions.CompleteAttachment })
			end,
			setAnnotationCircleRadius = function(radius)
				callback2({
					type = Constants.ReportAnythingActions.SetAnnotationCircleRadius,
					radius = radius
				})
			end,
			setAnnotationAreaDimensions = function(width, height)
				callback2({
					type = Constants.ReportAnythingActions.SetAnnotationAreaDimensions,
					width = width,
					height = height
				})
			end,
			initialAnnotationPoints = {},
			initialPageNumber = 1,
			viewportInfo = p.identificationResults.avatarIDStats.viewportInfo,
			reportAnythingAnalytics = reportAnythingAnalytics
		})

		callback2({ type = Constants.ReportAnythingActions.SetAnnotationOptionSeen })

		v.annotationPageHandle = Roact.mount(element, v.annotationPageFrame, "AnnotationFlow")
	end,
	unmountAnnotationPage = unmountAnnotationPage
}
