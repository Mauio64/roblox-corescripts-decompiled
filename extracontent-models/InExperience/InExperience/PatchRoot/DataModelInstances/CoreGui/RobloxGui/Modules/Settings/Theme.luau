local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local Style2 = require(CorePackages.Workspace.Packages.Style)
local DarkTheme = Style2.Themes.DarkTheme
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize

local Display = require(CorePackages.Workspace.Packages.Display)
local getUIScale = Display.GetDisplayStore(false).getUIScale

local defineFastFlag = game:DefineFastFlag("IncreaseUtilityRowTextSizeConsole", false)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local FFlagRelocateMobileMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)

local v2 = {
	[Enum.FontSize.Size14] = Enum.FontSize.Size11,
	[Enum.FontSize.Size18] = Enum.FontSize.Size14,
	[Enum.FontSize.Size24] = Enum.FontSize.Size18,
	[Enum.FontSize.Size36] = Enum.FontSize.Size28,
	[Enum.FontSize.Size48] = Enum.FontSize.Size36
}

local color = Color3.fromRGB(0, 0, 0)
local default = AppFonts.default:getDefault()
local v3 = v2[Enum.FontSize.Size24]

local v4 = {
	MenuContainer = { Color = Color3.new(0, 0, 0), Transparency = 0.2 },
	IGM_TabSelection = { Color = Color3.new(1, 1, 1), Transparency = 0 },
	White = { Color = Color3.new(1, 1, 1), Transparency = 0 },
	IGM_Background = { Color = Color3.fromRGB(0, 0, 0), Transparency = 1 },
	IGM_Button = { Color = Color3.fromRGB(0, 0, 0), Transparency = 1 },
	IGM_ButtonNonInteractable = { Color = Color3.fromRGB(100, 100, 100), Transparency = 0 },
	IGM_ButtonHover = { Color = Color3.fromRGB(56, 57, 59), Transparency = 0 },
	IGM_Stroke = {
		Color = Color3.new(0.776, 0.776, 0.776),
		Transparency = 0
	},
	IGM_Selected = { Color = Color3.fromRGB(217, 217, 217), Transparency = 0 },
	Player_RowSelection = { Color = Color3.new(0.396, 0.4, 0.408), Transparency = 0.9 }
}

local v5 = {
	Confirmation_Font = {
		Font = AppFonts.default:getBold(),
		RelativeSize = v2[Enum.FontSize.Size36],
		TextSize = 28.584000000000003
	},
	Button_Font = {
		Font = AppFonts.default:getMedium(),
		RelativeSize = v2[Enum.FontSize.Size24],
		TextSize = 17.468
	},
	Username = 0,
	DisplayName = 0,
	Settings_Font = 0,
	Help_Title_Font = 0,
	Help_Text_Font = 0,
	Help_Gamepad_Font = 0,
	Help_Touch_Font = 0,
	Game_Settings_Font = 0,
	Conversation_Details_Font = 0,
	Utility_Text_Font = 0,
	Utility_Text_Small_Font = 0,
	Utility_Row_Small_Font = 0,
	Utility_Row_Font = 0,
	Back_Button_Font = 0,
	Semibold_Font = 0,
	Bold_Font = 0
}
local relativeSize

if v then
	relativeSize = v2[Enum.FontSize.Size24]
else
	relativeSize = v2[Enum.FontSize.Size18]
end

v5.Username = { RelativeSize = relativeSize }
local relativeSize2

if v then
	relativeSize2 = Enum.FontSize.Size24
else
	relativeSize2 = Enum.FontSize.Size18
end

v5.DisplayName = { RelativeSize = relativeSize2, Font = AppFonts.default:getMedium() }

v5.Settings_Font = { Font = AppFonts.default:getDefault() }

v5.Help_Title_Font = {
	Font = AppFonts.default:getMedium(),
	RelativeSize = v2[Enum.FontSize.Size18]
}

v5.Help_Text_Font = {
	Font = AppFonts.default:getDefault(),
	RelativeSize = v2[Enum.FontSize.Size18],
	TextSize = 14.292000000000002
}

v5.Help_Gamepad_Font = { Font = AppFonts.default:getMedium() }

v5.Help_Touch_Font = { Font = AppFonts.default:getBold(), RelativeSize = v2[Enum.FontSize.Size14] }

