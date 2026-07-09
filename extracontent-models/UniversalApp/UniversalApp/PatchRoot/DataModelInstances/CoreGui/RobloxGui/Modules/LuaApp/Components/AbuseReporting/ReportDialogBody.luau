local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ReportListTable = require(Modules.LuaApp.Components.AbuseReporting.ReportListTable)
local ReportSummaryPage = require(Modules.LuaApp.Components.AbuseReporting.ReportSummaryPage)

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)

local ReportDialogBodyLoading = require(Modules.LuaApp.Components.AbuseReporting.ReportDialogBodyLoading)
local ReportTargetComponent = require(Modules.LuaApp.Components.AbuseReporting.ReportTargetComponent)
local ReportDataFetchStatusMessage = require(Modules.LuaApp.Components.AbuseReporting.ReportDataFetchStatusMessage)
local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local isSelectedDataDSAIllegalContent = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting).isSelectedDataDSAIllegalContent
local getThumbnailData = require(script.Parent.getThumbnailData)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local isShowEUDSAIllegalContentReportingLink = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting).isShowEUDSAIllegalContentReportingLink
local GetFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail
local GetFFlagLuafiedReportErrorStates = SharedFlags.GetFFlagLuafiedReportErrorStates
local GetFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local GetFFlagDSAVRSkipFrontendGeoCheck = SharedFlags.GetFFlagDSAVRSkipFrontendGeoCheck
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout

local function getButtonsFromProps(t1: {[any]: any}, s1: string, s2: string, b1: boolean, b2: boolean, b3: boolean) -- line: 70
	-- upvalues: ButtonType (copy)
	local t2 = {}

	if b1 then
		table.insert(t2, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 83
					-- upvalues: t1 (copy)
					t1.onBack()
				end,
				text = s1
			}
		})
	end

	if b3 then
		table.insert(t2, {
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = function() -- line: 94
					-- upvalues: t1 (copy)
					t1.onClose()
				end,
				text = s2
			}
		})
	end

	if b2 then
		table.insert(t2, {
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = function() -- line: 105
					-- upvalues: t1 (copy)
					t1.onSubmitReport()
				end,
				text = t1.BEDUIComponents and t1.BEDUIComponents.submission.buttonText or "",
				isDisabled = t1.loadingState.submitLoading
			}
		})
	end

	return t2
end

