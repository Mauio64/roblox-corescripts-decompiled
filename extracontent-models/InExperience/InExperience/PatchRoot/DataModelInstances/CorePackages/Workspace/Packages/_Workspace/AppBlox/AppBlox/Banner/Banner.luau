local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local BannerBadge = require(script.Parent.BannerBadge)
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local t1 = {
	isContained = true,
	width = UDim.new(1, 0),
	tags = {
		container = "col auto-y"
	}
}

local function Banner(t2: {[any]: any}) -- line: 48
	-- upvalues: Cryo (copy), t1 (copy), React (copy), Button (copy), Foundation (copy), BannerBadge (copy), IconButton (copy), View (copy), Icon (copy), FoundationImage (copy), FoundationText (copy)
	local v15 = Cryo.Dictionary.join(t1, t2)
	local s1 = "col auto-y"

	if v15.isContained then
		s1 ..= " " .. "radius-medium padding-large stroke-standard stroke-default bg-shift-100"
	end

	local v17 = v15.badges and #v15.badges > 0
	local v18 = v15.buttons and (#v15.buttons < 2 and (not v15.image and (not v15.body and (not v17 and not v15.onDismiss))))
	local v19 = React.useMemo(function() -- line: 63
		-- upvalues: v15 (copy), React (copy), Button (copy), Cryo (copy), Foundation (copy)
		local t3 = {}

		if v15.buttons and #v15.buttons > 0 then
			for v23, v24 in v15.buttons do
				t3["banner-button-" .. v23] = React.createElement(Button, Cryo.Dictionary.join({
					LayoutOrder = v23 + 1,
					size = Foundation.Enums.InputSize.Small,
					testId = "--banner-button-" .. v23
				}, v24))
			end
		end

		return t3
	end, { v15.buttons })
	local v20 = React.useMemo(function() -- line: 80
		-- upvalues: v15 (copy), React (copy), BannerBadge (copy), Cryo (copy)
		local t4 = {}

		if v15.badges then
			for i, v in ipairs(v15.badges) do
				t4["banner-badge-" .. i] = React.createElement(BannerBadge, Cryo.Dictionary.join({
					testId = "--banner-badge-" .. i,
					LayoutOrder = i + 1
				}, v))
			end
		end

		return t4
	end, { v15.badges })
	local v21 = React.useMemo(function() -- line: 96
		-- upvalues: v15 (copy), React (copy), IconButton (copy), v17 (copy), Foundation (copy)
		if not v15.onDismiss then
			return nil
		end

		return (React.createElement(IconButton, {
			isCircular = true,
			testId = not v17 and "--banner-dismiss" or "--banner-badges-dismiss",
			LayoutOrder = not v17 and 3 or 1,
			icon = Foundation.Enums.IconName.XSmall,
			variant = Foundation.Enums.ButtonVariant.Utility,
			onActivated = v15.onDismiss
		}))
	end, {
		v15.onDismiss,
		v17
	})

	return React.createElement(View, {
		testId = "--banner",
		LayoutOrder = v15.LayoutOrder,
		Size = UDim2.new(v15.width.Scale, v15.width.Offset, 0, 0),
		tag = s1
	}, {
		BadgesRow = if not v17 then nil else React.createElement(View, {
			tag = "row auto-y size-full-0 flex-between gap-large align-y-center padding-bottom-large",
			LayoutOrder = 2
		}, {
			Badges = React.createElement(View, {
				LayoutOrder = 1,
				testId = "--banner-badges",
				tag = "row auto-xy gap-small fill"
			}, v20),
			Dismiss = if not v21 then nil else React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = 2
			}, {
				Dismiss = v21
			})
		}),
		ContentRow = React.createElement(View, {
			LayoutOrder = 3,
			tag = {
				["row auto-y size-full-0 gap-large"] = true,
				["align-y-center"] = v18
			}
		}, {
			Icon = if not v15.icon or v15.image then nil else React.createElement(Icon, {
				testId = "--banner-icon",
				LayoutOrder = 1,
				size = Foundation.Enums.IconSize.Large,
				name = v15.icon,
				variant = v15.iconVariant,
				style = v15.iconStyle
			}),
			Image = if not v15.image then nil else React.createElement(View, {
				tag = "auto-xy flex-none bg-shift-100 radius-medium"
			}, {
				Image = React.createElement(FoundationImage, {
					testId = "--banner-image",
					tag = "size-1800",
					Image = v15.image,
					ScaleType = Enum.ScaleType.Fit
				})
			}),
			Content = React.createElement(View, {
				LayoutOrder = 2,
				tag = {
					["auto-xy gap-small align-x-left fill"] = true,
					["col flex-fill"] = not v18,
					["row align-y-center flex-between"] = v18
				}
			}, {
				Title = React.createElement(FoundationText, {
					testId = "--banner-title",
					tag = "auto-xy text-title-medium content-emphasis fill text-wrap text-align-x-left",
					LayoutOrder = 1,
					Text = v15.title
				}),
				InlineButton = if not v18 or (not v15.buttons or not v15.buttons[1]) then nil else React.createElement(Button, Cryo.Dictionary.join({
					tag = "auto-xy shrink",
					LayoutOrder = 2,
					testId = "--banner-button-inline"
				}, v15.buttons[1])),
				Subcontent = if v18 then nil else React.createElement(View, {
					tag = "auto-xy col gap-large shrink",
					LayoutOrder = 2
				}, {
					Body = if not v15.body then nil else React.createElement(FoundationText, {
						testId = "--banner-body",
						tag = "auto-xy text-body-medium content-default text-wrap text-align-x-left",
						LayoutOrder = 1,
						RichText = true,
						Text = v15.body
					}),
					Buttons = React.createElement(View, {
						tag = "row auto-xy grow gap-small wrap",
						LayoutOrder = 2,
						testId = "--banner-buttons"
					}, v19)
				})
			}),
			Dismiss = if v17 then nil else v21
		})
	})
end

return React.memo(Banner)
