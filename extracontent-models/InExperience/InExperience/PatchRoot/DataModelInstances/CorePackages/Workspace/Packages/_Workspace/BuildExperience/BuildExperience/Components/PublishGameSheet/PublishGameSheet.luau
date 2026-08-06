local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local Sheet = Foundation.Sheet
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local useScaledValue = Foundation.Hooks.useScaledValue

local function noop() -- line: 29
end
local function PublishGameSheet(t1: {[any]: any}) -- line: 31
	-- upvalues: noop (copy), useScaledValue (copy), React (copy), Skeleton (copy), EnumsRadius (copy), Sheet (copy), FoundationText (copy), LocalizationStrings (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v18 = t1.onClose or noop
	local v19 = useScaledValue(330)
	local t2 = {}

	for i = 1, 3 do
		t2[`Placeholder{ i }`] = React.createElement(Skeleton, {
			LayoutOrder = i,
			radius = EnumsRadius.Medium,
			Size = UDim2.new(1, 0, 0, 48)
		})
	end

	return React.createElement(Sheet.Root, {
		testId = "publish-game-sheet",
		isOpen = t1.isOpen == nil or t1.isOpen,
		snapPoints = { v19 },
		onClose = v18
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-emphasis",
				Text = LocalizationStrings.PUBLISH_GAME_SHEET_TITLE
			})
		}),
		Content = React.createElement(Sheet.Content, nil, t2),
		Actions = React.createElement(Sheet.Actions, nil, {
			ActionsColumn = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y"
			}, {
				PublishButton = React.createElement(Button, {
					LayoutOrder = 1,
					testId = "publish-game-sheet-publish-button",
					text = LocalizationStrings.PUBLISH_GAME_SHEET_PUBLISH,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					onActivated = noop
				}),
				Caption = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-center content-default",
					Text = LocalizationStrings.PUBLISH_GAME_SHEET_CAPTION
				})
			})
		})
	})
end

return PublishGameSheet
