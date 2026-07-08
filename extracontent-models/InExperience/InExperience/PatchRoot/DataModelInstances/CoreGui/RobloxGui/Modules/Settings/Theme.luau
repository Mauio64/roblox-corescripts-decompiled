local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local v4 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local DarkTheme = require(CorePackages.Workspace.Packages.Style).Themes.DarkTheme
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getUIScale = require(CorePackages.Workspace.Packages.Display).GetDisplayStore(false).getUIScale
local v12 = game:DefineFastFlag("IncreaseUtilityRowTextSizeConsole", false)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagRelocateMobileMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local t1 = {
	[Enum.FontSize.Size14] = Enum.FontSize.Size11,
	[Enum.FontSize.Size18] = Enum.FontSize.Size14,
	[Enum.FontSize.Size24] = Enum.FontSize.Size18,
	[Enum.FontSize.Size36] = Enum.FontSize.Size28,
	[Enum.FontSize.Size48] = Enum.FontSize.Size36
}
local color3 = Color3.fromRGB(0, 0, 0)
local v18 = AppFonts.default:getDefault()
local v19 = t1[Enum.FontSize.Size24]
local t2 = {
	MenuContainer = {
		Transparency = 0.2,
		Color = Color3.new(0, 0, 0)
	},
	IGM_TabSelection = {
		Transparency = 0,
		Color = Color3.new(1, 1, 1)
	},
	White = {
		Transparency = 0,
		Color = Color3.new(1, 1, 1)
	},
	IGM_Background = {
		Transparency = 1,
		Color = Color3.fromRGB(0, 0, 0)
	},
	IGM_Button = {
		Transparency = 1,
		Color = Color3.fromRGB(0, 0, 0)
	},
	IGM_ButtonNonInteractable = {
		Transparency = 0,
		Color = Color3.fromRGB(100, 100, 100)
	},
	IGM_ButtonHover = {
		Transparency = 0,
		Color = Color3.fromRGB(56, 57, 59)
	},
	IGM_Stroke = {
		Transparency = 0,
		Color = Color3.new(0.776, 0.776, 0.776)
	},
	IGM_Selected = {
		Transparency = 0,
		Color = Color3.fromRGB(217, 217, 217)
	},
	Player_RowSelection = {
		Transparency = 0.9,
		Color = Color3.new(0.396, 0.4, 0.408)
	}
}
local t3 = {
	Confirmation_Font = {
		TextSize = 28.584000000000003,
		Font = AppFonts.default:getBold(),
		RelativeSize = t1[Enum.FontSize.Size36]
	},
	Button_Font = {
		TextSize = 17.468,
		Font = AppFonts.default:getMedium(),
		RelativeSize = t1[Enum.FontSize.Size24]
	},
	Username = {
		RelativeSize = if not v4 then t1[Enum.FontSize.Size18] else t1[Enum.FontSize.Size24]
	},
	DisplayName = {
		RelativeSize = if not v4 then Enum.FontSize.Size18 else Enum.FontSize.Size24,
		Font = AppFonts.default:getMedium()
	},
	Settings_Font = {
		Font = AppFonts.default:getDefault()
	},
	Help_Title_Font = {
		Font = AppFonts.default:getMedium(),
		RelativeSize = t1[Enum.FontSize.Size18]
	},
	Help_Text_Font = {
		TextSize = 14.292000000000002,
		Font = AppFonts.default:getDefault(),
		RelativeSize = t1[Enum.FontSize.Size18]
	},
	Help_Gamepad_Font = {
		Font = AppFonts.default:getMedium()
	},
	Help_Touch_Font = {
		Font = AppFonts.default:getBold(),
		RelativeSize = t1[Enum.FontSize.Size14]
	},
	Game_Settings_Font = {
		Font = AppFonts.default:getDefault(),
		RelativeSize = t1[Enum.FontSize.Size24]
	},
	Conversation_Details_Font = {
		TextSize = 12.704,
		Font = AppFonts.default:getDefault()
	},
	Utility_Text_Font = {
		TextSize = 17.468,
		Font = AppFonts.default:getDefault()
	},
	Utility_Text_Small_Font = {
		TextSize = 12.704,
		Font = AppFonts.default:getDefault()
	},
	Utility_Row_Small_Font = {
		TextSize = 12.704,
		Font = AppFonts.default:getDefault()
	},
	Utility_Row_Font = {
		Font = AppFonts.default:getMedium(),
		TextSize = (not v12 or not v4) and 12.704 or 19.056
	},
	Back_Button_Font = {
		TextSize = 19.056,
		Font = AppFonts.default:getSemibold()
	},
	Semibold_Font = {
		Font = AppFonts.default:getSemibold()
	},
	Bold_Font = {
		Font = AppFonts.default:getMedium()
	}
}

setmetatable(t2, {
	__index = function(_, p2) -- line: 163
		-- upvalues: DarkTheme (copy)
		return DarkTheme[p2]
	end
})

local t4 = {
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

local function getViewportSize() -- line: 235
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Vector2.new(1024, 1024)
	end

	if not workspace.CurrentCamera then
		return nil
	end

	if workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) or workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1) then
		return nil
	end

	return workspace.CurrentCamera.ViewportSize
end

