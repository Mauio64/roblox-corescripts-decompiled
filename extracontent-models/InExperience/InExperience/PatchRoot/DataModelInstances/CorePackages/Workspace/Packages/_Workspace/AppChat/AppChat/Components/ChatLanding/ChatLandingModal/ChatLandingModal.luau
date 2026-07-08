local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local v3 = require(AppChat.Logger):new(script.Name)

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local Enum2 = UIBlox.App.Button.Enum
local Label = require(AppChat.Components.Label.Label)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Foundation = require(AppChatParent.Foundation)
local v14 = UIBlox.App.ImageSet.Images["icons/actions/favoriteOn"]
local IconNameX = Foundation.Enums.IconName.X
local t3 = {
	[AppChatNetworking.Constants.ModalContentType.Link] = function(t1: {[any]: any}) -- line: 32
		-- upvalues: useStyle (copy), React (copy)
		local v19 = useStyle()

		return React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = t1.layoutOrder,
			Font = v19.Font.Body.Font,
			BorderSizePixel = 0,
			Text = `<u>{ t1.content.text }</u>`,
			RichText = true,
			TextColor3 = v19.Theme.TextDefault.Color,
			TextSize = v19.Font.CaptionBody.RelativeSize * v19.Font.BaseSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Event.Activated] = t1.content.onActivated
		})
	end,
	[AppChatNetworking.Constants.ModalContentType.Text] = function(t2: {[any]: any}) -- line: 50
		-- upvalues: useStyle (copy), React (copy)
		local v21 = useStyle()

		return React.createElement("TextLabel", {
			BorderSizePixel = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = t2.layoutOrder,
			Font = v21.Font.Body.Font,
			Text = t2.content.text,
			TextColor3 = v21.Theme.TextDefault.Color,
			TextSize = v21.Font.CaptionBody.RelativeSize * v21.Font.BaseSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})
	end
}
local t4 = {
	titleText = "",
	bodyText = "",
	actionText = "",
	paddingX = 12,
	hideActionButton = false,
	additionalContent = {},
	buttonType = Enum2.ButtonType.PrimarySystem,
	onActivated = function() -- line: 99
	end,
	onDismissed = function() -- line: 100
	end
}

return React.forwardRef(function(t5: {[any]: any}, p1) -- line: 103
	-- upvalues: Cryo (copy), t4 (copy), useStyle (copy), useChatPagePadding (copy), Foundation (copy), React (copy), t3 (copy), v3 (copy), Label (copy), v14 (copy), IconNameX (copy), ButtonStack (copy)
	local v24 = Cryo.Dictionary.join(t4, t5)
	local v25 = useStyle()
	local v26 = v24.style or v25
	local v27 = useChatPagePadding()
	local Size_200 = v26.Tokens.Size.Size_200
	local Size_1000 = v26.Tokens.Size.Size_1000
	local Size_600 = Foundation.Hooks.useTokens().Size.Size_600
	local v31, v32 = React.useMemo(function() -- line: 114
		-- upvalues: Cryo (copy), v24 (copy), t3 (copy), React (copy), v3 (copy)
		local v33 = Cryo.Dictionary.map(v24.additionalContent, function(p2, n1: number) -- line: 115
			-- upvalues: t3 (copy), React (copy), v3 (copy)
			local v36 = t3[p2.type]
			local v37 = n1 + 2
			local v38 = if not v36 then nil else React.createElement(v36, {
				layoutOrder = v37,
				content = p2
			})

			if v38 then
				return v38, `additionalContent_{ n1 }`
			end

			v3:warning(`Unsupported additional content type: { p2.type }`)

			return nil, nil
		end)

		return v33, not Cryo.isEmpty(v33)
	end, { v24.additionalContent })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v24.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = p1
	}, {
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Size_200),
			PaddingBottom = UDim.new(0, Size_200),
			PaddingLeft = UDim.new(0, v27.left),
			PaddingRight = UDim.new(0, v27.right)
		}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = v26.Theme.SystemPrimaryContent.Transparency,
			BackgroundColor3 = v26.Theme.SystemPrimaryContent.Color,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, Size_200 * 2)
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v26.Tokens.Radius.Medium)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = v26.Tokens.Stroke.Standard,
				Color = v26.Theme.Divider.Color,
				Transparency = v26.Theme.Divider.Transparency
			}),
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, Size_200),
				PaddingBottom = UDim.new(0, Size_200),
				PaddingLeft = UDim.new(0, Size_200),
				PaddingRight = UDim.new(0, Size_200)
			}),
			IconAndTextFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				HorizontalLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, Size_200)
				}),
				TextFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, -Size_600 - Size_200, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, Size_200)
					}),
					LabelAndTextFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, Size_200)
						}),
						TitleLabelWithIcon = if v24.titleLabelText then React.createElement(Label, {
							layoutOrder = 1,
							bodyText = v24.titleLabelText,
							iconImage = v14
						}) else nil,
						TitleTextLabel = React.createElement("TextLabel", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							TextWrapped = true,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							Font = v26.Font.Title.Font,
							Text = v24.titleText,
							TextColor3 = v26.Theme.TextEmphasis.Color,
							TextSize = v26.Font.Header2.RelativeSize * v26.Font.BaseSize,
							TextXAlignment = Enum.TextXAlignment.Left,
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							UIFlexItem = React.createElement("UIFlexItem", {
								FlexMode = Enum.UIFlexMode.Fill
							})
						})
					}),
					BodyTextLabel = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Font = v26.Font.Body.Font,
						Text = v24.bodyText,
						TextColor3 = v26.Theme.TextDefault.Color,
						TextSize = v26.Font.CaptionBody.RelativeSize * v26.Font.BaseSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					AdditionalContent = if not v32 then nil else React.createElement(React.Fragment, {}, v31)
				}),
				ImageIcon = React.createElement(Foundation.View, {
					LayoutOrder = 2,
					tag = "auto-xy x-default-transparent radius-xsmall",
					onActivated = v24.onDismissed
				}, {
					Icon = React.createElement(Foundation.Icon, {
						size = Size_600,
						name = IconNameX
					})
				})
			}),
			Buttons = if not v24.hideActionButton then React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, Size_1000)
			}, {
				ButtonStack = React.createElement(ButtonStack, {
					forcedFillDirection = Enum.FillDirection.Horizontal,
					buttons = {{
						buttonType = v24.buttonType,
						props = {
							onActivated = v24.onActivated,
							text = v24.actionText
						}
					}}
				})
			}) else nil
		})
	})
end)