v5.Game_Settings_Font = {
	Font = AppFonts.default:getDefault(),
	RelativeSize = v2[Enum.FontSize.Size24]
}

v5.Conversation_Details_Font = { Font = AppFonts.default:getDefault(), TextSize = 12.704 }

v5.Utility_Text_Font = { Font = AppFonts.default:getDefault(), TextSize = 17.468 }

v5.Utility_Text_Small_Font = { Font = AppFonts.default:getDefault(), TextSize = 12.704 }

v5.Utility_Row_Small_Font = { Font = AppFonts.default:getDefault(), TextSize = 12.704 }

v5.Utility_Row_Font = {
	Font = AppFonts.default:getMedium(),
	TextSize = defineFastFlag and v and 19.056 or 12.704
}

v5.Back_Button_Font = { Font = AppFonts.default:getSemibold(), TextSize = 19.056 }

v5.Semibold_Font = { Font = AppFonts.default:getSemibold() }

v5.Bold_Font = { Font = AppFonts.default:getMedium() }

setmetatable(v4, {
	__index = function(_, p)
		return DarkTheme[p]
	end
})

local v6 = {
	SETTINGS_SHIELD = "IGM_Background",
	SETTINGS_SHIELD_TRANSPARENCY = "IGM_Background",
	SELECTION_TEXT_COLOR_NORMAL = "White",
	SELECTION_TEXT_COLOR_HIGHLIGHTED = "White",
	HubBarContainer = "IGM_Background",
	HubBarContainerTransparency = "IGM_Background",
	HubBarContainerHover = "IGM_Background",
	DarkenBackground = "Overlay",
	PlayerRowFrame = "BackgroundDefault",
	PlayerRowSelection = "Player_RowSelection",
	TabSelection = "IGM_TabSelection",
	DefaultButton = "IGM_Button",
	DefaultButtonHover = "IGM_ButtonHover",
	DefaultButtonStroke = "SecondaryDefault",
	WhiteButtonText = "SecondaryContent",
	MenuContainer = "BackgroundUIContrast",
	ControlInputText = "SystemPrimaryDefault",
	ControlInputStroke = "Divider",
	ControlInputBackground = "BackgroundDefault",
	ControlInputFocusedStroke = "IGM_TabSelection",
	InputActionBackground = "BackgroundUIDefault",
	IconButton = "UIDefault",
	IconButtonHover = "BackgroundOnHover",
	ImageButton = "Divider",
	RowFrameBackground = "BackgroundDefault",
	DropdownListBg = "BackgroundUIDefault",
	DropdownListFocusBg = "UIDefault",
	SELECTED_COLOR = "IGM_Selected",
	NON_SELECTED_COLOR = "BackgroundUIDefault",
	NotInteractableSelection = "UIEmphasis",
	Confirmation = "Confirmation_Font",
	Button = "Button_Font",
	SettingsHub = "Settings_Font",
	HelpTitle = "Help_Title_Font",
	HelpText = "Help_Text_Font",
	HelpGamepad = "Help_Gamepad_Font",
	HelpTouch = "Help_Touch_Font",
	GameSettings = "Game_Settings_Font",
	ConversationDetails = "Conversation_Details_Font",
	UtilityText = "Utility_Text_Font",
	UtilityRow = "Utility_Row_Font",
	UtilityRowSmall = "Utility_Row_Small_Font",
	UtilityTextSmall = "Utility_Text_Small_Font",
	BackButton = "Back_Button_Font",
	Semibold = "Semibold_Font",
	Bold = "Bold_Font",
	ShareLinkTitle = "Utility_Text_Font",
	ButtonNonInteractable = "IGM_ButtonNonInteractable"
}

local function getViewportSize()
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Vector2.new(1024, 1024)
	end

	if
		not workspace.CurrentCamera
		or (workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) or workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1))
	then
		return nil
	end

	return workspace.CurrentCamera.ViewportSize
end

local v7 = getViewportSize()

local v8 = v7 and UserInputService.TouchEnabled and (v7.Y < 500 or v7.X < 700)
local v9 = {
	PaddingTop = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 20),
	PaddingRight = UDim.new(0, 20),
	PaddingBottom = UDim.new(0, 14)
}

local v10 = {
	PaddingTop = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
	PaddingBottom = 0
}
local paddingBottom

