local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle
local module = require("@luauforge/bundled/hAC")

local module2 = require("@luauforge/bundled/fTi")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local userGender = AuthCommon.Enums.UserGender
local registerAuditContent = AuthCommon.Components.RegisterAuditContent

local getFFlagEnableAuditForSso = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSso

local vector2s = {
	[Enum.HorizontalAlignment.Left] = Vector2.new(0, 0),
	[Enum.HorizontalAlignment.Center] = Vector2.new(0.5, 0),
	[Enum.HorizontalAlignment.Right] = Vector2.new(1, 0)
}

local udims = {
	[Enum.HorizontalAlignment.Left] = UDim2.fromScale(0, 0),
	[Enum.HorizontalAlignment.Center] = UDim2.fromScale(0.5, 0),
	[Enum.HorizontalAlignment.Right] = UDim2.fromScale(1, 0)
}

return function(props)
	local v5 = useStyle()
	local v6 = module2({
		titleText = "Authentication.SignUp.Label.Gender",
		optionalText = "Authentication.SignUp.Label.OptionalGenderShort",
		maleText = "Authentication.SignUp.Label.GenderMale",
		femaleText = "Authentication.SignUp.Label.GenderFemale"
	})

	local v7 = useSelector(function(p2)
		return p2.ScreenSize or Vector2.new(1920, 1080)
	end)

	local v8 = useDesignTokens()

	local signUpView = v8.LuaApps.SignUpView
	local dropdownHeight = signUpView.dropdownHeight
	local dropdownVerticalPadding = signUpView.dropdownVerticalPadding

	local alignment = props.alignment or Enum.HorizontalAlignment.Left

	local createElement = React.createElement
	local v10 = {
		Size = UDim2.new(0, 270, 1, 0),
		AnchorPoint = vector2s[alignment],
		Position = udims[alignment],
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder
	}
	local children = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, dropdownVerticalPadding)
		}),
		Title = 0,
		GenderPicker = 0,
		RegisterTitleAuditContent = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local children2 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6)
		}),
		MainTitle = 0,
		OptionalTitle = 0
	}

	local createElement3 = React.createElement

	local v15 = if not foundationFontFaceMigration then v5.Font.CaptionHeader.Font else nil

	local v16 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.CaptionLarge.Font) else nil
	children2.MainTitle = createElement3("TextLabel", {
		BackgroundTransparency = 1,
		Font = v15,
		FontFace = v16,
		LayoutOrder = 1,
		Size = UDim2.fromScale(0, 0),
		Text = v6.titleText,
		TextColor3 = v5.Theme.TextEmphasis.Color,
		TextSize = signUpView.textCaptionHeaderSize,
		TextTransparency = v5.Theme.TextEmphasis.Transparency,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.XY
	})

	local createElement4 = React.createElement

	local v19 = if not foundationFontFaceMigration then v5.Font.Footer.Font else nil

	local v20 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.CaptionSmall.Font) else nil
	children2.OptionalTitle = createElement4("TextLabel", {
		BackgroundTransparency = 1,
		Font = v19,
		FontFace = v20,
		LayoutOrder = 2,
		Size = UDim2.fromScale(0, 0),
		Text = "(" .. v6.optionalText .. ")",
		TextColor3 = v5.Theme.TextMuted.Color,
		TextSize = signUpView.textSmallSize,
		TextTransparency = v5.Theme.TextMuted.Transparency,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.XY
	})
	children.Title = createElement2("Frame", v12, children2)

	children.GenderPicker = React.createElement("Frame", {
		Size = UDim2.new(0, 270, 0, dropdownHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		ZIndex = 2
	}, {
		GenderDropdownMenu = React.createElement(module, {
			height = UDim.new(0, dropdownHeight),
			placeholder = "--",
			screenSize = v7,
			showDropShadow = true,
			onChange = props.onGenderChanged,
			cellDatas = {
				{ key = userGender.Male, text = v6.maleText },
				{ key = userGender.Female, text = v6.femaleText },
				{ key = userGender.Unknown, text = "--" }
			},
			analyticsContext = "GenderDropdownMenu",
			selectionGroupName = "GenderDropdownMenu"
		})
	})

	local v21 = if getFFlagEnableAuditForSso() and registerAuditContent and props.enableAuditContentCapture and v6.titleText then React.createElement(registerAuditContent, {
		translationKey = "Authentication.SignUp.Label.Gender",
		translatedSourceString = v6.titleText
	}) else nil
	children.RegisterTitleAuditContent = v21
	return createElement("Frame", v10, children)
end
