local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagVngAppUpsellPcLayout = SharedFlags.FFlagVngAppUpsellPcLayout
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local v22 = game:DefineFastString("VngAppUpsellUrl", "https://www.roblox.com")
local v23 = game:DefineFastString("VngAppUpsellProTipTextEn", "")
local v24 = game:DefineFastString("VngAppUpsellProTipTextVn", "")

local function VngAppUpsellOverlay(t1: {[any]: any}) -- line: 39
	-- upvalues: useStyle (copy), useDesignTokens (copy), FFlagVngAppUpsellPcLayout (copy), useAppPolicy (copy), useLocalization (copy), useRoactService (copy), AppLinking (copy), useDispatch (copy), useSelector (copy), React (copy), CloseCentralOverlay (copy), RoactLocalization (copy), v24 (copy), v23 (copy), GuiService (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FullPageModal (copy), ButtonType (copy), v22 (copy), StyledTextLabel (copy)
	local v27 = useStyle()
	local v28 = useDesignTokens()
	local v29 = not not FFlagVngAppUpsellPcLayout and useAppPolicy(function(p1) -- line: 43
		return p1.getVngAppUpsellPcLayout()
	end)
	local v30 = useLocalization({
		vngUpsellProtip = "CommonUI.Features.Label.VNGMigrationTip",
		vngUpsellTitle = not v29 and "CommonUI.Features.Label.VNGMigrationTitle" or "CommonUI.Features.Label.VNGMigrationTitlePC",
		vngUpsellBody = not v29 and "CommonUI.Features.Label.VNGMigrationBody" or "CommonUI.Features.Label.VNGMigrationBodyPC",
		vngUpsellButtonText = not v29 and "CommonUI.Features.Label.VNGMigrationGoButton" or "CommonUI.Features.Label.VNGMigrationGoButtonPC"
	})
	local v31 = useRoactService(AppLinking)
	local v32 = useDispatch()
	local v33 = useSelector(function(p2) -- line: 62
		return p2.ScreenSize
	end)
	local v34 = React.useCallback(function() -- line: 66
		-- upvalues: v32 (copy), CloseCentralOverlay (copy)
		v32(CloseCentralOverlay())
	end, {})
	local vngUpsellProtip = v30.vngUpsellProtip
	local Locale = useRoactService(RoactLocalization):GetLocale()

	if v24 ~= "" and Locale == "vi-vn" then
		vngUpsellProtip = v24
	elseif v23 ~= "" and Locale == "en-us" then
		vngUpsellProtip = v23
	end

	local SafeZoneOffsets = GuiService:GetSafeZoneOffsets()
	local v38 = if not FFlagRenameDeprecatedUIBloxTokens then v28.Global.Size_250 else v28.Size.Size_500
	local v39 = SafeZoneOffsets.top + v38
	local v40 = v38 + 186 + if not FFlagRenameDeprecatedUIBloxTokens then v28.Global.Size_400 else v28.Size.Size_800

	return React.createElement(FullPageModal, {
		screenSize = v33,
		title = v30.vngUpsellTitle,
		distanceFromTop = v39,
		onCloseClicked = if not t1.isDismissable then nil else v34,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = function() -- line: 103
						-- upvalues: v22 (copy), v31 (copy)
						local v43 = v22

						v31:openURL(v43)
					end,
					text = v30.vngUpsellButtonText
				}
			}}
		}
	}, {
		ContentFrame = React.createElement("ScrollingFrame", {
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			BackgroundTransparency = v27.Theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = v27.Theme.BackgroundUIDefault.Color,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Selectable = not FFlagVngAppUpsellPcLayout and nil,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0)
		}, {
			VngIcon = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 186, 0, 186),
				Image = not v29 and "rbxasset://textures/ui/LuaApp/icons/ic_launcher_vng_square_xxxhdpi.png" or "rbxasset://textures/ui/LuaApp/icons/pc_icon_vng_square_xxxhdpi.png",
				Position = UDim2.new(0.5, 0, 0, v38),
				AnchorPoint = Vector2.new(0.5, 0)
			}),
			Contents = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0, v40),
				AnchorPoint = Vector2.new(0.5, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v38)
				}),
				BodyText = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					automaticSize = Enum.AutomaticSize.Y,
					text = v30.vngUpsellBody,
					colorStyle = v27.Theme.TextEmphasis,
					fontStyle = v27.Font.HeadingSmall,
					size = UDim2.new(1, 0, 0, 0),
					textXAlignment = Enum.TextXAlignment.Center
				}),
				Protip = if v29 then nil else React.createElement(StyledTextLabel, {
					layoutOrder = 2,
					automaticSize = Enum.AutomaticSize.Y,
					text = vngUpsellProtip,
					colorStyle = v27.Theme.TextDefault,
					fontStyle = v27.Font.BodyLarge,
					size = UDim2.new(1, 0, 0, 0),
					textXAlignment = Enum.TextXAlignment.Center
				}),
				BottomPadding = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 1)
				})
			})
		})
	})
end

return VngAppUpsellOverlay
