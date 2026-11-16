local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local fullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local fFlagVngAppUpsellPcLayout = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagVngAppUpsellPcLayout

local module = require("@luauforge/bundled/edB")
local defineFastString = game:DefineFastString("VngAppUpsellUrl", "https://www.roblox.com")
local defineFastString2 = game:DefineFastString("VngAppUpsellProTipTextEn", "")
local defineFastString3 = game:DefineFastString("VngAppUpsellProTipTextVn", "")

local function VngAppUpsellOverlay(p2)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local v7

	if fFlagVngAppUpsellPcLayout then
		v7 = useAppPolicy(function(p3)
			return p3.getVngAppUpsellPcLayout()
		end)
	else
		v7 = false
	end

	local v8 = useLocalization({
		vngUpsellTitle = v7 and "CommonUI.Features.Label.VNGMigrationTitlePC" or "CommonUI.Features.Label.VNGMigrationTitle",
		vngUpsellBody = v7 and "CommonUI.Features.Label.VNGMigrationBodyPC" or "CommonUI.Features.Label.VNGMigrationBody",
		vngUpsellProtip = "CommonUI.Features.Label.VNGMigrationTip",
		vngUpsellButtonText = v7 and "CommonUI.Features.Label.VNGMigrationGoButtonPC" or "CommonUI.Features.Label.VNGMigrationGoButton"
	})

	local v9 = useRoactService(appLinking)
	local v10 = useDispatch()
	local v11 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local v12 = React.useCallback(function()
		v10(closeCentralOverlay())
	end, {})

	local v13 = v8.vngUpsellProtip
	local locale = useRoactService(module):GetLocale()

	if defineFastString3 == "" or locale ~= "vi-vn" then
		if defineFastString2 ~= "" and locale == "en-us" then
			v13 = defineFastString2
		end
	else
		v13 = defineFastString3
	end

	local safeZoneOffsets = GuiService:GetSafeZoneOffsets()

	local size_500 = v6.Size.Size_500
	local v14 = safeZoneOffsets.top + size_500

	local v15 = size_500 + 186 + v6.Size.Size_800

	local createElement = React.createElement
	local v17 = {
		screenSize = v11,
		title = v8.vngUpsellTitle,
		distanceFromTop = v14,
		onCloseClicked = 0,
		buttonStackProps = 0
	}

	if not p2.isDismissable then
		v12 = nil
	end

	v17.onCloseClicked = v12
	v17.buttonStackProps = {
		buttons = {
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					onActivated = function()
						v9:openURL(defineFastString)
					end,
					text = v8.vngUpsellButtonText
				}
			}
		}
	}

	local createElement2 = React.createElement
	local v20 = {
		BackgroundTransparency = v5.Theme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = v5.Theme.BackgroundUIDefault.Color,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BorderSizePixel = 0,
		Selectable = if fFlagVngAppUpsellPcLayout then false else nil,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0)
	}
	local v22 = {
		VngIcon = React.createElement("ImageLabel", {
			Size = UDim2.new(0, 186, 0, 186),
			BackgroundTransparency = 1,
			Image = v7 and "rbxasset://textures/ui/LuaApp/icons/pc_icon_vng_square_xxxhdpi.png" or "rbxasset://textures/ui/LuaApp/icons/ic_launcher_vng_square_xxxhdpi.png",
			Position = UDim2.new(0.5, 0, 0, size_500),
			AnchorPoint = Vector2.new(0.5, 0)
		}),
		Contents = 0
	}

	local createElement3 = React.createElement
	local v24 = {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0, v15),
		AnchorPoint = Vector2.new(0.5, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local v25 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, size_500)
		}),
		BodyText = React.createElement(styledTextLabel, {
			layoutOrder = 1,
			automaticSize = Enum.AutomaticSize.Y,
			text = v8.vngUpsellBody,
			colorStyle = v5.Theme.TextEmphasis,
			fontStyle = v5.Font.HeadingSmall,
			size = UDim2.new(1, 0, 0, 0),
			textXAlignment = Enum.TextXAlignment.Center
		}),
		Protip = 0,
		BottomPadding = 0
	}

	local v26 = if not v7 then React.createElement(styledTextLabel, {
		layoutOrder = 2,
		automaticSize = Enum.AutomaticSize.Y,
		text = v13,
		colorStyle = v5.Theme.TextDefault,
		fontStyle = v5.Font.BodyLarge,
		size = UDim2.new(1, 0, 0, 0),
		textXAlignment = Enum.TextXAlignment.Center
	}) else nil
	v25.Protip = v26

	v25.BottomPadding = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 4
	})
	v22.Contents = createElement3("Frame", v24, v25)
	return createElement(fullPageModal, v17, {
		ContentFrame = createElement2("ScrollingFrame", v20, v22)
	})
end

return VngAppUpsellOverlay
