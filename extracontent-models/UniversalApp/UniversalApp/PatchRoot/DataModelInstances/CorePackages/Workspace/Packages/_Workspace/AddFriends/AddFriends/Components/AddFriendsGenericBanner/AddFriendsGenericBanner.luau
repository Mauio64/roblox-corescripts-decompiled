local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local ImageSetLabel = require(Parent.UIBlox).Core.ImageSet.ImageSetLabel
local Foundation = require(Parent.Foundation)
local Skeleton = Foundation.Skeleton
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function AddFriendsGenericBanner(t1: {[any]: any}) -- line: 44
	-- upvalues: React (copy), View (copy), ImageSetLabel (copy), FoundationText (copy), Skeleton (copy), Icon (copy), IconSize (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local layoutOrder = t1.layoutOrder
	local maxWidth = t1.maxWidth
	local onBannerMounted = t1.onBannerMounted
	local onActivated = t1.onActivated
	local v19 = not not t1.bannerIcon
	local bannerIcon = t1.bannerIcon
	local bannerTitle = t1.bannerTitle
	local bannerText = t1.bannerText
	local titleFont = t1.titleFont
	local textFont = t1.textFont
	local rightCornerButtonIcon = t1.rightCornerButtonIcon
	local rightCornerButtonIcon2 = t1.rightCornerButtonIcon
	local rightCornerButtonActivated = t1.rightCornerButtonActivated
	local bigBottomButton = t1.bigBottomButton

	React.useEffect(function() -- line: 66
		-- upvalues: onBannerMounted (copy)
		if onBannerMounted then
			onBannerMounted()
		end
	end, {})

	return React.createElement(View, {
		tag = "col size-full-0 auto-y align-x-center radius-medium bg-surface-300 auto-y padding-medium gap-xlarge",
		onActivated = onActivated,
		LayoutOrder = layoutOrder
	}, {
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(maxWidth, 1e999)
		}),
		InfoContent = React.createElement(View, {
			tag = "size-full-0 auto-y row flex-x-fill gap-medium"
		}, {
			BannerIconView = v19 and React.createElement(View, {
				tag = "auto-xy padding-y-xsmall padding-x-xsmall",
				LayoutOrder = 1
			}, {
				BannerIcon = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 48, 0, 48),
					Image = bannerIcon
				})
			}) or nil,
			TextContent = React.createElement(View, {
				tag = "auto-xy align-x-left",
				LayoutOrder = 2
			}, {
				TextVertical = React.createElement(View, {
					tag = {
						["col size-full-0 auto-y gap-small"] = true,
						["padding-small"] = v19
					}
				}, {
					BannerTitle = React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = {
							["auto-y size-full-0 text-align-x-left content-emphasis"] = true,
							[titleFont or "text-label-large"] = true
						},
						Text = bannerTitle
					}),
					BannerText = if not t1.isLoading then React.createElement(FoundationText, {
						LayoutOrder = 2,
						tag = {
							["auto-y size-full-0 text-align-x-left text-wrap"] = true,
							[textFont or "text-body-small"] = true
						},
						Text = bannerText
					}) else React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 30)
					})
				})
			}),
			RightCornerButton = rightCornerButtonIcon and React.createElement(View, {
				tag = "auto-xy radius-xsmall",
				LayoutOrder = 3,
				onActivated = rightCornerButtonActivated
			}, {
				RightCornerButtonIcon = React.createElement(Icon, {
					size = IconSize.Large,
					name = rightCornerButtonIcon2
				})
			}) or nil
		}),
		BannerButton = if not bigBottomButton then nil else React.createElement(Button, {
			width = UDim.new(1, 0),
			variant = ButtonVariant.Standard,
			size = InputSize.Medium,
			text = bigBottomButton.text,
			onActivated = bigBottomButton.onActivated
		})
	})
end

return AddFriendsGenericBanner
