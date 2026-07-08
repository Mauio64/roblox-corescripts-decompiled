local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useStyle = UIBlox.Core.Style.useStyle
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Cryo = require(CorePackages.Packages.Cryo)
local HighlightModeVariants = require(CorePackages.Workspace.Packages.InGameAssetReporting).HighlightModeVariants
local FFlagHighlightModePreciseSelectionEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagHighlightModePreciseSelectionEnabled
local u13 = nil

if FFlagHighlightModePreciseSelectionEnabled then
	local LocalizationService = game:GetService("LocalizationService")

	u13 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
end

local function v15(p1, p2) -- line: 30
	-- upvalues: RobloxTranslator (copy), HighlightModeVariants (copy), u13 (ref), Cryo (copy), React (copy), StyledTextLabel (copy)
	local t1 = {
		RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription1"),
		RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription2"),
		RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription3")
	}

	if p1 ~= HighlightModeVariants.Default then
		t1 = {
			u13:Format("Feature.ReportAbuse.Label.SelectInSceneDescriptionPrecise1"),
			RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription2"),
			RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription3")
		}
	end

	local v20 = Cryo.List.map(t1, function(p3, p4) -- line: 45
		-- upvalues: React (copy), StyledTextLabel (copy), p2 (copy)
		return React.createElement(StyledTextLabel, {
			text = "• " .. p3,
			fontStyle = p2.Font.Body,
			colorStyle = p2.Theme.TextEmphasis,
			layoutOrder = p4,
			automaticSize = Enum.AutomaticSize.XY
		})
	end)
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 30)
		})
	}

	for i, v in ipairs(v20) do
		t2["Subheading" .. i] = v
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}, t2)
end
local function SelectInSceneReportMenu(t3: {[any]: any}) -- line: 73
	-- upvalues: useStyle (copy), React (copy), StyledTextLabel (copy), RobloxTranslator (copy), v15 (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v25 = useStyle()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 30)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 15)
		}),
		Title = React.createElement(StyledTextLabel, {
			layoutOrder = 0,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Heading.ReportUsingSelectInScene"),
			fontStyle = v25.Font.Header1,
			colorStyle = v25.Theme.TextEmphasis,
			automaticSize = Enum.AutomaticSize.XY
		}),
		SubheadingFrame = if not t3.variant then React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 30)
			}),
			Subheading1 = React.createElement(StyledTextLabel, {
				layoutOrder = 0,
				text = "• " .. RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription1"),
				fontStyle = v25.Font.Body,
				colorStyle = v25.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Subheading2 = React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				text = "• " .. RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription2"),
				fontStyle = v25.Font.Body,
				colorStyle = v25.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Subheading3 = React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				text = "• " .. RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription3"),
				fontStyle = v25.Font.Body,
				colorStyle = v25.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			})
		}) else v15(t3.variant, v25),
		EnterSelectInSceneButton = React.createElement(Button, {
			layoutOrder = 2,
			fitContent = true,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.EnterSceneReporting"),
			buttonType = ButtonType.PrimarySystem,
			standardSize = StandardButtonSize.Small,
			position = UDim2.new(0.5, 0, 0, 0),
			anchorPoint = Vector2.new(0.5, 0),
			onActivated = function() -- line: 144
				-- upvalues: t3 (copy)
				local SafetyService = game:GetService("SafetyService")
				local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")

				if game:GetEngineFeature("ExperienceStateCaptureIsInBackground") then
					local connection = nil

					connection = ExperienceStateCaptureService:GetPropertyChangedSignal("IsInBackground"):Connect(function() -- line: 151
						-- upvalues: connection (ref), ExperienceStateCaptureService (copy), t3 (copy)
						if not connection.Connected then
							return
						end

						if not ExperienceStateCaptureService.IsInBackground then
							t3.hideReportTab()
							connection:Disconnect()
						end
					end)
				end

				SafetyService.IsCaptureModeForReport = true
				ExperienceStateCaptureService:ToggleCaptureMode()
			end
		})
	})
end

return SelectInSceneReportMenu
