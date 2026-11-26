local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local UIBlox = require(CorePackages.Packages.UIBlox)
local fullPageModal = UIBlox.App.Dialog.Modal.FullPageModal

local buttonType = UIBlox.App.Button.Enum.ButtonType
local module2 = require("@luauforge/deferred/gMi")
local module3 = require("@luauforge/deferred/gMl")
require("@luauforge/deferred/gMj")
local module4 = require("@luauforge/deferred/gMm")
local module5 = require("@luauforge/deferred/gMn")
local module6 = require("@luauforge/deferred/gMp")
local module7 = require("@luauforge/deferred/gMk")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize

local isSelectedDataDSAIllegalContent = require("@luauforge/deferred/gMg").isSelectedDataDSAIllegalContent

local module8 = require("@luauforge/deferred/gMq")

local vrConstants = require("@luauforge/bundled/fFV").VRConstants

local isShowEUDSAIllegalContentReportingLink = require("@luauforge/deferred/gMg").isShowEUDSAIllegalContentReportingLink

local getFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail
local getFFlagLuafiedReportErrorStates = SharedFlags.GetFFlagLuafiedReportErrorStates
local getFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local getFFlagDSAVRSkipFrontendGeoCheck = SharedFlags.GetFFlagDSAVRSkipFrontendGeoCheck

local function getButtonsFromProps(data, backButtonText, closeButtonText, p2, p3, beduiError)
	local buttons = {}

	if p2 then
		table.insert(buttons, {
			buttonType = buttonType.Secondary,
			props = {
				onActivated = function()
					data.onBack()
				end,
				text = backButtonText
			}
		})
	end

	if beduiError then
		table.insert(buttons, {
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = function()
					data.onClose()
				end,
				text = closeButtonText
			}
		})
	end

	if p3 then
		table.insert(buttons, {
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = function()
					data.onSubmitReport()
				end,
				text = data.BEDUIComponents and data.BEDUIComponents.submission.buttonText or "",
				isDisabled = data.loadingState.submitLoading
			}
		})
	end

	return buttons
end

return function(data)
	local v5 = useDesignTokens()
	local v6 = useScreenSize()
	local v7

	if data.BEDUIComponents == nil or data.BEDUIComponents.submission.text == nil then
		v7 = false
	else
		v7 = isSelectedDataDSAIllegalContent(data.selectionData)
	end

	local v8

	if getFFlagDSAVRSkipFrontendGeoCheck() then
		v8 = v7 and getFFlagDSAIllegalContentReporting()
	else
		v8 = v7 and isShowEUDSAIllegalContentReportingLink()
	end

	local v9 = useSelector(module8({ reportData = data.reportData }))
	local v10

	if #data.prevListNodes > 0 then
		local beduiError = getFFlagLuafiedReportErrorStates() and data.loadingState.BEDUIError
		v10 = not beduiError
	else
		v10 = false
	end

	local v11 = data.currentList == nil and #data.selectionData > 0 and not v8
	local beduiError = getFFlagLuafiedReportErrorStates() and data.loadingState.BEDUIError
	local color3

	if data.loadingState.submitLoading or data.loadingState.BEDUILoading then
		color3 = v5.Color.Content.Default.Color3
	else
		color3 = v5.Color.ActionAlert.Foreground.Color3
	end

	return withLocalization({
		backButtonText = "CommonUI.Controls.Action.Back",
		closeButtonText = "Feature.Friends.Action.Close"
	})(function(p2)
		local createElement = React.createElement
		local v13 = {
			distanceFromTop = not UserInputService.StatusBarSize and 0 or UserInputService.StatusBarSize.Y,
			title = data.BEDUIComponents and data.BEDUIComponents.title.text or "",
			screenSize = 0,
			buttonStackProps = 0,
			onCloseClicked = 0
		}
		local v14 = if data.reportSurface == module7.BEDUI_SURFACES.VR or not v6 then vrConstants.MainScreenResolution else v6
		v13.screenSize = v14

		v13.buttonStackProps = (v10 or v11 or beduiError)
			and {
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = getButtonsFromProps(
					data,
					p2.backButtonText,
					p2.closeButtonText,
					v10,
					v11,
					beduiError
				)
			}
			or nil

		function v13.onCloseClicked()
			data.onClose()

			data.onLogAbandon()
		end

		local createElement2 = React.createElement
		local v17 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

		local v18 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ReportTarget = 0,
			ReportContent = 0
		}
		local v19

		if getFFlagLuafiedReportThumbnail() then
			if not (getFFlagLuafiedReportErrorStates() and data.loadingState.BEDUIError) then
				v19 = React.createElement(module5, {
					primaryText = v9.primaryText,
					secondaryText = v9.secondaryText,
					thumbnailUrl = v9.thumbnailUrl
				})
			end
		end

		v18.ReportTarget = v19

		local createElement3 = React.createElement
		local v21 = {
			Size = UDim2.new(
				1,
				0,
				1,
				getFFlagLuafiedReportErrorStates() and data.loadingState.BEDUIError and 0 or -v5.Size.Size_2800
			),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v24

		if data.currentList then
			v24 = React.createElement(module2, {
				currentList = data.currentList,
				onSelect = data.onSelect
			})
		elseif #data.selectionData > 0 then
			v24 = React.createElement(module3, {
				heading = data.BEDUIComponents and data.BEDUIComponents.submission.heading or "",
				selectionData = data.selectionData,
				dsaText = data.BEDUIComponents and data.BEDUIComponents.submission.text or "",
				onSummaryPageMounted = data.onSummaryPageMounted
			})
		elseif getFFlagLuafiedReportErrorStates() and data.loadingState.BEDUILoading then
			v24 = React.createElement(module4, {})
		end

		local v25 = if getFFlagLuafiedReportErrorStates() then React.createElement(module6, {
			statusPrimaryText = data.loadingState.statusPrimaryText,
			statusSecondaryText = data.loadingState.statusSecondaryText,
			BEDUIError = data.loadingState.BEDUIError,
			submitError = data.loadingState.submitError,
			color = color3
		}) else nil
		v18.ReportContent = createElement3("Frame", v21, {
			ReportCategoryTable = v24,
			ReportDataFetchStatusMessage = v25
		})
		return createElement(fullPageModal, v13, {
			ViewFrame = createElement2("Frame", v17, v18)
		})
	end)
end
