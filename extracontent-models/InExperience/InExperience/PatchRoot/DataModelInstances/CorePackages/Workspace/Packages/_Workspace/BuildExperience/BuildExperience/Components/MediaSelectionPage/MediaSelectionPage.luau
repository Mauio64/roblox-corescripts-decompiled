local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local MediaSelector = require(script.Parent.MediaSelector)
require(script.Parent.types)

local function IconThumbnailsSheet(p)
	local title = useLocalization({ title = LocalizationStrings.MEDIA_SELECTION_TITLE }).title
	local ref = React.useRef(nil)

	local onActivated = React.useCallback(function()
		if ref.current then
			ref.current()
		else
			p.onClose()
		end
	end, { p.onClose })

	return React.createElement(View, { tag = "col size-full bg-surface-0" }, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium"] = true
			}
		}, {
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = IconName.ChevronLargeLeft,
				isCircular = true,
				onActivated = onActivated,
				size = InputSize.Large,
				variant = ButtonVariant.Utility
			}),
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = title,
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis"
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = { ["shrink size-full"] = true }
		}, {
			MediaSelector = React.createElement(MediaSelector, {
				universeId = p.universeId,
				onBack = p.onClose,
				backHandlerRef = ref
			})
		})
	})
end

return IconThumbnailsSheet
