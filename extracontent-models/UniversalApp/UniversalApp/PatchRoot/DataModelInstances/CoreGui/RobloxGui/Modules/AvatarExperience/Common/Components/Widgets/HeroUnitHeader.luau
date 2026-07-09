local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local IconSize = Foundation.Enums.IconSize
local getLocalizedPrice = AvatarExperienceUIKit.Utils.getLocalizedPrice
local useTokens = Foundation.Hooks.useTokens
local TimerBadge = AvatarExperienceUIKit.TimerBadge
local FoundationText = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local v12 = game:DefineFastFlag("AXHeroUnitHeaderWrapText", false)
local v13 = game:DefineFastFlag("AXHeroUnitHeaderCenterAbsolute", false)

local function HeroUnitHeader(t1: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), v12 (copy), React (copy), View (copy), FoundationText (copy), Icon (copy), IconSize (copy), getLocalizedPrice (copy), v13 (copy), TimerBadge (copy)
	local v16 = useTokens()
	local titleText = t1.titleText
	local descriptionText = t1.descriptionText
	local priceInRobux = t1.priceInRobux
	local v20 = descriptionText ~= nil and descriptionText ~= ""
	local titleTag = t1.titleTag
	local descriptionTag = t1.descriptionTag
	local titleGroupGapTag = t1.titleGroupGapTag
	local v24 = if not v12 then `size-full-0 auto-y text-truncate-end text-align-x-left content-emphasis { titleTag }` else `size-full-0 auto-y text-wrap text-align-x-left content-emphasis { titleTag }`
	local v25 = if not v12 then `size-full-0 auto-y text-align-x-left content-default { descriptionTag }` else `size-full-0 auto-y text-wrap text-align-x-left content-default { descriptionTag }`
	local v26 = React.createElement(View, {
		LayoutOrder = 2,
		tag = `col align-x-left size-full-0 auto-y { titleGroupGapTag }`
	}, {
		Title = if not titleText then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = titleText,
			tag = v24
		}),
		Description = if not v20 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = v25,
			Text = descriptionText
		}),
		PriceLine = if priceInRobux == nil then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = "row align-y-center gap-xsmall auto-xy"
		}, {
			RobuxIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = "robux",
				style = v16.Color.Content.Default,
				size = IconSize.Small
			}),
			Price = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-large content-default",
				Text = getLocalizedPrice(priceInRobux)
			})
		})
	})

	if t1.centerTitleGroup then
		if t1.bottomSlot or not v13 then
			return React.createElement(View, {
				tag = "col flex-y-between align-x-left size-full",
				LayoutOrder = t1.LayoutOrder
			}, {
				TopSlot = React.createElement(View, {
					LayoutOrder = 1,
					tag = "auto-xy",
					Size = UDim2.new(0, 0, 0, 0)
				}, {
					Badge = if not t1.availableUntil then nil else React.createElement(TimerBadge, {
						endTime = t1.availableUntil
					})
				}),
				TitleGroup = v26,
				BottomSlot = React.createElement(View, {
					LayoutOrder = 3,
					tag = "auto-xy",
					Size = UDim2.new(0, 0, 0, 0)
				}, {
					Slot = t1.bottomSlot
				})
			})
		end

		return React.createElement(View, {
			tag = "size-full",
			LayoutOrder = t1.LayoutOrder
		}, {
			TopSlot = if not t1.availableUntil then nil else React.createElement(View, {
				tag = "auto-xy",
				Size = UDim2.new(0, 0, 0, 0)
			}, {
				Badge = React.createElement(TimerBadge, {
					endTime = t1.availableUntil
				})
			}),
			TitleGroup = React.createElement(View, {
				tag = "col align-x-left",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Content = v26
			})
		})
	end

	local v27 = t1.badgeGapTag or "gap-large"

	return React.createElement(View, {
		LayoutOrder = t1.LayoutOrder,
		tag = `col align-x-left size-full-0 auto-y { v27 }`
	}, {
		Badge = if not t1.availableUntil then nil else React.createElement(TimerBadge, {
			LayoutOrder = 1,
			endTime = t1.availableUntil
		}),
		TitleGroup = v26,
		BottomSlot = if not t1.bottomSlot then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = "auto-xy",
			Size = UDim2.new(0, 0, 0, 0)
		}, {
			Slot = t1.bottomSlot
		})
	})
end

return HeroUnitHeader
