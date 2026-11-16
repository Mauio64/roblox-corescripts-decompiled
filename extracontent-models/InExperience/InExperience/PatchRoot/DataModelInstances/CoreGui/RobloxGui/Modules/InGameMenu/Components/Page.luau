local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent
local NavigateUp = require(parent.Thunks.NavigateUp)
local Assets = require(parent.Resources.Assets)
local Constants = require(parent.Resources.Constants)

local ZonePortal = require(parent.Components.ZonePortal)
local Direction = require(parent.Enums.Direction)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local Image = Foundation.Image

local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local function renderWithSelectionCursor(props, callback)
	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				IconEmphasis = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				},
				BackgroundContrast = {
					Color = p.Color.Surface.Surface_100.Color3,
					Transparency = p.Color.Surface.Surface_100.Transparency
				}
			}
		}
	end, function(p)
		local v3 = { ExtraChildren = props.titleChildren, BackButton = 0 }
		local backButton

		if FFlagCoreUiMigrateUIBloxToFoundation then
			backButton = Roact.createElement(Image, {
				Image = Assets.Images.NavigateBack,
				tag = "content-emphasis anchor-center-left size-900",
				backgroundStyle = { Transparency = 1 },
				Position = UDim2.new(0, 4, 0.5, 0),
				selection = {
					NextSelectionDown = props.NextSelectionDown,
					SelectionImageObject = callback(v2.RoundedRect)
				},
				onActivated = props.navigateUp,
				ref = props.buttonRef
			})
		else
			backButton = Roact.createElement(ImageSetButton, {
				BackgroundTransparency = 1,
				Image = Assets.Images.NavigateBack,
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = p.Theme.IconEmphasis.Color,
				ImageTransparency = p.Theme.IconEmphasis.Transparency,
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				NextSelectionDown = props.NextSelectionDown,
				[Roact.Event.Activated] = props.navigateUp,
				[Roact.Ref] = props.buttonRef,
				SelectionImageObject = callback(v2.RoundedRect)
			})
		end

		v3.BackButton = backButton

		return Roact.createElement("TextButton", {
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = p.Theme.BackgroundContrast.Color,
			BackgroundTransparency = p.Theme.BackgroundContrast.Transparency,
			BorderSizePixel = 0,
			Position = props.position,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = props.visible and not props.pageIsModal,
			ZIndex = props.zIndex,
			Selectable = false
		}, {
			PageTitle = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header1",
				themeKey = "TextEmphasis",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 28),
				Size = UDim2.new(1, -48, 0, 28),
				Text = props.pageTitle
			}, v3),
			PageContainer = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, Constants.Zone.ContentOffset, 1, 0),
				Size = UDim2.new(1, -Constants.Zone.ContentOffset, 1, -68)
			}, props[Roact.Children]),
			ZonePortal = Roact.createElement(ZonePortal, {
				targetZone = 0,
				direction = Direction.Left
			})
		})
	end)
end

local function Page(p)
	return v(function(p2)
		return renderWithSelectionCursor(p, p2)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		navigateUp = function()
			callback(NavigateUp)
		end
	}
end)(Page)
