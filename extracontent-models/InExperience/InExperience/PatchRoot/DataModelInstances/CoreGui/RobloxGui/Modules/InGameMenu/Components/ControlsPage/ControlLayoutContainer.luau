local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v11 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(script.Parent.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Parent.Divider)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local withLocalization = require(ParentParent.Localization.withLocalization)
local Assets = require(ParentParent.Resources.Assets)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FoundationImage = Foundation.Image
local v22 = t.strictInterface({
	titleText = t.string,
	[Roact.Children] = t.optional(t.table),
	onClosed = t.callback,
	closeButtonRef = t.optional(t.table)
})

local function ControlLayoutContainerWithSelectionCursor(p1, p2) -- line: 53
	-- upvalues: GlobalConfig (copy), v22 (copy), withLocalization (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), v11 (copy), ImageSetButton (copy), ThemedTextLabel (copy), Divider (copy), ImageSetLabel (copy)
	if GlobalConfig.propValidation then
		assert(v22(p1))
	end

	return withLocalization({
		titleText = p1.titleText
	})(function(p3) -- line: 60
		-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), p1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), p2 (copy), v11 (copy), ImageSetButton (copy), ThemedTextLabel (copy), Divider (copy), ImageSetLabel (copy)
		return withFoundationOrUIBloxStyle(function(p4) -- line: 61
			return {
				Theme = {
					Overlay = {
						Color = p4.Color.Common.Scrim.Color3,
						Transparency = p4.Color.Common.Scrim.Transparency
					}
				}
			}
		end, function(p5) -- line: 70
			-- upvalues: Roact (copy), p1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Assets (copy), p2 (copy), v11 (copy), ImageSetButton (copy), ThemedTextLabel (copy), p3 (copy), Divider (copy), ImageSetLabel (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				Active = true,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = p5.Theme.Overlay.Color
			}, {
				PageContent = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 1, -132),
					Position = UDim2.new(0, 0, 0, 132)
				}, p1[Roact.Children]),
				HeaderContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 132)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 95),
						PaddingRight = UDim.new(0, 95)
					}),
					CloseButton = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetButton, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0, 100),
						Size = UDim2.new(0, 36, 0, 36),
						Image = Assets.Images.CloseModal,
						BackgroundTransparency = 1,
						SelectionImageObject = p2(v11.RoundedRect),
						[Roact.Event.Activated] = p1.onClosed,
						[Roact.Ref] = p1.closeButtonRef
					}) else Roact.createElement(FoundationImage, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0, 100),
						Size = UDim2.new(0, 36, 0, 36),
						backgroundStyle = {
							Transparency = 1
						},
						Image = Assets.Images.CloseModal,
						selection = {
							SelectionImageObject = p2(v11.RoundedRect)
						},
						onActivated = p1.onClosed,
						ref = p1.closeButtonRef
					}),
					HeaderTextLabel = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						Size = UDim2.new(0, 250, 0, 28),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0, 100),
						Text = p3.titleText
					}),
					HeaderDivider = Roact.createElement(Divider, {
						Size = UDim2.new(1, 0, 0, 2),
						AnchorPoint = Vector2.new(0.5, 1),
						Position = UDim2.new(0.5, 0, 1, 0)
					})
				}),
				RadialGlowBig = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 1, 0)
				}) else Roact.createElement(FoundationImage, {
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					backgroundStyle = {
						Transparency = 1
					},
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 1, 0)
				}),
				RadialGlowSquashed = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 1, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 0.6, 0)
				}) else Roact.createElement(FoundationImage, {
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 1, 0),
					backgroundStyle = {
						Transparency = 1
					},
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 0.6, 0)
				})
			})
		end)
	end)
end
local function ControlLayoutContainer(p6) -- line: 182
	-- upvalues: v10 (copy), ControlLayoutContainerWithSelectionCursor (copy)
	return v10(function(p7) -- line: 183
		-- upvalues: ControlLayoutContainerWithSelectionCursor (copy), p6 (copy)
		return ControlLayoutContainerWithSelectionCursor(p6, p7)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p8) -- line: 188
	-- upvalues: NavigateBack (copy)
	return {
		onClosed = function() -- line: 190
			-- upvalues: p8 (copy), NavigateBack (copy)
			p8(NavigateBack())
		end
	}
end)(ControlLayoutContainer)
