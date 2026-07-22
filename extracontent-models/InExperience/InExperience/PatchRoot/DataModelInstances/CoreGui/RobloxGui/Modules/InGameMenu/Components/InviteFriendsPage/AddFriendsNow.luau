local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
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
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v22 = Roact.PureComponent:extend("AddFriendsNow")

v22.validateProps = t.strictInterface({
	switchToPlayers = t.callback,
	canCaptureFocus = t.boolean
})

function v22.init(p1) -- line: 46
	-- upvalues: Roact (copy)
	p1.buttonRef = Roact.createRef()
end
function v22.render(p2) -- line: 50
	-- upvalues: withFoundationOrUIBloxStyle (copy), withLocalization (copy), TextService (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy), RootedConnection (copy), FocusHandler (copy), GuiService (copy), Button (copy), ButtonType (copy)
	local props = p2.props

	return withFoundationOrUIBloxStyle(function(p3) -- line: 53
		return {
			Font = {
				BaseSize = 1,
				Body = {
					Font = p3.Typography.BodyLarge.Font,
					RelativeSize = p3.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p4) -- line: 60
		-- upvalues: withLocalization (copy), TextService (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy), RootedConnection (copy), FocusHandler (copy), props (copy), GuiService (copy), p2 (copy), Button (copy), ButtonType (copy)
		return withLocalization({
			noFriendsText = "CoreScripts.InGameMenu.InviteFriends.NoFriends",
			makeFriendsNow = "CoreScripts.InGameMenu.InviteFriends.MakeFriendsNow"
		})(function(p5) -- line: 64
			-- upvalues: p4 (copy), TextService (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy), RootedConnection (copy), FocusHandler (copy), props (copy), GuiService (copy), p2 (copy), Button (copy), ButtonType (copy)
			local BodyFont = p4.Font.Body.Font
			local v31 = p4.Font.Body.RelativeSize * p4.Font.BaseSize
			local Y = TextService:GetTextSize(p5.noFriendsText, v31, BodyFont, Vector2.new(304, 1e999)).Y

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
				Icon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ImageTransparency = 0.5,
					LayoutOrder = 1,
					Image = Assets.Images.AddFriend,
					Size = UDim2.new(0, 64, 0, 64)
				}) else Roact.createElement(Image, {
					LayoutOrder = 1,
					Image = Assets.Images.AddFriend.Image,
					imageRect = {
						offset = Assets.Images.AddFriend.ImageRectOffset,
						size = Assets.Images.AddFriend.ImageRectSize
					},
					Size = UDim2.new(0, 64, 0, 64),
					imageStyle = {
						Transparency = 0.5,
						Color3 = Color3.new(1, 1, 1)
					}
				}),
				TextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, Y + 20)
				}, {
					Text = Roact.createElement(ThemedTextLabel, {
						fontKey = "Body",
						themeKey = "TextEmphasis",
						TextWrapped = true,
						Text = p5.noFriendsText,
						Position = UDim2.new(0, 0, 0, 4),
						Size = UDim2.new(1, 0, 1, -20),
						TextXAlignment = Enum.TextXAlignment.Center
					})
				}),
				RootedConnection = Roact.createElement(RootedConnection, {
					render = function(p6) -- line: 122
						-- upvalues: Roact (copy), FocusHandler (copy), props (copy), GuiService (copy), p2 (copy), Button (copy), ButtonType (copy), p5 (copy)
						return Roact.createElement(FocusHandler, {
							isFocused = props.canCaptureFocus and p6,
							didFocus = function() -- line: 126
								-- upvalues: GuiService (copy), p2 (copy)
								GuiService.SelectedCoreObject = p2.buttonRef:getValue()
							end
						}, {
							MakeFriendsButton = p6 and Roact.createElement(Button, {
								layoutOrder = 3,
								buttonType = ButtonType.Secondary,
								size = UDim2.new(1, 0, 0, 48),
								text = p5.makeFriendsNow,
								onActivated = props.switchToPlayers,
								buttonRef = p2.buttonRef
							}) or nil
						})
					end
				})
			})
		end)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p7) -- line: 148
	-- upvalues: SetCurrentPage (copy)
	return {
		switchToPlayers = function() -- line: 150
			-- upvalues: p7 (copy), SetCurrentPage (copy)
			p7(SetCurrentPage("Players"))
		end
	}
end)(v22)
