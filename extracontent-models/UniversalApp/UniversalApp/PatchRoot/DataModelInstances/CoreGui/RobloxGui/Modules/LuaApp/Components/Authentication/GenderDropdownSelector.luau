local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local AppDropdownMenu = require(Modules.LuaApp.Components.Common.AppDropdownMenu)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local UserGender = AuthCommon.Enums.UserGender
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent
local GetFFlagEnableAuditForSso = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuditForSso
local t1 = {
	[Enum.HorizontalAlignment.Left] = Vector2.new(0, 0),
	[Enum.HorizontalAlignment.Center] = Vector2.new(0.5, 0),
	[Enum.HorizontalAlignment.Right] = Vector2.new(1, 0)
}
local t2 = {
	[Enum.HorizontalAlignment.Left] = UDim2.fromScale(0, 0),
	[Enum.HorizontalAlignment.Center] = UDim2.fromScale(0.5, 0),
	[Enum.HorizontalAlignment.Right] = UDim2.fromScale(1, 0)
}

return function(t3: {[any]: any}) -- line: 42
	-- upvalues: useStyle (copy), useLocalization (copy), useSelector (copy), useDesignTokens (copy), React (copy), t1 (copy), t2 (copy), AppDropdownMenu (copy), UserGender (copy), GetFFlagEnableAuditForSso (copy), RegisterAuditContent (copy)
	local v16 = useStyle()
	local v17 = useLocalization({
		titleText = "Authentication.SignUp.Label.Gender",
		optionalText = "Authentication.SignUp.Label.OptionalGenderShort",
		maleText = "Authentication.SignUp.Label.GenderMale",
		femaleText = "Authentication.SignUp.Label.GenderFemale"
	})
	local v18 = useSelector(function(p1) -- line: 50
		return p1.ScreenSize or Vector2.new(1920, 1080)
	end)
	local SignUpView = useDesignTokens().LuaApps.SignUpView
	local dropdownHeight = SignUpView.dropdownHeight
	local dropdownVerticalPadding = SignUpView.dropdownVerticalPadding
	local v22 = t3.alignment or Enum.HorizontalAlignment.Left

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 270, 1, 0),
		AnchorPoint = t1[v22],
		Position = t2[v22],
		LayoutOrder = t3.layoutOrder
	}, {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, dropdownVerticalPadding)
		}),
		Title = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 6)
			}),
			MainTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextWrapped = false,
				Font = v16.Font.CaptionHeader.Font,
				Size = UDim2.fromScale(0, 0),
				Text = v17.titleText,
				TextColor3 = v16.Theme.TextEmphasis.Color,
				TextSize = SignUpView.textCaptionHeaderSize,
				TextTransparency = v16.Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			OptionalTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				TextWrapped = false,
				Font = v16.Font.Footer.Font,
				Size = UDim2.fromScale(0, 0),
				Text = "(" .. v17.optionalText .. ")",
				TextColor3 = v16.Theme.TextMuted.Color,
				TextSize = SignUpView.textSmallSize,
				TextTransparency = v16.Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY
			})
		}),
		GenderPicker = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			ZIndex = 2,
			Size = UDim2.new(0, 270, 0, dropdownHeight)
		}, {
			GenderDropdownMenu = React.createElement(AppDropdownMenu, {
				placeholder = "--",
				showDropShadow = true,
				analyticsContext = "GenderDropdownMenu",
				selectionGroupName = "GenderDropdownMenu",
				height = UDim.new(0, dropdownHeight),
				screenSize = v18,
				onChange = t3.onGenderChanged,
				cellDatas = {
					{
						key = UserGender.Male,
						text = v17.maleText
					},
					{
						key = UserGender.Female,
						text = v17.femaleText
					},
					{
						text = "--",
						key = UserGender.Unknown
					}
				}
			})
		}),
		RegisterTitleAuditContent = if not GetFFlagEnableAuditForSso() or (not RegisterAuditContent or (not t3.enableAuditContentCapture or not v17.titleText)) then nil else React.createElement(RegisterAuditContent, {
			translationKey = "Authentication.SignUp.Label.Gender",
			translatedSourceString = v17.titleText
		})
	})
end
