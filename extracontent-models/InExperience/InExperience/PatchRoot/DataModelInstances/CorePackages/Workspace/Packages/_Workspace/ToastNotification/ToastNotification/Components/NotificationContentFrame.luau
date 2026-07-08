local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local context = scriptParentParent.context
local dependencies = require(scriptParentParent.dependencies)
local NotificationStyledText = require(scriptParent.NotificationStyledText)
local NotificationThumbnail = require(scriptParent.NotificationThumbnail)
local ToastHoldButton = require(scriptParent.ToastHoldButton)
local type = require(scriptParentParent.type)
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local constants = require(scriptParentParent.constants)
local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)
local DefaultContentPadding = constants.DefaultContentPadding
local DefaultTextContentPadding = constants.DefaultTextContentPadding
local vector2 = Vector2.new(36, 36)
local utils = scriptParentParent.utils
local isUserThumbnail = require(utils.toastNotificationHelper).isUserThumbnail

return function(t1: {[any]: any}) -- line: 35
	-- upvalues: useStyle (copy), useNotificationCardData (copy), isUserThumbnail (copy), useNotificationCardState (copy), React (copy), constants (copy), DefaultContentPadding (copy), vector2 (copy), NotificationThumbnail (copy), DefaultTextContentPadding (copy), NotificationStyledText (copy), ToastHoldButton (copy), Interactable (copy), ImageSetLabel (copy), type (copy)
	local v24 = useStyle()
	local v25 = v24.Font.BaseSize * v24.Font.CaptionHeader.RelativeSize
	local v26 = v24.Font.BaseSize * v24.Font.CaptionBody.RelativeSize
	local cardSize = useNotificationCardData().cardSize
	local v29

	if isUserThumbnail then
		local v28 = useNotificationCardState("thumbnail")

		v29 = React.useMemo(function() -- line: 46
			-- upvalues: v28 (copy), isUserThumbnail (copy), v24 (copy), cardSize (ref), constants (copy)
			local v39 = false

			if v28 then
				for _, v41 in v28 do
					if not isUserThumbnail(v41) then
						v39 = true

						break
					end
				end
			end

			if not v39 then
				return v24.Tokens.Size.Size_1000
			end

			return cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
		end, {
			v28,
			v24.Tokens.Size.Size_1000,
			cardSize
		})
	else
		v29 = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	end

	local Size_700 = v24.Tokens.Size.Size_700
	local v31 = useNotificationCardState("textBody")
	local v32 = v31 and v31[1]
	local v33 = v32 and (v32.title and {
		LayoutOrder = 1,
		Text = v32.title,
		MaxSize = Vector2.new(1e999, v25 * 2),
		Size = UDim2.new(1, 0, 0, 0),
		TextSize = v25,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = v24.Font.CaptionHeader.Font,
		TextColor3 = v24.Theme.TextEmphasis.Color
	})
	local v34 = v32 and (v32.label and {
		LayoutOrder = 2,
		Text = v32.label,
		MaxSize = Vector2.new(1e999, v26 * 2),
		Size = UDim2.new(1, 0, 0, 0),
		TextSize = v26,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = v24.Font.CaptionBody.Font
	})
	local v35 = useNotificationCardData()

	cardSize = v35.cardSize

	local handleActions = v35.handleActions
	local v37 = useNotificationCardState("singleMetaAction")
	local v38 = v37 and v37[1]

	return React.createElement("Frame", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, DefaultContentPadding)
		}),
		ThumbnailTextContainer = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = if not v38 then UDim2.new(1, 0, 0, 0) else UDim2.new(1, -(DefaultContentPadding + vector2.X), 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, DefaultContentPadding)
			}),
			NotificationThumbnailFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v29, 0, v29)
			}, {
				NotificationThumbnail = React.createElement(NotificationThumbnail)
			}),
			ToastTextFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = if not t1.showHoldButton then UDim2.new(1, -(v29 + DefaultContentPadding), 0, 0) else UDim2.new(1, -(v29 + DefaultContentPadding * 2 + Size_700), 0, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 2)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, DefaultTextContentPadding)
				}),
				ToastTitle = v33 and React.createElement(NotificationStyledText, v33),
				ToastSubtitle = v34 and React.createElement(NotificationStyledText, v34)
			}),
			ToastHoldButton = React.createElement(ToastHoldButton, {
				layoutOrder = 3,
				iconSize = Size_700,
				visible = t1.showHoldButton,
				iconTransparency = not t1.shouldAutoFocus and 0 or 0.5,
				progress = t1.holdProgress
			})
		}),
		SingleMetaAction = if not v38 then nil else React.createElement(Interactable, {
			AutoButtonColor = false,
			BackgroundColor3 = v24.Theme.UIMuted.Color,
			BackgroundTransparency = 0.9,
			LayoutOrder = 2,
			onStateChanged = function() -- line: 171
			end,
			[React.Event.Activated] = function() -- line: 172
				-- upvalues: handleActions (copy), v38 (copy)
				if handleActions then
					handleActions(v38)
				end
			end,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			Icon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = type.MetaActionIcons[v38.actionIcon],
				ImageColor3 = v24.Theme.IconEmphasis.Color,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(28, 28)
			})
		})
	})
end
