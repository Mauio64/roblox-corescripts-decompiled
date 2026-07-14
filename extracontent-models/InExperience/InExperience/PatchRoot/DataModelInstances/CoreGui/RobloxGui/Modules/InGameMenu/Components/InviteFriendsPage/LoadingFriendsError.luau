local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local FocusHandler = require(ParentParent.Components.Connection.FocusHandler)
local RootedConnection = require(ParentParent.Components.Connection.RootedConnection)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v18 = Roact.PureComponent:extend("LoadingFriendsError")

v18.validateProps = t.strictInterface({
	onRetry = t.callback,
	canCaptureFocus = t.boolean
})

function v18.init(p1) -- line: 38
	-- upvalues: Roact (copy)
	p1.buttonRef = Roact.createRef()
end
function v18.render(p2) -- line: 42
	-- upvalues: withFoundationOrUIBloxStyle (copy), withLocalization (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), RootedConnection (copy), FocusHandler (copy), GuiService (copy), Button (copy), ButtonType (copy)
	local props = p2.props

	return withFoundationOrUIBloxStyle(function(p3) -- line: 45
		return {
			Font = {
				BaseSize = 1,
				Body = {
					Font = p3.Typography.BodyLarge.Font,
					RelativeSize = p3.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p4) -- line: 52
		-- upvalues: withLocalization (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), RootedConnection (copy), FocusHandler (copy), props (copy), GuiService (copy), p2 (copy), Button (copy), ButtonType (copy)
		return withLocalization({
			errorOccured = "CoreScripts.InGameMenu.InviteFriends.ErrorOccured"
		})(function(p5) -- line: 55
			-- upvalues: p4 (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), RootedConnection (copy), FocusHandler (copy), props (copy), GuiService (copy), p2 (copy), Button (copy), ButtonType (copy)
			local BodyFont = p4.Font.Body.Font
			local v26 = p4.Font.Body.RelativeSize * p4.Font.BaseSize
			local Y = TextService:GetTextSize(p5.errorOccured, v26, BodyFont, Vector2.new(304, 1e999)).Y

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 304, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ImageTransparency = 0.5,
					LayoutOrder = 1,
					Image = Assets.Images.Friends,
					Size = UDim2.new(0, 64, 0, 64)
				}),
				TextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, Y + 36)
				}, {
					Text = Roact.createElement(ThemedTextLabel, {
						fontKey = "Body",
						themeKey = "TextEmphasis",
						TextWrapped = true,
						Text = p5.errorOccured,
						Position = UDim2.new(0, 0, 0, 10),
						Size = UDim2.new(1, 0, 1, -36),
						TextXAlignment = Enum.TextXAlignment.Center
					})
				}),
				RootedConnection = Roact.createElement(RootedConnection, {
					render = function(p6) -- line: 105
						-- upvalues: Roact (copy), FocusHandler (copy), props (copy), GuiService (copy), p2 (copy), Button (copy), ButtonType (copy), Assets (copy)
						return Roact.createElement(FocusHandler, {
							isFocused = props.canCaptureFocus and p6,
							didFocus = function() -- line: 109
								-- upvalues: GuiService (copy), p2 (copy)
								GuiService.SelectedCoreObject = p2.buttonRef:getValue()
							end
						}, {
							RetryButton = p6 and Roact.createElement(Button, {
								layoutOrder = 3,
								buttonType = ButtonType.Secondary,
								size = UDim2.new(1, 0, 0, 48),
								icon = Assets.Images.RetryIcon,
								onActivated = props.onRetry,
								buttonRef = p2.buttonRef
							}) or nil
						})
					end
				})
			})
		end)
	end)
end

return v18