if
	FFlagRelocateMobileMenuButtons
	and (FIntRelocateMobileMenuButtonsVariant == 1 or FIntRelocateMobileMenuButtonsVariant == 3)
then
	paddingBottom = UDim.new(0, 24)
else
	paddingBottom = UDim.new(0, 12)
end

v10.PaddingBottom = paddingBottom

local v11 = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 10),
	Size = UDim2.new(0, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.XY
}

local v12 = {
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, 8),
	Size = UDim2.new(0, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.XY
}
local Theme = {}
Theme.DefaultScrollBarThickness = 1
Theme.DefaultCornerRadius = UDim.new(0, 8)
Theme.MenuContainerCornerRadius = UDim.new(0, 10)
Theme.DefaultStokeThickness = 1

function Theme.AlwaysShowBottomBar(): boolean
	return not v8
end

Theme.TabHeaderIconPadding = 5

function Theme.UseInspectAndBuyPanel()
	return v8
end

Theme.ExtraHubBottomPaddingMobile = 12

function Theme.HubPadding()
	local function fn() -- 1 equivalent call inferred from this helper
		local viewportSize = getViewportSize()

		return viewportSize and UserInputService.TouchEnabled and (viewportSize.Y < 500 or viewportSize.X < 700)
	end

	if FFlagRelocateMobileMenuButtons and FIntRelocateMobileMenuButtonsVariant ~= 0 then
		return if fn() then v10 else v9 -- inferred equivalent call
	else
		return if v8 then v10 else v9
	end
end

function Theme.MenuContainerPosition(object)
	local v13 = isInExperienceUIVREnabled and object and object:getMenuContainerPositionOverride()

	if v13 then
		return v13
	end

	return if v8 then v12 else v11
end

Theme.ExtraPageBottomPaddingMobile = 48
Theme.ButtonHeight = 36
Theme.LargeButtonHeight = 48
Theme.SelectorArrowButtonWidth = 32
Theme.Images = Images
Theme.getIconSize = getIconSize
Theme.IconSize = IconSize
Theme.SHIELD_INACTIVE_POSITION = UDim2.new(0, 0, 1, 36)
function Theme.viewportResized()
	v7 = getViewportSize()
	v8 = v7 and UserInputService.TouchEnabled and (v7.Y < 500 or v7.X < 700)
end
function Theme.color(p: string, color2: Color3?)
	local v13 = v6[p] or p

	if v4[v13] then
		return v4[v13].Color
	end

	return color2 or color
end

function Theme.transparency(p: string, value: number?)
	local v13 = v6[p] or p

	if v4[v13] then
		return v4[v13].Transparency
	end

	return value or 0
end

function Theme.font(p, p2: string?)
	if not p2 then
		return default
	end

	local v13 = v6[p2] or p2

	if v5[v13] then
		return v5[v13].Font
	end

	return p or default
end

function Theme.fontSize(p, p2: string?)
	if not p2 then
		return v2[p]
	end

	local v13 = v6[p2] or p2

	if v5[v13] then
		return v5[v13].RelativeSize
	end

	return p or v3
end

function Theme.textSize(p: number, p2: string?)
	local uiScale = getUIScale(false)

	if not p2 then
		return p * 0.794 * uiScale
	end

	local v13 = v8 and p2 == "UtilityRow" and "UtilityRowSmall"
		or v8 and p2 == "UtilityText" and "UtilityTextSmall"
		or p2

	local v14 = v6[v13] or v13

	if p == nil then
		if v5[v14] and v5[v14].TextSize then
			return v5[v14].TextSize
		end

		return p * 0.794 or 19
	elseif v5[v14] and v5[v14].TextSize then
		return v5[v14].TextSize * uiScale
	else
		return p * 0.794 * uiScale
	end
end

function Theme.hydrateLabel(p, p2: string, p3: string)
	local v13 = v6[p2] or p2

	if v4[v13] then
		local v14 = v4[v13]
		p.TextColor3 = v14.Color
		p.TextTransparency = v14.Transparency
	end

	if v5[p3] then
		local v14 = v5[v13]
		p.Font = v14.RelativeSize * 19.2
		p.TextSize = v14.TextSize
	end
end

Theme.platformNameTextSize = 18
Theme.platformNameIconSize = UDim2.fromOffset(36, 36)
Theme.selectionCursor = v4.SelectionCursor
return Theme