return function(t3: {[any]: any}) -- line: 124
	-- upvalues: useDesignTokens (copy), useScreenSize (copy), isSelectedDataDSAIllegalContent (copy), GetFFlagDSAVRSkipFrontendGeoCheck (copy), GetFFlagDSAIllegalContentReporting (copy), isShowEUDSAIllegalContentReportingLink (copy), useSelector (copy), getThumbnailData (copy), GetFFlagLuafiedReportErrorStates (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), IxpUtils (copy), VRPanelWidthIXP (copy), withLocalization (copy), React (copy), FullPageModal (copy), UserInputService (copy), Constants (copy), VRConstants (copy), getButtonsFromProps (copy), GetFFlagLuafiedReportThumbnail (copy), ReportTargetComponent (copy), ReportListTable (copy), ReportSummaryPage (copy), ReportDialogBodyLoading (copy), ReportDataFetchStatusMessage (copy)
	local v45 = useDesignTokens()
	local v46 = useScreenSize()
	local v47 = t3.BEDUIComponents ~= nil and (t3.BEDUIComponents.submission.text ~= nil and isSelectedDataDSAIllegalContent(t3.selectionData))
	local v48 = if not GetFFlagDSAVRSkipFrontendGeoCheck() then v47 and isShowEUDSAIllegalContentReportingLink() else v47 and GetFFlagDSAIllegalContentReporting()
	local v49 = useSelector(getThumbnailData({
		reportData = t3.reportData
	}))
	local v50 = #t3.prevListNodes > 0 and not (GetFFlagLuafiedReportErrorStates() and t3.loadingState.BEDUIError)
	local v51 = t3.currentList == nil and (#t3.selectionData > 0 and not v48)
	local v52 = GetFFlagLuafiedReportErrorStates() and t3.loadingState.BEDUIError
	local v53 = if not t3.loadingState.submitLoading and not t3.loadingState.BEDUILoading then v45.Color.ActionAlert.Foreground.Color3 else v45.Color.Content.Default.Color3
	local v54 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelWidthMultiplier)

	return withLocalization({
		backButtonText = "CommonUI.Controls.Action.Back",
		closeButtonText = "Feature.Friends.Action.Close"
	})(function(p1) -- line: 156
		-- upvalues: React (copy), FullPageModal (copy), UserInputService (copy), t3 (copy), Constants (copy), v46 (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), v54 (copy), VRConstants (copy), v50 (copy), v51 (copy), v52 (copy), getButtonsFromProps (copy), GetFFlagLuafiedReportThumbnail (copy), GetFFlagLuafiedReportErrorStates (copy), ReportTargetComponent (copy), v49 (copy), v45 (copy), ReportListTable (copy), ReportSummaryPage (copy), ReportDialogBodyLoading (copy), ReportDataFetchStatusMessage (copy), v53 (copy)
		local createElement = React.createElement
		local v57 = FullPageModal
		local t4 = {
			distanceFromTop = not UserInputService.StatusBarSize and 0 or UserInputService.StatusBarSize.Y,
			title = t3.BEDUIComponents and t3.BEDUIComponents.title.text or "",
			screenSize = if t3.reportSurface == Constants.BEDUI_SURFACES.VR or not v46 then if FFlagLuaAppForceVrAppPanelWidthRollout or not v54 then VRConstants.MainScreenResolution else Vector2.new(VRConstants.MainScreenResolution.X * v54, VRConstants.MainScreenResolution.Y) else v46,
			buttonStackProps = if not v50 and (not v51 and not v52) then nil else {
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = getButtonsFromProps(t3, p1.backButtonText, p1.closeButtonText, v50, v51, v52)
			},
			onCloseClicked = function() -- line: 181
				-- upvalues: t3 (copy)
				t3.onClose()
				t3.onLogAbandon()
			end
		}
		local t5 = {}
		local createElement2 = React.createElement
		local t6 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}
		local t7 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}
		local g63 = nil
		local v64 = nil
		local v65 = nil

		repeat
			if g63 or GetFFlagLuafiedReportThumbnail() then
				if not g63 then
					v64 = t3
				end

				if g63 or (not GetFFlagLuafiedReportErrorStates() or not v64.loadingState.BEDUIError) then
					if not g63 then
						v65 = React.createElement(ReportTargetComponent, {
							primaryText = v49.primaryText,
							secondaryText = v49.secondaryText,
							thumbnailUrl = v49.thumbnailUrl
						})
					end

					g63 = false
					t7.ReportTarget = v65

					local createElement3 = React.createElement
					local t8 = {
						BackgroundTransparency = 1,
						LayoutOrder = 2
					}
					local new = UDim2.new
					local v69 = t3

					t8.Size = new(1, 0, 1, GetFFlagLuafiedReportErrorStates() and v69.loadingState.BEDUIError and 0 or -v45.Size.Size_2800)

					local t9 = {}
					local v71

					if t3.currentList then
						v71 = React.createElement(ReportListTable, {
							currentList = t3.currentList,
							onSelect = t3.onSelect
						})
					elseif #t3.selectionData > 0 then
						v71 = React.createElement(ReportSummaryPage, {
							heading = t3.BEDUIComponents and t3.BEDUIComponents.submission.heading or "",
							selectionData = t3.selectionData,
							dsaText = t3.BEDUIComponents and t3.BEDUIComponents.submission.text or "",
							onSummaryPageMounted = t3.onSummaryPageMounted
						})
					else
						local v72 = t3

						v71 = if not (GetFFlagLuafiedReportErrorStates() and v72.loadingState.BEDUILoading) then nil else React.createElement(ReportDialogBodyLoading, {})
					end

					t9.ReportCategoryTable = v71
					t9.ReportDataFetchStatusMessage = if not GetFFlagLuafiedReportErrorStates() then nil else React.createElement(ReportDataFetchStatusMessage, {
						statusPrimaryText = t3.loadingState.statusPrimaryText,
						statusSecondaryText = t3.loadingState.statusSecondaryText,
						BEDUIError = t3.loadingState.BEDUIError,
						submitError = t3.loadingState.submitError,
						color = v53
					})
					t7.ReportContent = createElement3("Frame", t8, t9)
					t5.ViewFrame = createElement2("Frame", t6, t7)

					return createElement(v57, t4, t5)
				end
			end

			v65 = nil
			g63 = true
		until not g63
	end)
end
