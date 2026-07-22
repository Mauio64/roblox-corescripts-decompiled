local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v9 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent
local NavigateUp = require(ParentParent.Thunks.NavigateUp)
local Assets = require(ParentParent.Resources.Assets)
local Constants = require(ParentParent.Resources.Constants)
local ZonePortal = require(ParentParent.Components.ZonePortal)
local Direction = require(ParentParent.Enums.Direction)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local FoundationImage = Foundation.Image
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local function renderWithSelectionCursor(p1, p2) -- line: 37
	-- upvalues: withFoundationOrUIBloxStyle (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), FoundationImage (copy), Assets (copy), v10 (copy), ImageSetButton (copy), ThemedTextLabel (copy), Constants (copy), ZonePortal (copy), Direction (copy)
	return withFoundationOrUIBloxStyle(function(p3) -- line: 38
		return {
			Theme = {
				IconEmphasis = {
					Color = p3.Color.Content.Emphasis.Color3,
					Transparency = p3.Color.Content.Emphasis.Transparency
				},
				BackgroundContrast = {
					Color = p3.Color.Surface.Surface_100.Color3,
					Transparency = p3.Color.Surface.Surface_100.Transparency
				}
			}
		}
	end, function(p4) -- line: 51
		-- upvalues: p1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), FoundationImage (copy), Assets (copy), p2 (copy), v10 (copy), ImageSetButton (copy), ThemedTextLabel (copy), Constants (copy), ZonePortal (copy), Direction (copy)
		local t1 = {
			ExtraChildren = p1.titleChildren,
			BackButton = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetButton, {
				BackgroundTransparency = 1,
				Image = Assets.Images.NavigateBack,
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = p4.Theme.IconEmphasis.Color,
				ImageTransparency = p4.Theme.IconEmphasis.Transparency,
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				NextSelectionDown = p1.NextSelectionDown,
				[Roact.Event.Activated] = p1.navigateUp,
				[Roact.Ref] = p1.buttonRef,
				SelectionImageObject = p2(v10.RoundedRect)
			}) else Roact.createElement(FoundationImage, {
				tag = "content-emphasis anchor-center-left size-900",
				Image = Assets.Images.NavigateBack,
				backgroundStyle = {
					Transparency = 1
				},
				Position = UDim2.new(0, 4, 0.5, 0),
				selection = {
					NextSelectionDown = p1.NextSelectionDown,
					SelectionImageObject = p2(v10.RoundedRect)
				},
				onActivated = p1.navigateUp,
				ref = p1.buttonRef
			})
		}

		return Roact.createElement("TextButton", {
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
			Selectable = false,
			BackgroundColor3 = p4.Theme.BackgroundContrast.Color,
			BackgroundTransparency = p4.Theme.BackgroundContrast.Transparency,
			Position = p1.position,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = p1.visible and not p1.pageIsModal,
			ZIndex = p1.zIndex
		}, {
			PageTitle = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header1",
				themeKey = "TextEmphasis",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 28),
				Size = UDim2.new(1, -48, 0, 28),
				Text = p1.pageTitle
			}, t1),
			PageContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, Constants.Zone.ContentOffset, 1, 0),
				Size = UDim2.new(1, -Constants.Zone.ContentOffset, 1, -68)
			}, p1[Roact.Children]),
			ZonePortal = Roact.createElement(ZonePortal, {
				targetZone = 0,
				direction = Direction.Left
			})
		})
	end)
end
local function Page(p5) -- line: 117
	-- upvalues: v9 (copy), renderWithSelectionCursor (copy)
	return v9(function(p6) -- line: 118
		-- upvalues: renderWithSelectionCursor (copy), p5 (copy)
		return renderWithSelectionCursor(p5, p6)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p7) -- line: 123
	-- upvalues: NavigateUp (copy)
	return {
		navigateUp = function() -- line: 125
			-- upvalues: p7 (copy), NavigateUp (copy)
			p7(NavigateUp)
		end
	}
end)(Page)
