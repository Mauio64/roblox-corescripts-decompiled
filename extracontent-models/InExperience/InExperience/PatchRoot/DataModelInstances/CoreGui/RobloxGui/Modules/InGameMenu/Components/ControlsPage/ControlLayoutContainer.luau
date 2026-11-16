local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

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

local parent = script.Parent.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)

local ThemedTextLabel = require(script.Parent.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Parent.Divider)

local NavigateBack = require(parent.Actions.NavigateBack)

local withLocalization = require(parent.Localization.withLocalization)

local Assets = require(parent.Resources.Assets)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Image = Foundation.Image

local v3 = t.strictInterface({
	titleText = t.string,
	[Roact.Children] = t.optional(t.table),
	onClosed = t.callback,
	closeButtonRef = t.optional(t.table)
})

local function ControlLayoutContainerWithSelectionCursor(props, callback)
	if GlobalConfig.propValidation then
		assert(v3(props))
	end

	return withLocalization({ titleText = props.titleText })(function(p)
		return withFoundationOrUIBloxStyle(function(p2)
			return {
				Theme = {
					Overlay = {
						Color = p2.Color.Common.Scrim.Color3,
						Transparency = p2.Color.Common.Scrim.Transparency
					}
				}
			}
		end, function(p2)
			local createElement = Roact.createElement
			local v4 = {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = p2.Theme.Overlay.Color,
				BackgroundTransparency = 0,
				Active = true
			}

			local v5 = {
				PageContent = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, -132),
						Position = UDim2.new(0, 0, 0, 132),
						ClipsDescendants = true
					},
					props[Roact.Children]
				),
				HeaderContainer = 0,
				RadialGlowBig = 0,
				RadialGlowSquashed = 0
			}

			local createElement2 = Roact.createElement
			local v6 = { Size = UDim2.new(1, 0, 0, 132), BackgroundTransparency = 1 }

			local children = {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 95),
					PaddingRight = UDim.new(0, 95)
				}),
				CloseButton = 0,
				HeaderTextLabel = 0,
				HeaderDivider = 0
			}
			local closeButton

			if FFlagCoreUiMigrateUIBloxToFoundation then
				closeButton = Roact.createElement(Image, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0, 100),
					Size = UDim2.new(0, 36, 0, 36),
					backgroundStyle = { Transparency = 1 },
					Image = Assets.Images.CloseModal,
					selection = { SelectionImageObject = callback(v2.RoundedRect) },
					onActivated = props.onClosed,
					ref = props.closeButtonRef
				})
			else
				closeButton = Roact.createElement(ImageSetButton, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0, 100),
					Size = UDim2.new(0, 36, 0, 36),
					Image = Assets.Images.CloseModal,
					BackgroundTransparency = 1,
					SelectionImageObject = callback(v2.RoundedRect),
					[Roact.Event.Activated] = props.onClosed,
					[Roact.Ref] = props.closeButtonRef
				})
			end

			children.CloseButton = closeButton

			children.HeaderTextLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header1",
				themeKey = "TextEmphasis",
				Size = UDim2.new(0, 250, 0, 28),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0, 100),
				Text = p.titleText
			})

			children.HeaderDivider = Roact.createElement(Divider, {
				Size = UDim2.new(1, 0, 0, 2),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0)
			})
			v5.HeaderContainer = createElement2("Frame", v6, children)
			local radialGlowBig

			if FFlagCoreUiMigrateUIBloxToFoundation then
				radialGlowBig = Roact.createElement(Image, {
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					backgroundStyle = { Transparency = 1 },
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 1, 0)
				})
			else
				radialGlowBig = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 1, 0)
				})
			end

			v5.RadialGlowBig = radialGlowBig
			local radialGlowSquashed

			if FFlagCoreUiMigrateUIBloxToFoundation then
				radialGlowSquashed = Roact.createElement(Image, {
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 1, 0),
					backgroundStyle = { Transparency = 1 },
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 0.6, 0)
				})
			else
				radialGlowSquashed = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.RadialGlow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 1, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Size = UDim2.new(1, 0, 0.6, 0)
				})
			end

			v5.RadialGlowSquashed = radialGlowSquashed
			return createElement("Frame", v4, v5)
		end)
	end)
end

local function ControlLayoutContainer(p)
	return v(function(p2)
		return ControlLayoutContainerWithSelectionCursor(p, p2)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		onClosed = function()
			callback(NavigateBack())
		end
	}
end)(ControlLayoutContainer)
