local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(script.Parent.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Parent.Divider)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local withLocalization = require(ParentParent.Localization.withLocalization)
local Assets = require(ParentParent.Resources.Assets)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v21 = t.strictInterface({
	titleText = t.string,
	[Roact.Children] = t.optional(t.table),
	onClosed = t.callback,
	closeButtonRef = t.optional(t.table)
})

local function ControlLayoutContainerWithSelectionCursor(p1, p2) -- line: 48
	-- upvalues: GlobalConfig (copy), v21 (copy), withLocalization (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), CursorKind (copy), ImageSetButton (copy), ThemedTextLabel (copy), Divider (copy), ImageSetLabel (copy)
	if GlobalConfig.propValidation then
		assert(v21(p1))
	end

	return withLocalization({
		titleText = p1.titleText
	})(function(p3) -- line: 55
		-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), p1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), p2 (copy), CursorKind (copy), ImageSetButton (copy), ThemedTextLabel (copy), Divider (copy), ImageSetLabel (copy)
		return withFoundationOrUIBloxStyle(function(p4) -- line: 56
			return {
				Theme = {
					Overlay = {
						Color = p4.Color.Common.Scrim.Color3,
						Transparency = p4.Color.Common.Scrim.Transparency
					}
				}
			}
		end, function(p5) -- line: 62
			-- upvalues: Roact (copy), p1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), p2 (copy), CursorKind (copy), ImageSetButton (copy), ThemedTextLabel (copy), p3 (copy), Divider (copy), ImageSetLabel (copy)
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
						SelectionImageObject = p2(CursorKind.RoundedRect),
						[Roact.Event.Activated] = p1.onClosed,
						[Roact.Ref] = p1.closeButtonRef
					}) else Roact.createElement(Image, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0, 100),
						Size = UDim2.new(0, 36, 0, 36),
						Image = Assets.Images.CloseModal,
						selection = {
							SelectionImageObject = p2(CursorKind.RoundedRect)
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
				RadialGlowBig = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 1, 0)
				}),
				RadialGlowSquashed = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 1, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 0.6, 0)
				})
			})
		end)
	end)
end
local function ControlLayoutContainer(p6) -- line: 151
	-- upvalues: withSelectionCursorProvider (copy), ControlLayoutContainerWithSelectionCursor (copy)
	return withSelectionCursorProvider(function(p7) -- line: 152
		-- upvalues: ControlLayoutContainerWithSelectionCursor (copy), p6 (copy)
		return ControlLayoutContainerWithSelectionCursor(p6, p7)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p8) -- line: 157
	-- upvalues: NavigateBack (copy)
	return {
		onClosed = function() -- line: 159
			-- upvalues: p8 (copy), NavigateBack (copy)
			p8(NavigateBack())
		end
	}
end)(ControlLayoutContainer)
