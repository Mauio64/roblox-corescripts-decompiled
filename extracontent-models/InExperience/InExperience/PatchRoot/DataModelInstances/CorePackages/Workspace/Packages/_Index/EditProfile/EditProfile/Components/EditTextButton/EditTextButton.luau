local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local Foundation = require(EditProfileParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local FFlagMoveInExperienceModeToEditProfile = require(EditProfileParent.SharedFlags).FFlagMoveInExperienceModeToEditProfile
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)

local function EditTextButton(t1: {[any]: any}) -- line: 37
	-- upvalues: useStyle (copy), React (copy), FFlagMoveInExperienceModeToEditProfile (copy), StyledTextLabel (copy), FFlagEditProfileFixFocusNavigation (copy), ImageSetLabel (copy), Images (copy), Skeleton (copy), EnumsRadius (copy)
	local v16 = useStyle()
	local Font = v16.Font
	local Theme = v16.Theme

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.new(0, 1, 0),
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}),
		Title = if not (not not FFlagMoveInExperienceModeToEditProfile and t1.title) and FFlagMoveInExperienceModeToEditProfile then nil else React.createElement(StyledTextLabel, {
			layoutOrder = 1,
			text = t1.title,
			fontStyle = Font.Header2,
			colorStyle = Theme.TextEmphasis
		}),
		Description = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			lineHeight = 1,
			text = t1.description,
			fontStyle = Font.CaptionBody,
			colorStyle = Theme.TextDefault,
			automaticSize = Enum.AutomaticSize.Y,
			size = UDim2.new(1, 0, 0, 0)
		}),
		EditButton = if t1.shouldShimmerName then nil else React.createElement("ImageButton", {
			AutomaticSize = if not t1.expandSizing then nil else Enum.AutomaticSize.Y,
			LayoutOrder = 3,
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 0, 52),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color,
			[React.Event.Activated] = t1.onActivated,
			ref = if not FFlagEditProfileFixFocusNavigation then nil else t1.forwardRef
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			InititialTextContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -40, 0, 28),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				InitialText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 1, 0),
					TextYAlignment = Enum.TextYAlignment.Center,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = Font.BaseSize * Font.Body.RelativeSize,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = t1.placeHolderText,
					Font = Font.Body.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextTransparency = if not t1.transparentText then nil else 0.5
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, 60)
					})
				})
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12)
			}),
			Icon = if not (not not FFlagMoveInExperienceModeToEditProfile and t1.onActivated) and FFlagMoveInExperienceModeToEditProfile then nil else React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Image = Images["icons/actions/edit/edit"],
				ImageColor3 = Theme.IconEmphasis.Color,
				Size = UDim2.new(0, 28, 0, 28),
				Position = UDim2.new(1, 0, 0, 12)
			})
		}),
		ShimmerButton = if not t1.shouldShimmerName then nil else React.createElement(Skeleton, {
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 52),
			radius = EnumsRadius.Medium
		})
	})
end

return EditTextButton
