local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent.Parent

local withLocalization = require(parent.Localization.withLocalization)

local Assets = require(parent.Resources.Assets)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local FocusHandler = require(parent.Components.Connection.FocusHandler)
local RootedConnection = require(parent.Components.Connection.RootedConnection)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local extended = Roact.PureComponent:extend("LoadingFriendsError")

extended.validateProps = t.strictInterface({ onRetry = t.callback, canCaptureFocus = t.boolean })

function extended:init()
	self.buttonRef = Roact.createRef()
end

function extended.render(p)
	local props = p.props

	return withFoundationOrUIBloxStyle(function(p2)
		local tokens

		if FoundationFontFaceMigration then
			tokens = p2
		end

		return {
			Tokens = tokens,
			Font = {
				BaseSize = 1,
				Body = {
					Font = p2.Typography.BodyLarge.Font,
					RelativeSize = p2.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p2)
		return withLocalization({
			errorOccured = "CoreScripts.InGameMenu.InviteFriends.ErrorOccured"
		})(function(p3)
			local font = p2.Font.Body.Font
			local v = p2.Font.Body.RelativeSize * p2.Font.BaseSize
			local y

			if FoundationFontFaceMigration then
				y = GetTextSize(p3.errorOccured, v, p2.Tokens.Typography.BodyLarge.Font, Vector2.new(304, 1e999), {
					addTemporaryPadding = false
				}).Y
			else
				y = TextService:GetTextSize(p3.errorOccured, v, font, Vector2.new(304, 1e999)).Y
			end

			local createElement = Roact.createElement
			local v2 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 304, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			}
			local children = {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Icon = 0,
				TextContainer = 0,
				RootedConnection = 0
			}
			local icon

			if FFlagCoreUiMigrateUIBloxToFoundation then
				icon = Roact.createElement(Image, {
					Image = Assets.Images.Friends.Image,
					imageRect = {
						offset = Assets.Images.Friends.ImageRectOffset,
						size = Assets.Images.Friends.ImageRectSize
					},
					Size = UDim2.new(0, 64, 0, 64),
					imageStyle = { Color3 = Color3.new(1, 1, 1), Transparency = 0.5 },
					LayoutOrder = 1
				})
			else
				icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.Friends,
					Size = UDim2.new(0, 64, 0, 64),
					ImageTransparency = 0.5,
					LayoutOrder = 1
				})
			end

			children.Icon = icon

			children.TextContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, y + 36),
				LayoutOrder = 2
			}, {
				Text = Roact.createElement(ThemedTextLabel, {
					fontKey = "Body",
					themeKey = "TextEmphasis",
					Text = p3.errorOccured,
					Position = UDim2.new(0, 0, 0, 10),
					Size = UDim2.new(1, 0, 1, -36),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextWrapped = true
				})
			})

			children.RootedConnection = Roact.createElement(RootedConnection, {
				render = function(p4)
					return Roact.createElement(FocusHandler, {
						isFocused = props.canCaptureFocus and p4,
						didFocus = function()
							GuiService.SelectedCoreObject = p.buttonRef:getValue()
						end
					}, {
						RetryButton = p4 and Roact.createElement(Button, {
							buttonType = ButtonType.Secondary,
							layoutOrder = 3,
							size = UDim2.new(1, 0, 0, 48),
							icon = Assets.Images.RetryIcon,
							onActivated = props.onRetry,
							buttonRef = p.buttonRef
						}) or nil
					})
				end
			})
			return createElement("Frame", v2, children)
		end)
	end)
end

return extended
