local module = require("@luauforge/bundled/hKp")
local module2 = require("@luauforge/bundled/hKO")
local module3 = require("@luauforge/bundled/hKr")
local normalizeFontFace = require("@luauforge/bundled/hKK").Utility.normalizeFontFace
local module4 = require("@luauforge/bundled/hKL")
local module5 = require("@luauforge/bundled/hKF")
local module6 = require("@luauforge/bundled/hKT")
local module7 = require("@luauforge/bundled/hKH")
local useLocalization = require("@luauforge/bundled/hKP").Hooks.useLocalization

local module8 = require("@luauforge/bundled/hKQ")
require("@luauforge/bundled/hKz")
local buttonType = module2.App.Button.Enum.ButtonType

local getFFlagDSAIllegalContentReporting = module5.GetFFlagDSAIllegalContentReporting
local isSelectedDataDSAIllegalContent = module6.isSelectedDataDSAIllegalContent
local isInDSAFeaturesOverrideList = module6.isInDSAFeaturesOverrideList

local udim = UDim2.new(1, 0, 0, 100)
local udim2 = UDim.new(0, 5)

local function Submission(props)
	local reportSubmission = module7().ReportSubmission
	local params = props.params

	module.useEffect(module.useCallback(props.onMounted), {})

	local v5 = useLocalization({ cancelText = "Feature.Chat.Action.Cancel" })

	local entrySize = reportSubmission.entrySize or udim
	local entryInnerVerticalPadding = reportSubmission.entryInnerVerticalPadding or udim2

	local dividerVerticalPadding = reportSubmission.dividerVerticalPadding or 5
	local dividerHeight = reportSubmission.dividerHeight or 2
	local transparency = reportSubmission.dividerColor and reportSubmission.dividerColor.Transparency or 0.8

	local children = {}

	for k, v6 in props.report do
		local createElement = module.createElement
		local v8 = {
			Size = entrySize,
			BackgroundTransparency = 1,
			LayoutOrder = v6.index,
			AutomaticSize = Enum.AutomaticSize.None
		}
		local children2 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = entryInnerVerticalPadding
			}),
			Title = 0,
			Subtitle = 0,
			Decoration = 0
		}

		local createElement2 = module.createElement
		local v10 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			Text = v6.heading,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextSize = 0,
			LineHeight = 0,
			LayoutOrder = 1
		}

		local v11 = if not module4 then reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.Font else nil
		v10.Font = v11

		local v12 = if module4 and reportSubmission.entryFontStyle then normalizeFontFace(reportSubmission.entryFontStyle.Font) else nil
		v10.FontFace = v12

		v10.TextXAlignment = Enum.TextXAlignment.Left
		v10.TextColor3 = reportSubmission.entryTitleColor and reportSubmission.entryTitleColor.Color3
		v10.TextSize = reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.FontSize
		v10.LineHeight = reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.LineHeight
		children2.Title = createElement2("TextLabel", v10)

		local createElement3 = module.createElement
		local v14 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			Text = v6.humanReadableText,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextSize = 0,
			LineHeight = 0,
			LayoutOrder = 2
		}

		local v15 = if not module4 then reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.Font else nil
		v14.Font = v15

		local v16 = if module4 and reportSubmission.entryFontStyle then normalizeFontFace(reportSubmission.entryFontStyle.Font) else nil
		v14.FontFace = v16

		v14.TextXAlignment = Enum.TextXAlignment.Left
		v14.TextColor3 = reportSubmission.entryTextColor and reportSubmission.entryTextColor.Color3
		v14.TextSize = reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.FontSize
		v14.LineHeight = reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.LineHeight
		children2.Subtitle = createElement3("TextLabel", v14)

		children2.Decoration = module.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, dividerVerticalPadding),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				Divider = module.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, dividerHeight),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundColor3 = reportSubmission.dividerColor and reportSubmission.dividerColor.Color3,
					BackgroundTransparency = transparency
				})
			}
		)
		table.insert(children, (createElement("Frame", v8, children2)))
	end

	local v6 = {
		{
			text = v5.cancelText,
			onActivated = function()
				props.onCancel(props)
			end
		}
	}

	local v7 = getFFlagDSAIllegalContentReporting() or isInDSAFeaturesOverrideList()

	if v7 then
		v7 = not (params.text == "") and isSelectedDataDSAIllegalContent(props.report)
	end

	if v7 then
		local createElement = module.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 10,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v10 = {
			UIListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Text = 0
		}

		local createElement2 = module.createElement
		local v12 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0, 800, 0, 100),
			BackgroundTransparency = 1,
			Text = params.text,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextSize = 0,
			LineHeight = 0,
			LayoutOrder = 1
		}

		local v13 = if not module4 then reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.Font else nil
		v12.Font = v13

		local v14 = if module4 and reportSubmission.entryFontStyle then normalizeFontFace(reportSubmission.entryFontStyle.Font) else nil
		v12.FontFace = v14

		v12.TextXAlignment = Enum.TextXAlignment.Center
		v12.TextColor3 = reportSubmission.entryTitleColor and reportSubmission.entryTitleColor.Color3
		v12.TextSize = reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.FontSize
		v12.LineHeight = reportSubmission.entryFontStyle and reportSubmission.entryFontStyle.LineHeight
		v10.Text = createElement2("TextLabel", v12)
		table.insert(children, (createElement("Frame", v9, v10)))
	else
		table.insert(v6, {
			text = params.buttonText,
			buttonType = buttonType.PrimarySystem,
			onActivated = function()
				props.onSubmit(props)
			end
		})
	end

	return module.createElement(module8, { title = params.heading, buttons = v6 }, module3.Dictionary.join({
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}, children or {}))
end

return Submission
