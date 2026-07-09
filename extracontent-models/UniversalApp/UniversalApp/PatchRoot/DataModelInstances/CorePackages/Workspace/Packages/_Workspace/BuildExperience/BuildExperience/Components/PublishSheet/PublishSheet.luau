local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Button = Foundation.Button
local Icon = Foundation.Icon
local List = Foundation.List
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize

local function noop() -- line: 35
end
local function PublishSheet(t1: {[any]: any}) -- line: 37
	-- upvalues: noop (copy), React (copy), Sheet (copy), FoundationText (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), IconVariant (copy), List (copy), InputSize (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v19 = t1.onClose or noop
	local v20 = t1.onPublish or noop
	local v21 = React.useRef(nil)
	local v22, v23 = React.useState("Editing")
	local v24 = v22 == "Publishing"
	local v25 = React.useCallback(function() -- line: 44
		-- upvalues: v21 (copy)
		if v21.current and v21.current.close then
			v21.current.close()
		end
	end, {})
	local v26 = React.useCallback(function() -- line: 50
		-- upvalues: v23 (copy), v19 (copy)
		v23("Editing")
		v19()
	end, { v19 })
	local v27 = React.useCallback(function() -- line: 55
		-- upvalues: v24 (copy), v23 (copy), v20 (copy)
		if v24 then
			return
		end

		v23("Publishing")
		v20()
		v23("Success")
	end, {
		v24,
		v20
	})
	local v28 = v22 == "Success"

	return React.createElement(Sheet.Root, {
		isOpen = t1.isOpen == nil or t1.isOpen,
		sheetRef = v21,
		onClose = v26
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = "Publish game",
				tag = "auto-xy text-heading-small text-truncate-end content-emphasis"
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			Content = if not v28 then React.createElement(List.Root, {
				isContained = false,
				hasDivider = {
					hasDivider = true,
					isInset = false
				},
				size = InputSize.Large
			}, {
				Game = React.createElement(List.Item, {
					LayoutOrder = 1,
					leading = {
						iconName = t1.gameIcon or "rbxthumb://type=GameIcon&id=1818&w=150&h=150"
					},
					title = t1.experienceName or "My Sci-Fi Puzzle",
					onActivated = noop
				}),
				Visibility = React.createElement(List.Item, {
					LayoutOrder = 2,
					title = "Visibility",
					leading = IconName.TwoPeople,
					description = t1.visibility or "Friends only",
					onActivated = noop
				}),
				Tags = React.createElement(List.Item, {
					LayoutOrder = 3,
					title = "Tags",
					leading = IconName.Tag,
					description = t1.tags or "Obby, Strategy, Sci-fi, Puzzle",
					onActivated = noop
				})
			}) else React.createElement(View, {
				tag = "col align-x-center align-y-center gap-medium size-full-0 auto-y padding-y-xlarge"
			}, {
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					tag = "auto-xy content-system-success",
					name = IconName.CircleCheck,
					size = IconSize.XXLarge,
					variant = IconVariant.Filled
				}),
				Title = React.createElement(FoundationText, {
					LayoutOrder = 2,
					Text = "Successfully published",
					tag = "auto-xy text-heading-small text-align-x-center content-emphasis"
				}),
				Description = React.createElement(FoundationText, {
					LayoutOrder = 3,
					Text = "Your game is live and ready to play.",
					tag = "auto-xy text-body-medium text-align-x-center content-default"
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, nil, {
			Close = if not v28 then nil else React.createElement(Button, {
				LayoutOrder = 1,
				text = "Close",
				size = InputSize.Large,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				onActivated = v25
			}),
			Join = if not v28 then nil else React.createElement(Button, {
				LayoutOrder = 2,
				text = "Join",
				size = InputSize.Large,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				onActivated = v25
			}),
			Publish = if v28 then nil else React.createElement(Button, {
				text = "Publish",
				size = InputSize.Large,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isLoading = v24,
				onActivated = v27
			})
		})
	})
end

return PublishSheet