local u24 = getViewportSize()
local u25 = u24 and (UserInputService.TouchEnabled and (u24.Y < 500 or u24.X < 700))
local t5 = {
	PaddingTop = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 20),
	PaddingRight = UDim.new(0, 20),
	PaddingBottom = UDim.new(0, 14)
}
local t6 = {
	PaddingTop = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
	PaddingBottom = if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant ~= 1 and FIntRelocateMobileMenuButtonsVariant ~= 3 then UDim.new(0, 12) else UDim.new(0, 24)
}
local t7 = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 10),
	Size = UDim2.new(0, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.XY
}
local t8 = {
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, 8),
	Size = UDim2.new(0, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.XY
}

return {
	DefaultScrollBarThickness = 1,
	DefaultStokeThickness = 1,
	TabHeaderIconPadding = 5,
	ExtraHubBottomPaddingMobile = 12,
	ExtraPageBottomPaddingMobile = 48,
	ButtonHeight = 36,
	LargeButtonHeight = 48,
	SelectorArrowButtonWidth = 32,
	platformNameTextSize = 18,
	DefaultCornerRadius = UDim.new(0, 8),
	MenuContainerCornerRadius = UDim.new(0, 10),
	AlwaysShowBottomBar = function() -- line: 292
		-- upvalues: u25 (ref)
		return not u25
	end,
	UseInspectAndBuyPanel = function() -- line: 296
		-- upvalues: u25 (ref)
		return u25
	end,
	HubPadding = function() -- line: 300
		-- upvalues: FFlagRelocateMobileMenuButtons (copy), FIntRelocateMobileMenuButtonsVariant (copy), getViewportSize (copy), UserInputService (copy), t6 (copy), t5 (copy), u25 (ref)
		if FFlagRelocateMobileMenuButtons and FIntRelocateMobileMenuButtonsVariant ~= 0 then
			local v32 = getViewportSize()

			if v32 and (UserInputService.TouchEnabled and (v32.Y < 500 or v32.X < 700)) then
				return t6
			end

			return t5
		end

		if u25 then
			return t6
		end

		return t5
	end,
	MenuContainerPosition = function(p3) -- line: 323
		-- upvalues: isInExperienceUIVREnabled (copy), u25 (ref), t8 (copy), t7 (copy)
		if isInExperienceUIVREnabled and p3 then
			local v34 = p3:getMenuContainerPositionOverride()

			if v34 then
				return v34
			end
		end

		if u25 then
			return t8
		end

		return t7
	end,
	Images = Images,
	getIconSize = getIconSize,
	IconSize = IconSize,
	SHIELD_INACTIVE_POSITION = UDim2.new(0, 0, 1, 36),
	viewportResized = function() -- line: 344
		-- upvalues: u24 (ref), getViewportSize (copy), u25 (ref), UserInputService (copy)
		u24 = getViewportSize()
		u25 = u24 and (UserInputService.TouchEnabled and (u24.Y < 500 or u24.X < 700))
	end,
	color = function(s1: string, color3_2: Color3?) -- line: 350
		-- upvalues: t4 (copy), t2 (copy), color3 (copy)
		local v37 = t4[s1] or s1

		if t2[v37] then
			return t2[v37].Color
		end

		return color3_2 or color3
	end,
	transparency = function(s2: string, n1: number?) -- line: 354
		-- upvalues: t4 (copy), t2 (copy)
		local v40 = t4[s2] or s2

		if t2[v40] then
			return t2[v40].Transparency
		end

		return n1 or 0
	end,
	font = function(p4, s3: string?) -- line: 358
		-- upvalues: v18 (copy), t4 (copy), t3 (copy)
		if not s3 then
			return v18
		end

		local v43 = t4[s3] or s3

		if t3[v43] then
			return t3[v43].Font
		end

		return p4 or v18
	end,
	fontSize = function(p5, s4: string?) -- line: 365
		-- upvalues: t1 (copy), t4 (copy), t3 (copy), v19 (copy)
		if not s4 then
			return t1[p5]
		end

		local v46 = t4[s4] or s4

		if t3[v46] then
			return t3[v46].RelativeSize
		end

		return p5 or v19
	end,
	textSize = function(n2: number, s5: string?) -- line: 372
		-- upvalues: getUIScale (copy), u25 (ref), t4 (copy), t3 (copy)
		local v49 = getUIScale(false)

		if not s5 then
			return n2 * 0.794 * v49
		end

		if u25 and s5 == "UtilityRow" then
			s5 = "UtilityRowSmall"
		elseif u25 and s5 == "UtilityText" then
			s5 = "UtilityTextSmall"
		end

		local v50 = t4[s5] or s5

		if n2 ~= nil then
			if t3[v50] and t3[v50].TextSize then
				return t3[v50].TextSize * v49
			end

			return n2 * 0.794 * v49
		end

		if t3[v50] and t3[v50].TextSize then
			return t3[v50].TextSize
		end

		return n2 * 0.794 or 19
	end,
	hydrateLabel = function(p6, s6: string, s7: string) -- line: 393
		-- upvalues: t4 (copy), t2 (copy), t3 (copy)
		local v54 = t4[s6] or s6

		if t2[v54] then
			local v55 = t2[v54]

			p6.TextColor3 = v55.Color
			p6.TextTransparency = v55.Transparency
		end

		if t3[s7] then
			local v56 = t3[v54]

			p6.Font = v56.RelativeSize * 19.2
			p6.TextSize = v56.TextSize
		end
	end,
	platformNameIconSize = UDim2.fromOffset(36, 36),
	selectionCursor = t2.SelectionCursor
}
