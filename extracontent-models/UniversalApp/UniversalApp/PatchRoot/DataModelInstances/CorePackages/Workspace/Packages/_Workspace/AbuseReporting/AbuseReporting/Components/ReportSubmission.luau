local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)
local UIBlox = require(AbuseReportingParent.UIBlox)
local Cryo = require(AbuseReportingParent.Cryo)
local SharedFlags = require(AbuseReportingParent.SharedFlags)
local DsaIllegalContentReporting = require(AbuseReportingParent.DsaIllegalContentReporting)
local useAbuseReportingDesignTokens = require(AbuseReporting.Hooks.useAbuseReportingDesignTokens)
local useLocalization = require(AbuseReportingParent.Localization).Hooks.useLocalization
local ReportStep = require(script.Parent.ReportStep)

require(script.Parent.Parent.Common.Types)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GetFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local isSelectedDataDSAIllegalContent = DsaIllegalContentReporting.isSelectedDataDSAIllegalContent
local isInDSAFeaturesOverrideList = DsaIllegalContentReporting.isInDSAFeaturesOverrideList
local uDim2 = UDim2.new(1, 0, 0, 100)
local uDim = UDim.new(0, 5)

local function Submission(t1: {[any]: any}) -- line: 50
	-- upvalues: useAbuseReportingDesignTokens (copy), React (copy), useLocalization (copy), uDim2 (copy), uDim (copy), GetFFlagDSAIllegalContentReporting (copy), isInDSAFeaturesOverrideList (copy), isSelectedDataDSAIllegalContent (copy), ButtonType (copy), ReportStep (copy), Cryo (copy)
	local ReportSubmission = useAbuseReportingDesignTokens().ReportSubmission
	local params = t1.params

	React.useEffect(React.useCallback(t1.onMounted), {})

	local v21 = useLocalization({
		cancelText = "Feature.Chat.Action.Cancel"
	})
	local v22 = ReportSubmission.entrySize or uDim2
	local v23 = ReportSubmission.entryInnerVerticalPadding or uDim
	local v24 = ReportSubmission.dividerVerticalPadding or 5
	local v25 = ReportSubmission.dividerHeight or 2
	local v26 = ReportSubmission.dividerColor and ReportSubmission.dividerColor.Transparency or 0.8
	local t2 = {}

	for _, v29 in t1.report do
		table.insert(t2, (React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = v22,
			LayoutOrder = v29.index,
			AutomaticSize = Enum.AutomaticSize.None
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = v23
			}),
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				Text = v29.heading,
				Font = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = ReportSubmission.entryTitleColor and ReportSubmission.entryTitleColor.Color3,
				TextSize = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.FontSize,
				LineHeight = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.LineHeight
			}),
			Subtitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				Text = v29.humanReadableText,
				Font = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = ReportSubmission.entryTextColor and ReportSubmission.entryTextColor.Color3,
				TextSize = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.FontSize,
				LineHeight = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.LineHeight
			}),
			Decoration = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v24)
			}, {
				Divider = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, v25),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundColor3 = ReportSubmission.dividerColor and ReportSubmission.dividerColor.Color3,
					BackgroundTransparency = v26
				})
			})
		})))
	end

	local t3 = {{
		text = v21.cancelText,
		onActivated = function() -- line: 130
			-- upvalues: t1 (copy)
			t1.onCancel(t1)
		end
	}}

	if (GetFFlagDSAIllegalContentReporting() or isInDSAFeaturesOverrideList()) and (params.text ~= "" and isSelectedDataDSAIllegalContent(t1.report)) then
		table.insert(t2, (React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 10,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Text = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, 800, 0, 100),
				Text = params.text,
				Font = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.Font,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextColor3 = ReportSubmission.entryTitleColor and ReportSubmission.entryTitleColor.Color3,
				TextSize = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.FontSize,
				LineHeight = ReportSubmission.entryFontStyle and ReportSubmission.entryFontStyle.LineHeight
			})
		})))
	else
		table.insert(t3, {
			text = params.buttonText,
			buttonType = ButtonType.PrimarySystem,
			onActivated = function() -- line: 173
				-- upvalues: t1 (copy)
				t1.onSubmit(t1)
			end
		})
	end

	return React.createElement(ReportStep, {
		title = params.heading,
		buttons = t3
	}, Cryo.Dictionary.join({
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}, t2 or {}))
end

return Submission
