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

local InGameAssetReporting = require(CorePackages.Workspace.Packages.InGameAssetReporting)
local HighlightModeVariants = InGameAssetReporting.HighlightModeVariants
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local localization

if SharedFlags.FFlagHighlightModePreciseSelectionEnabled then
	local LocalizationService = game:GetService("LocalizationService")
	local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
	localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
else
	localization = nil
end

local function fn(variant, p)
	local v = {
		RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription1"),
		RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription2"),
		RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription3")
	}

	local v2 = variant ~= HighlightModeVariants.Default
		and {
			localization:Format("Feature.ReportAbuse.Label.SelectInSceneDescriptionPrecise1"),
			RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription2"),
			RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription3")
		}
		or v

	local mapped = Cryo.List.map(v2, function(p2, layoutOrder)
		return React.createElement(StyledTextLabel, {
			text = "• " .. p2,
			fontStyle = p.Font.Body,
			colorStyle = p.Theme.TextEmphasis,
			layoutOrder = layoutOrder,
			automaticSize = Enum.AutomaticSize.XY
		})
	end)

	local v3 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 30)
		})
	}

	for i, v4 in ipairs(mapped) do
		v3["Subheading" .. i] = v4
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		LayoutOrder = 1
	}, v3)
end

local function SelectInSceneReportMenu(p)
	local v = useStyle()

	local createElement = React.createElement
	local v2 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v3 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 30)
		}),
		Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 15) }),
		Title = React.createElement(StyledTextLabel, {
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Heading.ReportUsingSelectInScene"),
			fontStyle = v.Font.Header1,
			colorStyle = v.Theme.TextEmphasis,
			layoutOrder = 0,
			automaticSize = Enum.AutomaticSize.XY
		}),
		SubheadingFrame = 0,
		EnterSelectInSceneButton = 0
	}
	local subheadingFrame

	if p.variant then
		subheadingFrame = fn(p.variant, v)
	else
		subheadingFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			LayoutOrder = 1
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 30)
			}),
			Subheading1 = React.createElement(StyledTextLabel, {
				text = "• " .. RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription1"),
				fontStyle = v.Font.Body,
				colorStyle = v.Theme.TextEmphasis,
				layoutOrder = 0,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Subheading2 = React.createElement(StyledTextLabel, {
				text = "• " .. RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription2"),
				fontStyle = v.Font.Body,
				colorStyle = v.Theme.TextEmphasis,
				layoutOrder = 1,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Subheading3 = React.createElement(StyledTextLabel, {
				text = "• " .. RobloxTranslator:FormatByKey("Feature.ReportAbuse.Label.SelectInSceneDescription3"),
				fontStyle = v.Font.Body,
				colorStyle = v.Theme.TextEmphasis,
				layoutOrder = 2,
				automaticSize = Enum.AutomaticSize.XY
			})
		})
	end

	v3.SubheadingFrame = subheadingFrame

	v3.EnterSelectInSceneButton = React.createElement(Button, {
		text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.EnterSceneReporting"),
		buttonType = ButtonType.PrimarySystem,
		standardSize = StandardButtonSize.Small,
		layoutOrder = 2,
		position = UDim2.new(0.5, 0, 0, 0),
		anchorPoint = Vector2.new(0.5, 0),
		fitContent = true,
		onActivated = function()
			local SafetyService = game:GetService("SafetyService")
			local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")

			if game:GetEngineFeature("ExperienceStateCaptureIsInBackground") then
				local isInBackgroundChangedConnection = nil
				isInBackgroundChangedConnection = ExperienceStateCaptureService:GetPropertyChangedSignal("IsInBackground"):Connect(function()
					if not isInBackgroundChangedConnection.Connected then
						return
					end

					if not ExperienceStateCaptureService.IsInBackground then
						p.hideReportTab()
						isInBackgroundChangedConnection:Disconnect()
					end
				end)
			end

			SafetyService.IsCaptureModeForReport = true
			ExperienceStateCaptureService:ToggleCaptureMode()
		end
	})
	return createElement("Frame", v2, v3)
end

return SelectInSceneReportMenu
