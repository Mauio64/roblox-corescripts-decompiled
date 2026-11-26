local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/MediaSelector")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/types")

local function IconThumbnailsSheet(p2)
	local title = useLocalization({ title = LocalizationStrings.MEDIA_SELECTION_TITLE }).title
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		if ref.current then
			ref.current()
		else
			p2.onClose()
		end
	end, { p2.onClose })

	return React.createElement(view, { tag = "col size-full bg-surface-0" }, {
		Header = React.createElement(view, {
			LayoutOrder = 1,
			tag = {
				["composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium"] = true
			}
		}, {
			Back = React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.ChevronLargeLeft,
				isCircular = true,
				onActivated = v5,
				size = inputSize.Large,
				variant = buttonVariant.Utility
			}),
			Title = React.createElement(text, {
				LayoutOrder = 2,
				Text = title,
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis"
			})
		}),
		Content = React.createElement(view, {
			LayoutOrder = 2,
			tag = { ["shrink size-full"] = true }
		}, {
			MediaSelector = React.createElement(module4, {
				universeId = p2.universeId,
				onBack = p2.onClose,
				backHandlerRef = ref
			})
		})
	})
end

return IconThumbnailsSheet
